//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Myron Snelson on 7/25/26.
//

import SwiftUI

struct CheckoutView: View {
    var order: Order
    
    var body: some View {
        // Using ScrollView here makes sure out layout
        // looks great no matter what device the user has
        // and more critically no matter what dynamic type
        // they have (e.g. extra large fonts enabled, which
        // may make the CheckoutView not fit the screen)
        ScrollView {
            VStack {
                // Loading this image from the Internet
                // allows us to change the image displayed
                // without changing the program
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height:233)
                // SwiftUI wants to know how to format
                // the number, cost is a decimal
                // not an integer
                // We will format as currency
                Text("Your total cost is: \(order.cost, format: .currency(code: "USD"))")
                    .font(.title)
                
                Button("Place order", action: {})
                    .padding()
            }
        }
        .navigationTitle("Check Out")
        .navigationBarTitleDisplayMode(.inline)
        // allows us to disable the scroll bounce
        // when there is nothing to scroll
        .scrollBounceBehavior(.basedOnSize)
    }
}

#Preview {
    // Create an empty order for preview purposes
    NavigationStack {
        CheckoutView(order: Order())
    }
}
