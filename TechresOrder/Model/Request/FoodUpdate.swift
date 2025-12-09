//
//  FoodUpdateRequest.swift
//  TechresOrder
//
//  Created by Kelvin on 19/01/2023.
//

import UIKit
import ObjectMapper

struct FoodUpdate: Mappable {

    var order_detail_id = 0
    var quantity: Float = 0
    var price: Int = 0
    var note = ""
    var discount_percent = 0
    var order_detail_food_options:[OptionUpdate] = []
   
    init() {}
    init(order_detail_id:Int,quantity:Float,note:String) {
        self.order_detail_id = order_detail_id
        self.quantity = quantity
        self.note = note
    }
    
    
    init?(map: Map) {}
 
    mutating func mapping(map: Map) {
        order_detail_id     <- map["order_detail_id"]
        quantity            <- map["quantity"]
        price               <- map["price"]
        note                <- map["note"]
        discount_percent    <- map["discount_percent"]
    }
}



struct OptionUpdate: Mappable {
    var food_option_id = 0
    var order_detail_food_option_id = 0
    var status = DEACTIVE
    var quantity: Float = 0
    
    init?(map: Map) {}
    
    
    init(food_option_id:Int,id:Int,quantity:Float,status:Int){
        self.food_option_id = food_option_id
        self.order_detail_food_option_id = id
        self.status = status
        self.quantity = quantity
    }
    

    mutating func mapping(map: Map) {
        food_option_id                 <- map["food_option_id"]
        order_detail_food_option_id    <- map["order_detail_food_option_id"]
        status                         <- map["status"]
        quantity                       <- map["quantity"]
    }
    
}
