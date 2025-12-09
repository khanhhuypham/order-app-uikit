//
//  OrderHistoryDetailOfFoodApp.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 31/07/2025.
//

import ObjectMapper



struct OrderHistoryDetailOfFoodApp: Mappable {
    var id = 0
    var channel_order_id:String = ""
    var customer_name = ""
    var customer_phone = ""
    var display_id = ""
    var order_amount = 0
    var total_amount = 0
    var created_at = ""
    
    var driver_name:String = ""
    var driver_phone:String = ""
    var commission_amount = 0
    var customer_order_amount = 0
    var item_discount_amount = 0

    var details:[OrderItemOfFoodApp] = []
        
    init?(map: Map) {}
    
    init(){}
        
    mutating func mapping(map: Map) {
     
        id  <- map["id"]
        channel_order_id  <- map["channel_order_id"]
        customer_name  <- map["customer_name"]
        customer_phone  <- map["customer_phone"]
        display_id <- map["display_id"]
        order_amount  <- map["order_amount"]
        total_amount  <- map["total_amount"]
        created_at <- map["created_at"]
        driver_name           <- map["driver_name"]
        driver_phone          <- map["driver_phone"]
        commission_amount     <- map["commission_amount"]
        customer_order_amount <- map["customer_order_amount"]
        item_discount_amount  <- map["item_discount_amount"]
        details               <- map["details"]
    }
}

