//
//  Order.swift
//  CupcakeCorner
//
//  Created by Myron Snelson on 7/24/26.
//

import Foundation

@Observable
class Order {
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
    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""
    
    // Validate the order has no blank fields
    var hasValidAddress : Bool {
        if name.isEmpty || streetAddress.isEmpty || city.isEmpty || zip.isEmpty {
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
