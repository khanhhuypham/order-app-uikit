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
    var food_option_foods:[OptionItem] = []
   
    
    init?(map: Map) {}
    
    
    init(){}
    
//    init(id:Int,name:String,quantity:Float,price:Int,total_price:Int,discountAmount:Int = 0,discountPercent:Int = 0, discountPrice:Int = 0){
//        self.id = id
//        self.name = name
//        self.quantity = quantity
//        self.price = price
//        self.total_price = total_price
//        self.discountAmount = discountAmount
//        self.discountPercent = discountPercent
//        self.discountPrice = discountPrice
//    }
//    
    mutating func mapping(map: Map) {
        id                      <- map["id"]
        name                                    <- map["name"]
        max_items_allowed                                   <- map["max_items_allowed"]
        food_option_foods                              <- map["food_option_foods"]
    }
    
}


struct OptionItem: Mappable {
    var id = 0
    var food_id = 0
    var food_name = ""
    var price = 0
    var status = DEACTIVE
   
    
    init?(map: Map) {}
    
    
    init(){}
    

    mutating func mapping(map: Map) {
        id                      <- map["id"]
        food_id                 <- map["food_id"]
        food_name               <- map["food_name"]
        price                   <- map["price"]
        status                  <- map["status"]
    }
    
}
