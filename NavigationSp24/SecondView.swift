//
//  SecondView.swift
//  NavigationSp24
//
//  Created by Janaka Balasooriya on 1/22/24.
//

import SwiftUI
import Foundation

struct SecondView: View {
    // access the "dismiss" function from the NavigationView, when called this
    // function will pop the current view from the navigation stack
    @Environment(\.dismiss) var dismiss //Environment var can be access from all views
    
    // this variable stores the data received from ContentView
    var dataFromFirst: Double
    var earthWeight: String
    
    // this binding allows to send data back to the ContentView
    @Binding var dataSecond: String
    var viewNumber:Int
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack{
            Spacer()
            
            
            
            NavigationLink("Go to Jupiter", value: 3)
            .padding()
            .foregroundColor(.blue)
            .border(Color.red, width: 3)
            .cornerRadius(10)
            
            Spacer()
            
            
            
            Button("Go back to Earth") {
                dataSecond = "Coming from the moon"
                //dismiss() // same effect as path.removeLast() below
                path.removeLast() // remove view for the new view to come
                    
            }.padding()
             .foregroundColor(.green)
             .border(Color.red, width: 3)
             .cornerRadius(10)
            
            
            
           
                
            Spacer()
            Text("number of views: \(path.count)")
        }
        .navigationTitle("SecondView")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            print(dataFromFirst)
            
        }
    }
}




#Preview {
    SecondView(dataFromFirst: 0.0, earthWeight: "", dataSecond: .constant(""), viewNumber: 0, path: .constant(NavigationPath()))
}

