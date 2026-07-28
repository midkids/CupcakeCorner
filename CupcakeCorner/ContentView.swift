//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Myron Snelson on 7/4/26.
//
// Sending and receiving Codable data with URLSession and SwiftUI
// Loading an image from a remote server
// Validating and disabling forms
// Adding Codable conformance to an @Observable class
// Adding haptic effects
// Taking basic order details
// Preparing for checkout

import CoreHaptics

import SwiftUI

/*
// Here we will be sending and receiving data
// from the Internet
// Combined with Codable support, we will
// 1) convert Swift objects to JSON and
//    send over the Internet
// 2) receive JSON and convert that back
//    to Swift objects
// 3) when our request completes, we can
//    immediately assign that data to
//    properties in our SwiftUI views
//    causing them to update the user
//    inteface immediately
// To demonstrate, we will load some example
// music data from Apple's iTunes API
// We will only use three properties of
// the many available in the returned JSON
struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}
struct ContentView: View {
    @State private var results = [Result]()
    var body: some View {
        List(results, id: \.trackId) { item in
            VStack(alignment: .leading) {
                Text(item.trackName)
                    .font(.headline)
                Text(item.collectionName)
            }
        }
        // The task modifier works with asynchronous
        // functions
        // await tells SwiftUI a sleep MIGHT happen here
        
        .task {
            await loadData()
        }
    }
    
    // Networking can be slow compared to local
    // functions - Async tells Swift to
    // leave this this code working away in the
    // background while the main app carries on
    // working
    
    // Use of the keyword async tells Swift
    // this function might want to go to sleep
    // so it can carry on waiting
    // for some other work to complete
    // In this case, this means going to sleep
    // while our networking code happens
    // so that our app does not freeze up
    // when downloading some iTunes API data
    
    // The three steps we want to complete:
    // 1. Create the URL from which we want to
    //    retrieve data (in this case we want
    //    to read from Apple servers)
    // 2. We want to fetch the data from that
    //    URL using Swift
    // 3. Decode that result into a Reponse struct
    func loadData() async {
        // Get all songs by Taylor Swift
        guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song") else {
            print("Invalid URL")
            return
        }
        
        do  {
            // The return value is a tuple
            // and this tuple will contain
            // the data we want and also metadata
            // We don't want that metadata
            // This statement says: place the returned
            // actual data in the variable data
            // and the underscore says to discard
            // the metadata
            // IMPORTANT: must use "try await"
            //  in that order
            // try: there might be errors here
            // await" there might be sleeping here
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                results = decodedResponse.results
            } else {
                print("Could not decode data")
            }
        } catch {
            // If our data retrieval above fails for any
            // reason, we simply print an error message
            // and do nothing more
            print("Invalid data")
        }
    
    }
}
*/


/*
// SwiftUI ImageView is great for loading images from
// your asset catalog, but not from Internet
// In that case, you need to use an AsyncImage instead
// An AsyncImage is made using a URL
// rather than a string file name or an Xcode constant
// SwiftUI will download the image for us, cache
// the download and display it automatically

// Here is a simple example of AsyncImage
// The sample image is 1200 pixels high
struct ContentView: View {
    var body: some View {
        // SwiftUI does not know the size of the image
        // being downloaded until run time
        // Therefore, it is unable to size it appropriately
        // and it does not know where it is 3X or 2X
        // so SwiftUI cannot choose the appropriate image
        // for the user's device
        // To fix that, we must tell SwiftUI
        // it is a 3X image that is being downloaded
        // by adding a scale factor
        // AsyncImage(url: URL(string: "https://hws.dev/img/logo.png"), scale: 3)
        
        // Here will use a more advanced method using AysyncImage
        // by adding a trailing closure
        // Here the finished image is resizeable
        // and the placeholder is resizeable
        // they will take up the available space
        /*
        AsyncImage(url: URL(string: "https://hws.dev/img/logo.png")) { image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            // The placeholder flashes on the screen
            // and then vanishes
            // You can see this when we make it red
            // Color.red
            // Shows spinner rather than red
            ProgressView()
        }
        // IMPORTANT: the outer frame limits the size of the image
         .frame(width: 200, height: 200)
        */
        
        // Here is an even more advanced method using AsyncImage
        // Phase stands for the image loading phase
        AsyncImage(url: URL(string: "https://hws.dev/img/logo.png")) { phase in
            // If you have a image, show it
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFit()
            // If there was an error, print an error message
            } else if phase.error != nil {
                Text("There was an error loading the image")
            } else {
                // If waiting, show progress view spinner
                ProgressView()
            }
        }
        // The outer frame limits the size of the image
         .frame(width: 200, height: 200)
    }
}
*/

