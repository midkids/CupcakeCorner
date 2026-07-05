//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Myron Snelson on 7/4/26.
//

import SwiftUI

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
            let (data, _) = try await URLSession.shared.data(from: url)
            print(data)
            if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                results = decodedResponse.results
            }
        } catch {
            // If our data retrieval above fails for any
            // reason, we simply print an error message
            // and do nothing more
            print("Invalid data")
        }
    
    }
}

#Preview {
    ContentView()
}
