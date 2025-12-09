//
//  OrderItemOfFoodApp.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 31/08/2024.
//

import UIKit
import ObjectMapper


struct OrderItemOfFoodApp: Mappable {
    var id = 0
    var quantity:Float = 0
    var price:Float = 0
    var restaurant_kitchen_place_id = 0
    var note:String = ""
    var food_options:[FoodOption] = []
    var food_name:String = ""
    var total_price_addition:Float = 0
    var is_allow_print_stamp:Int = 0

    init?(map: Map) {}
    
    init(){}
    

        
    mutating func mapping(map: Map) {
     
        id  <- map["id"]
        quantity  <- map["quantity"]
        price  <- map["price"]
        note  <- map["note"]
        food_options <- map["food_options"]
        restaurant_kitchen_place_id <- map["restaurant_kitchen_place_id"]
        total_price_addition <- map["total_price_addition"]
        food_name  <- map["food_name"]
        is_allow_print_stamp  <- map["is_allow_print_stamp"]
    }
}


struct FoodOption: Mappable {
    var name = ""
    var food_name = ""
    var quantity = 0
    var price = 0
 
    init?(map: Map) {}
    
    init(){}
    
    init(name:String,quantity:Int,price:Int){
        self.name = name
        self.quantity = quantity
        self.price = price
    }
    
  
    mutating func mapping(map: Map) {
        name        <- map["name"]
        food_name   <- map["food_name"]
        quantity    <- map["quantity"]
        price       <- map["price"]
      
    }
}
