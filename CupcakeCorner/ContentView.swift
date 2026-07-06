//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Myron Snelson on 7/4/26.
//
// Sending and receiving Codable data with URLSession and SwiftUI
// Loading an image from a remote server
// Validating and disabling forms

import SwiftUI

/*
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
        // awaits tells SwiftUI a sleep MIGHT happen here
        
        .task {
            await loadData()
        }
    }
    
    // Use of the keyword async tells Swift
    // this function might want to go to sleep
    // in order to complete doing its work
    // The three steps we want to complete:
    // 1. Create the URL from which we want to
    //    retrieve data (in this case we want
    //    to read from Apple servers
    // 2. We want to fetch the data from that
    //    URL using Swift
    // 3. Decode that result into a Reponse struct
    func loadData() async {
        
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
            // Color.red
            ProgressView()
        }
        // But the outer frame limits the size of the image
         .frame(width: 200, height: 200)
        */
        
        // Here is an even more advanced method using AsyncImage
        AsyncImage(url: URL(string: "https://hws.dev/img/logo.png")) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFit()
            } else if phase.error != nil {
                Text("There was an error loading the image")
            } else {
                ProgressView()
            }
        }
        // The outer frame limits the size of the image
         .frame(width: 200, height: 200)
    }
}
*/

struct ContentView: View {
    @State private var userName = ""
    @State private var emailAddress = ""
    
    // In this example, we do not want the user
    // to be able to tap the Create account button
    // unless both the user name and the email
    // address fields have been filled
    
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

#Preview {
    ContentView()
}
