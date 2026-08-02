//
//  Order.swift
//  CupcakeCorner
//
//  Created by Myron Snelson on 7/24/26.
//

import Foundation

@Observable
class Order: Codable {
    
    // Need this enum to correct the internal
    // field names assigned by @Observable
    enum CodingKeys: String, CodingKey {
        case _type = "type"
        case _quantity = "quantity"
        case _specialRequestEnabled = "specialRequestEnabled"
        case _extraFrosting = "extraFrosting"
        case _addSprinkles = "addSprinkles"
        case _name = "name"
        case _streetAddress = "streetAddress"
        case _city = "city"
        case _zip = "zip"
    }
    
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    var type = 0
    var quantity = 3
    
    // We will add a property observer for the purpose of
    // making extraFrosting and addSprinkes false
    // if the user turns off specialRequestEnabled
    // after they had set specialRequestEnabled on
    // Causes the last two indicators to disappear
    // in the UI
    var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    var extraFrosting = false
    var addSprinkles = false
    
    // The UserDefaults logic was added by AI when asked
    // how to complete the last challenge in Project 10, part 4:
    // For a more challenging task, try updating the Order
    // class so it saves data such as the user's delivery
    // address to UserDefaults.
    // IMPORTANT: You would NOT store personal data in
    // this manner in a real app.
    //
    // Only the reusable address field have been updated
    // so they load from UserDefaults and
    // save whenever they change
    //
    // The Codable code still matters too. When checkout
    // sends the order over the network, the enum in Order
    // still tells Swift how to encode those observable
    // properties into clean JSON names. So even though
    // the properties now use UserDefaults, they are still
    // normal String properties as far as the rest of
    // the app is concerned.
    var name = UserDefaults.standard.string(forKey: "name") ?? "" {
        didSet {
            UserDefaults.standard.set(name, forKey: "name")
        }
    }
    var streetAddress = UserDefaults.standard.string(forKey: "streetAddress") ?? "" {
        didSet {
            UserDefaults.standard.set(streetAddress, forKey: "streetAddress")
        }
    }
    var city = UserDefaults.standard.string(forKey: "city") ?? "" {
        didSet {
            UserDefaults.standard.set(city, forKey: "city")
        }
    }
    var zip = UserDefaults.standard.string(forKey: "zip") ?? "" {
        didSet {
            UserDefaults.standard.set(zip, forKey: "zip")
        }
    }
    
    // Validate the order has no empty or all spaces fields
    // Per Challenge #1
    var hasValidAddress: Bool {
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
            streetAddress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
            city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
            zip.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return false
        }
        
        return true
    }
    
    // The cost variable is a computed property
    // Use type Decimal for more accuracy
    // compared to Double for currency
    // Behind the scenes, Decimal uses integer
    // mathematics, resulting no loss with
    // rounding errors and weird Double behaviors
    // AI preferred we do not use the same
    // variable name in the computations
    // Changed cost to computedCost within
    // computations
    var cost: Decimal {
        // Cost structure
        // $2 per cupcake
        var computedCost = Decimal(quantity) * 2
        // Cupcakes cost more based on type
        // (e.g. Rainbow is more than Vanilla)
        computedCost += Decimal(type) / 2
        // extra frosting $1 per cupcake
        if extraFrosting {
            computedCost += Decimal(quantity)
        }
        // sprinkles 50 cents more per cupcake
        if addSprinkles {
            computedCost += Decimal(quantity) / 2
        }
        return computedCost
    }
}
