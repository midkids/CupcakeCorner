//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Myron Snelson on 7/25/26.
//

import SwiftUI

private struct ReqResErrorResponse: Decodable {
    let message: String?
    let error: String?
}

struct CheckoutView: View {
    var order: Order
  
    // Added by AI because the reqres server
    // now requires an API key
    private let reqresAPIKey = "free_user_3HF2CxpBvVaEubnbpqRed4L3rEY"
    
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    
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
                
                // Normally a button want to perform
                // an action immediately
                Button("Place order") {
                    // Using this code  - an await
                    // inside a Task - will call
                    // placeOrder asynchronously
                    Task {
                        await placeOrder()
                    }
                }
                    .padding()
            }
        }
        .navigationTitle("Check Out")
        .navigationBarTitleDisplayMode(.inline)
        // allows us to disable the scroll bounce
        // when there is nothing to scroll
        .scrollBounceBehavior(.basedOnSize)
        // alert when showingConfirmation is true
        .alert("Thank you", isPresented: $showingConfirmation) {
            Button("OK") { }
        } message: {
            Text(confirmationMessage)
        }
    }
    
    func placeOrder() async {
        // Required the Order class to conform to the
        // protocol Codable
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }
        // New type of URL Request
        // that gives us extra options
        // to add information (e.g. type of
        // request)
        // We must send to pieces of data over and
        // above our order data
        // 1. The HTTP method of sending data
        // - get to read data and
        // - post to write data
        // 2. MIME type
        // In Swift we must provide a content type
        // which determines what kind of data
        // are we sending
        // Here we will create a new URL Request object,
        // configure it to send JSON data
        // using a Post request and then
        // upload that with our URL session
        // and handle whatever comes back
        //
        // IMPORTANT: We will use a really helpful
        // website called reqres.in
        // It lets us send any data we want
        // for testing purposes and it will
        // automatically send it back to us
        
        // Since we handtyped the URL,
        // and we know it is good, we can use !
        // to force unwrap since the url coming back
        // is optional (make it non-optional)
        // Guard added by me to get rid of the
        // force unwrap
        guard let url = URL(string: "https://reqres.in/api/cupcakes")
         else {
            print("URL failed to initialize")
            return
        }
        // Added by AI because the reqres server
        // now requires an API key
        if reqresAPIKey == "PASTE_YOUR_REQRES_API_KEY_HERE" {
            confirmationMessage = "Add your ReqRes API key in CheckoutView.swift before placing an order."
            showingConfirmation = true
            return
        }
        
        // Create URL request
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Added by AI because the reqres server
        // now requires an API key
        request.setValue(reqresAPIKey, forHTTPHeaderField: "x-api-key")
        request.setValue("prod", forHTTPHeaderField: "X-Reqres-Env")
        
        // We are writing data
        request.httpMethod = "POST"
        
        // Now we are all set to make our network call
        do {
            let (data, response) = try await URLSession.shared.upload(for: request, from: encoded)
            
            // Added by AI because the reqres server
            // now requires an API key
            // This code checks server response for errors
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                let serverMessage = try? JSONDecoder().decode(ReqResErrorResponse.self, from: data)
                confirmationMessage = serverMessage?.message ?? "The server rejected the checkout request."
                showingConfirmation = true
                return
            }
            
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on the way!"
            showingConfirmation = true
        } catch {
            confirmationMessage = "Checkout failed: \(error.localizedDescription)"
            showingConfirmation = true
            print("Checkout failed with error: \(error.localizedDescription)")
        }
    }
}

// The URL Session class makes it easy to send and
// receive data over the Internet
// We will combine that with the Codeable protocol
// to convert Swift objects to and from JSON
// Then wrap that in a URL Request struct to
// customize the way we send data

#Preview {
    // Create an empty order for preview purposes
    NavigationStack {
        CheckoutView(order: Order())
    }
}
