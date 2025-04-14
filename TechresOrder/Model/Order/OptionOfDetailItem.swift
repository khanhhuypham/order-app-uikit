//
//  OptionOfDetailItem.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 26/02/2025.
//

import UIKit
import ObjectMapper

struct OptionOfDetailItem: Mappable {
    var id = 0
    var name = ""
    var max_items_allowed = 0
    var min_items_allowed = 0
    var food_option_foods:[OptionItem] = []
   
    
    init?(map: Map) {}
    
    
    init(){}
    
  
    mutating func mapping(map: Map) {
        id                      <- map["id"]
        name                    <- map["name"]
        max_items_allowed       <- map["max_items_allowed"]
        min_items_allowed       <- map["min_items_allowed"]
        food_option_foods       <- map["food_option_foods"]
    }
    
}


struct OptionItem: Mappable {
    var id = 0
    var food_id = 0
    var food_name = ""
    var price = 0
    var status = DEACTIVE
    var quantity:Float = 0
   
    
    init?(map: Map) {}
    
    
    init(){}
    

    mutating func mapping(map: Map) {
        id                      <- map["id"]
        food_id                 <- map["food_id"]
        food_name               <- map["food_name"]
        price                   <- map["price"]
        status                  <- map["status"]
        quantity                <- map["quantity"]
    }
    
}
