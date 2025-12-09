//
//  FoodAppOrder.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 20/08/2024.
//

import UIKit
import ObjectMapper



struct FoodAppOrderResponse: Mappable {
    var errors:[[String:String]] = []
    var list:[FoodAppOrder] = []
    var is_new_order_app_food = DEACTIVE
 
    init?(map: Map) {}
    init(){}
        
    mutating func mapping(map: Map) {
        errors                <- map["errors"]
        list                  <- map["list"]
        is_new_order_app_food <- map["is_new_order_app_food"]
    }
}


struct FoodAppOrder: Mappable {
    var id = 0

    var driver_name:String = ""
    var driver_phone:String = ""
    var customer_name:String = ""
    var customer_phone:String = ""
    
    var channel_order_id:String = ""
    var channel_order_code:String = ""
    var channel_order_food_id = 0
    var channel_order_food_code:APP_PARTNER = .shoppee

    var channel_branch_name =  ""
    var channel_branch_phone = ""
    var channel_branch_address = ""
    var note = ""
    
    var is_app_food = ACTIVE
    var order_amount = 0
    var customer_order_amount = 0
    var total_amount = 0
    var shipping_fee = 0
    
    var customer_discount_amount = 0
    var item_discount_amount = 0
    var display_id = ""
    var details:[OrderItemOfFoodApp] = []
    var created_at = ""
    var deliver_time = ""
    var is_cancel_order = DEACTIVE
    var is_scheduled_order = DEACTIVE
    var is_printed = 0
    
    init?(map: Map) {}
    init(){}
        
    mutating func mapping(map: Map) {
        id                          <- map["id"]
        driver_name                 <- map["driver_name"]
        driver_phone                <- map["driver_phone"]
        customer_name               <- map["customer_name"]
        customer_phone              <- map["phone"]
        channel_order_id            <- map["channel_order_id"]
        channel_order_code          <- map["channel_order_code"]
        channel_order_food_id       <- map["channel_order_food_id"]
        channel_order_food_code     <- map["channel_order_food_code"]
        channel_branch_name         <- map["channel_branch_name"]
        channel_branch_phone        <- map["channel_branch_phone"]
        channel_branch_address      <- map["channel_branch_address"]
        note                        <- map["note"]
        is_app_food                 <- map["is_app_food"]
        order_amount                <- map["order_amount"]
        customer_order_amount       <- map["customer_order_amount"]
        total_amount                <- map["total_amount"]
        shipping_fee                <- map["shipping_fee"]
        customer_discount_amount    <- map["customer_discount_amount"]
        item_discount_amount        <- map["item_discount_amount"]
        details                     <- map["details"]
        created_at                  <- map["created_at"]
        deliver_time                <- map["deliver_time"]
        display_id                  <- map["display_id"]
        shipping_fee                <- map["shipping_fee"]
        is_cancel_order             <- map["is_cancel_order"]
        is_scheduled_order          <- map["is_scheduled_order"]
        is_printed                  <- map["is_printed"]
    }
    
    
}





extension FoodAppOrder{
    static func getDummyData() -> [FoodAppOrder] {
        let jsonString = """
        [
            {
                "customer_name": "Thu trang",
                "phone": "0969217332",
                "address": "",
                "note": "",
                "details": [
                    {
                        "food_options": [],
                        "id": 84681,
                        "food_id": "VNITE20250520020209023158",
                        "food_name": "BÁNH MÌ ĐẶC BIỆT HUYNH HOA",
                        "quantity": 1,
                        "price": 73000,
                        "note": "",
                        "total_price_addition": 73000,
                        "is_allow_print_stamp": 0,
                        "restaurant_kitchen_place_id": 0
                    }
                ],
                "cancel_comment": "",
                "channel_branch_id": "huynhhoapxl",
                "driver_name": "Trần Ngô Thụy Đoan",
                "driver_avatar": "",
                "driver_phone": "0902553720",
                "channel_order_food_name": "Grabfood",
                "channel_order_food_code": "GRF",
                "channel_order_id": "271655389-C7MWEY6JLVCHKE",
                "channel_order_code": "",
                "is_app_food": 1,
                "display_id": "GF-295",
                "order_amount": 73000,
                "discount_amount": 18250,
                "customer_order_amount": 73000,
                "customer_discount_amount": 0,
                "channel_branch_name": "",
                "channel_branch_address": "",
                "channel_branch_phone": "",
                "item_discount_amount": 0,
                "deliver_time": "08/09/2025 17:12",
                "is_scheduled_order": 0,
                "is_printed": 0,
                "is_cancel_printed": 0,
                "is_cancel_order": 1,
                "id": 188486,
                "order_id": 0,
                "total_amount": 54750,
                "created_at": "08/09/2025 17:04",
                "shipping_fee": 30000,
                "channel_order_food_id": 2,
                "tracking_url": "",
                "restaurant_third_party_delivery_id": 0
            },
            {
                "customer_name": "Quỳnh Như",
                "phone": "0931237964",
                "address": "",
                "note": "",
                "details": [
                    {
                        "food_options": [],
                        "id": 84712,
                        "food_id": "VNITE2023071620294452086",
                        "food_name": "2 Kimbap Chiên Sốt Tương Mật Ong, Mayonnaise, Chà Bông",
                        "quantity": 1,
                        "price": 63000,
                        "note": "",
                        "total_price_addition": 63000,
                        "is_allow_print_stamp": 0,
                        "restaurant_kitchen_place_id": 0
                    },
                    {
                        "food_options": [],
                        "id": 84713,
                        "food_id": "VNITE2023071620243550878",
                        "food_name": "2 Kimbap Chiên Sốt Cay, Mayonnaise, Chà Bông",
                        "quantity": 1,
                        "price": 63000,
                        "note": "thêm tương ớt",
                        "total_price_addition": 63000,
                        "is_allow_print_stamp": 0,
                        "restaurant_kitchen_place_id": 0
                    }
                ],
                "cancel_comment": "",
                "channel_branch_id": "mkt.tieuanh@gmail.com",
                "driver_name": "Trần Văn Hùng",
                "driver_avatar": "",
                "driver_phone": "0399113379",
                "channel_order_food_name": "Grabfood",
                "channel_order_food_code": "GRF",
                "channel_order_id": "126118889-C7MWE3XXEGK3JJ",
                "channel_order_code": "",
                "is_app_food": 1,
                "display_id": "GF-789",
                "order_amount": 126000,
                "discount_amount": 25250,
                "customer_order_amount": 101000,
                "customer_discount_amount": 25000,
                "channel_branch_name": "",
                "channel_branch_address": "",
                "channel_branch_phone": "",
                "item_discount_amount": 25000,
                "deliver_time": "08/09/2025 17:22",
                "is_scheduled_order": 0,
                "is_printed": 0,
                "is_cancel_printed": 0,
                "is_cancel_order": 0,
                "id": 188507,
                "order_id": 0,
                "total_amount": 75750,
                "created_at": "08/09/2025 17:19",
                "shipping_fee": 17000,
                "channel_order_food_id": 2,
                "tracking_url": "",
                "restaurant_third_party_delivery_id": 0
            }
        ]
        """
        
        return Mapper<FoodAppOrder>().mapArray(JSONString: jsonString) ?? []
    }

    
    
}