/*
// SwiftUI Form view lets us store user input
// in a fast and convenient way
// However, it is important to validate the input
// We have the disabled modifier to help with this
// validation, enabling us to make whatever it is
// attached to unresponsive to user input
// Buttons cannot be pressed, sliders do not slide, etc.
// You can use disabled with simple properties,
// but can also use computed properties or call a method
struct ContentView: View {
    @State private var userName = ""
    @State private var emailAddress = ""
    
    // In this example, we do not want the user
    // to be able to tap the Create account button
    // unless both the user name and the email
    // address fields have been filled correctly
    
    // Use computed property to validate data
    var disableForm: Bool {
        userName.count < 5 || emailAddress.count < 5
    }
    var body: some View {
       Form {
           Section {
                TextField("User Name", text: $userName)
                TextField("Email Address", text: $emailAddress)
            }
           Section {
               Button("Create account") {
                   print("Creating account...")
               }
               // Disable button when the computed property
               // disableForm is true
               .disabled(disableForm)
           }
        }
    }
}
*/


/*
// Simple observable class
// Observable quietly rewrites our class
// so that it can be monitored by SwiftUI
// In this case, that causes the rewrite to leak
// which could cause all sorts of problems
// To fix this, we are going to tell SwiftUI
// exactly how to encode and decode the User class
// This is done by nesting an enum inside the class
// with an exact name of CodingKeys (plural)
// It needs a raw value of string plus a
// conformance to the protocol CodingKey (singular)
// Inside the enum, you make one case for
// every property you want to save (maybe one,
// maybe all of them)
// You then use the raw value of the enum to say
// what name that it should have in your JSON
@Observable
class User: Codable {
    enum CodingKeys: String, CodingKey {
        // When you see the value _name
        // - which is what observable makes
        // the property name -
        // change it to just name
        // Reading or writing it
        // Causes the printed value of name to go
        // from: {"_name":"Taylor","_$observationRegistrar":{}}
        // to: {"name":"Taylor"}
        // which is what we want to encode and decode
        case _name = "name"
    }
    var name = "Taylor"
}

struct ContentView: View {
    var body: some View {
        // Button to encode the observable User class
        Button("Encode Taylor", action: encodeTaylor)
    }
    func encodeTaylor() {
        // We would NOT use ! in production, but
        // it is okay for testing
        // Function to encode User class
        // then immediately decode and print it
        let data = try! JSONEncoder().encode(User())
        let str = String(decoding: data, as: UTF8.self)
        print(str)
    }
}
*/

/*
// SwiftUI has built in support for haptic effects
// In iOS, there are two options 1) easy, 2) complete
// Easy is almost always the better choice
// These effects will only work on a physical iPhone,
// not Mac, not iPad
struct ContentView: View {
    @State private var counter = 0
    // For use with complete option of haptic feedback
    @State private var engine: CHHapticEngine?
    
    var body: some View {
        Button("Tap Count: \(counter)") {
             counter += 1
        }
    // Easy, built-in haptic method
        // Will cause gentle taps when button pressed
        // There are a bunch of these variants besides .increase
        // such as .success, .warning, .error, .start, .stop
        // .sensoryFeedback(.increase, trigger: counter)
        
        // If you want a little more control, use .impact
        // Example, soft objects colliding a medium intensity
        // .sensoryFeedback(.impact(flexibility: .soft, intensity: 0.5), trigger: counter)
        // Example, heavy objects colliding a maximum intensity
        .sensoryFeedback(.impact(weight: .heavy, intensity: 1), trigger: counter)
    }
    // I decided I will never use the complete haptic method
    // So, I left out that logic
}
*/


// The actual CupcakeCorner project
// We will use a single class to store all our data
// and we will pass it from screen to screen
// in our project
// This means all the screens in our app will
// share the same data
struct ContentView: View {
    // This is the only place an order will be created
    @State private var order = Order()
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Select your cake type", selection: $order.type) {
                        // Adding the id: \.self tells SwiftUI using
                        // these indices is safe (will not change)
                        ForEach(Order.types.indices, id: \.self) {
                            Text(Order.types[$0])
                        }
                    }
                    Stepper("Number of cakes: \(order.quantity)", value: $order.quantity, in: 3...20)
                }
                // The second section will hold three toggle switches
                // bound to specialRequestEnabled, extraFrosting, and addSprinkles
                // But the second two will only be visible when the
                // first one is enabled
                Section {
                    Toggle("Any special requests?", isOn: $order.specialRequestEnabled)
                    if order.specialRequestEnabled {
                        Toggle("Add extra frosting", isOn: $order.extraFrosting)
                        Toggle("Add sprinkles", isOn: $order.addSprinkles)
                    }
                    
                }
                Section {
                    NavigationLink("Delivery details") {
                        // IMPORTANT: Here we are passing
                        // the address of an instance of
                        // the order class
                        // This allows the AddressView
                        // to access the same order data as
                        // we have here in the ContentView
                        AddressView(order: order)
                    }
                }
            }
            .navigationTitle("Cupcake Corner")
        }
    }
}

#Preview {
    ContentView()
}
