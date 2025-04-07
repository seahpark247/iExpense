//
//  ContentView.swift
//  iExpense
//
//  Created by Seah Park on 3/21/25.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    var id = UUID() // universal unique id
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return // exit initializer
            }
        }
        
        items = []
    }
}

struct valueWarning: ViewModifier {
    var value: Double
    
    func body(content: Content) -> some View {
        content.foregroundColor(value < 10 ? .blue : value < 100 ? .green : .red)
    }
}

struct itemsList: View {
    let expenses: Expenses
    let type: String
    
    var filteredItems: [ExpenseItem] {
        expenses.items.filter { $0.type == type }
    }
    
    var body: some View {
        ForEach(filteredItems) { item in
            HStack{
                VStack(alignment: .leading) {
                    Text(item.name).font(.headline)
                }
                
                Spacer()
                
                Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .ValueWarningStyle(item.amount)
            }
        }
        .onDelete(perform: removeItems)
    }
    
    func removeItems(at offsets: IndexSet) {
        let itemsToDelete = offsets.map { filteredItems[$0] }
        
        for item in itemsToDelete {
            if let indexInOriginal = expenses.items.firstIndex(where: { $0.id == item.id }) {
                expenses.items.remove(at: indexInOriginal)
            }
        }
    }
}

extension View {
    func ValueWarningStyle(_ value: Double) -> some View {
        modifier(iExpense.valueWarning(value: value))
    }
}

struct ContentView: View {
    @State private var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("Business") {
                    itemsList(expenses: expenses, type: "Business")
                }
                
                Section("Personal: Limit $100") {
                    itemsList(expenses: expenses, type: "Personal")
                } // 총 합 리밋 따라서 배경색 바뀌기
                .listRowBackground(Color.pink.opacity(0.1))
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button("Add Expense", systemImage: "plus") {
                    showingAddExpense = true
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)
            }
        }
    }
    
}

#Preview {
    ContentView()
}
