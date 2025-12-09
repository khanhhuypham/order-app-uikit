//
//  Coupon.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 24/10/25.
//


import ObjectMapper

struct Coupon: Mappable{
    var id = 0
    var restaurant_brand_id = 0
    var name = ""
    var discount_amount = 0
    var discount_percent = 0
    var min_order_amount = 0
    var max_discount_amount = 0
    var start_date = ""
    var end_date = ""
    var note = ""
    var status = 0
    var quantity = 0
    var select:Bool = false
   
    init?(map: Map) {}
    
    init?() {}
    
    mutating func mapping(map: Map) {
        id                  <- map["id"]
        restaurant_brand_id <- map["restaurant_brand_id"]
        name                <- map["name"]
        discount_amount     <- map["discount_amount"]
        discount_percent    <- map["discount_percent"]
        min_order_amount    <- map["min_order_amount"]
        max_discount_amount <- map["max_discount_amount"]
        start_date          <- map["start_date"]
        end_date            <- map["end_date"]
        note                <- map["note"]
        status              <- map["status"]
        quantity            <- map["quantity"]
    }
}
