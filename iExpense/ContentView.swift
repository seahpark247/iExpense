//
//  ContentView.swift
//  iExpense
//
//  Created by Seah Park on 3/21/25.
//

import SwiftUI

@Observable
class User {
    var firstName = "bilbo"
    var lastName = "baggins"
}

struct ContentView: View {
    @State private var user = User()
    
    var body: some View {
        VStack {
            Text("Your name is \(user.firstName) \(user.lastName).")
            
            TextField("First name", text: $user.firstName)
            TextField("Last name", text: $user.lastName)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
