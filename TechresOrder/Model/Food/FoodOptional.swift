//
//  FoodOptional.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 22/02/2025.
//

import UIKit
import ObjectMapper

struct FoodOptional:Mappable {
  
    var id = 0
    var name = ""
    var max_items_allowed = 0
    var min_items_allowed = 1
    var addition_foods:[FoodAddition] = []
    

   
    
    init(){}
    
    init?(map: Map) {}
 

    mutating func mapping(map: Map) {
        id                                      <- map["id"]
        name                                    <- map["name"]
        max_items_allowed                       <- map["max_items_allowed"]
        min_items_allowed                       <- map["min_items_allowed"]
        addition_foods                          <- map["addition_foods"]
    
    }
    
    
}




