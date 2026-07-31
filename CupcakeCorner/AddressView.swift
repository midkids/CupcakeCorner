//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Myron Snelson on 7/24/26.
//
// In this view, we will let the user enter
// a form with some validation  
import SwiftUI

struct AddressView: View {
    // IMPORTANT: We cannot use @State here
    // for the order variable because we are
    // NOT making a new instance of the Order class
    // The order is being passed to us here
    // We know this Order class is using the @Observable
    // macro causing SwiftUI to watch for changes
    // The @Bindable property creates the missing
    // two-way bindings for us that are able to
    // work with an @Observable object WITHOUT
    // having to use @State to create local data
    // Allows us to keep the data in the variables
    // if we go back to a view because it is still
    // stored away in variable strings we made earlier
    // Had we used Struct or @State local property for this
    // view, the data would have been discarded when
    // the user left the view
    // In summary:
    // We receive an @Observable object and you
    // bind things to it by using @Bindable
    // You WILL use @Bindable a lot in your projects!
    @Bindable var order: Order
    
    
    var body: some View {
        Form {
            Section {
                // Text fields from instance of
                // Order class are bound here
                TextField("Name", text: $order.name)
                TextField("Street Address", text: $order.streetAddress)
                TextField("City", text: $order.city)
                TextField("Zip", text: $order.zip)
                Text("All fields are required")
                    .foregroundColor(.red)
                    .font(.footnote)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            
            Section {
                NavigationLink("Check Out") {
                    // Pass our order object to
                    // CheckoutView
                    // The ContentView makes the order,
                    // passes the order to the AddressView,
                    // which in turn passes the order to the
                    // CheckoutView
                    // IMPORTANT: All three view point to the
                    // same data object
                    CheckoutView(order: order)
                }
            }
            // The address fields are validated in the
            // order class Order.swift
            .disabled(order.hasValidAddress == false)
        }
        .navigationTitle("Delivery Details")
        // This modifier tells SwiftUI to show the
        // navigation title in the compact inline style,
        // inside the navigation bar, instead of
        // using the large title style
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    // Create an empty order for preview purposes
    // AI suggested adding a NavigationStack to the preview
    // in order to see the NavigationTitle for the
    // AddressView - It works!
        NavigationStack {
            AddressView(order: Order())
    }
}
