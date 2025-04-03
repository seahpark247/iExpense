//
//  AddView.swift
//  iExpense
//
//  Created by Seah Park on 3/24/25.
//

import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    
    var expenses: Expenses
    
    let types = ["Business", "Personal"]
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                
                Section(Locale.current.currency?.identifier ?? "USD") {
                    TextField("Money", value: $amount, format: .number)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Add new expense")
            .toolbar {
                Button("Save") {
                    guard !name.isEmpty && !amount.isZero else { return }
                    
                    let item = ExpenseItem(name: name, type: type, amount: amount)
                    expenses.items.append(item)
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    AddView(expenses: Expenses())
}
