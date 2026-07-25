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
    // and causes the last two indicators to become
    // invisible in the UI
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
}
