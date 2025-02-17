//
//  DetailView.swift
//  NavigationSp24
//
//  Created by Janaka Balasooriya on 1/21/24.
//

import SwiftUI

struct DetailView: View {
    let text: String
    @Environment(\.dismiss) var dismiss
    @Binding var dataSecond: String
        var body: some View {
            VStack {
                Text("Detail view showing")
                Text(text)

                Divider()

                NavigationLink("Link to 3", value: 3)
                NavigationLink("Link to C", value: "CCCC")
                
                Button("Go back to ContentView") {
                    dataSecond = "Hello from SecondView"
                    dismiss()
                        
                }.padding()
                 .foregroundColor(.green)
                 .border(Color.red, width: 3)
                 .cornerRadius(10)
            }
            .navigationTitle(text)
        }
}

#Preview {
    DetailView(text: "Test", dataSecond: .constant(""))
}
