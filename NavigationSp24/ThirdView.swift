//
//  ThirdView.swift
//  NavigationSp24
//
//  Created by Janaka Balasooriya on 1/22/24.
//

import SwiftUI

struct ThirdView: View {
    var fromData: Double
    @Binding var path: NavigationPath
    var viewNumber:Int
    var earthWeight: String
    var jupiterWeight: Double
    @Binding var dataSecond: String
    
    var body: some View {
        VStack{
            Text("You are on the Jupiter")
            
            Text("Your weight in Earth is: \(earthWeight)")
            
            Text("Your weight on Moon is: " + String(fromData))
            
            Text("Your weight on Jupiter is: " + String(jupiterWeight))
            
            Spacer()
            Spacer()
            Text("I feel much heavier!")
            
            Button("Go Back to Moon") {
                dataSecond = "Coming from Jupiter"
                path.removeLast()
                //path.removeLast(2) // remove last two view created, go to first view
                    
            }.padding()
             .foregroundColor(.blue)
             .border(Color.red, width: 3)
             .cornerRadius(10)
            
            Button("Go Back to Earth") {
                dataSecond = "Coming from Jupiter"
                //path.removeLast()
                path.removeLast(2) // remove last two view created, go to first view
                    
            }.padding()
             .foregroundColor(.green)
             .border(Color.red, width: 3)
             .cornerRadius(10)
            
            
        
        }
    }
}

#Preview {
    ThirdView(fromData: 0.0, path: .constant(NavigationPath()), viewNumber: 0, earthWeight: "", jupiterWeight: 0.0, dataSecond: .constant(""))
}
