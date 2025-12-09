//
//  Order.swift
//  TechresOrder
//
//  Created by Kelvin on 13/01/2023.
//

import UIKit
import ObjectMapper

struct OrderStatistic: Mappable {
    var amount = 0
    var vat_amount = 0
    var discount_amount = 0
    var total_amount = 0
    var membership_accumulate_point_used = 0
    
    init?(map: Map) {
    }

    
    mutating func mapping(map: Map) {
        amount <- map["amount"]
        vat_amount <- map["vat_amount"]
        discount_amount <- map["discount_amount"]
        total_amount <- map["total_amount"]
        membership_accumulate_point_used <- map["membership_accumulate_point_used"]
    
    }
}


struct OrderResponse:Mappable{
    var limit: Int?
    var data = [Order]()
    var total_record:Int?
      
    init?(map: Map) {
    }

    
    mutating func mapping(map: Map) {
        limit <- map["limit"]
        data <- map["list"]
        total_record <- map["total_record"]
    }
    
}

struct Order: Mappable {
    var id = 0
    var using_time_minutes_string = ""
    var table_name = ""
    var table_id = 0
    var table_merge_list_name = [String]()
    var using_slot = 0
    var order_status = 0
    var created_at = ""
    var payment_date = ""

    var id_in_branch = 0
    var customer_id = 0
    var total_amount:Int = 0

    var total_order_detail_customer_request = 0
    var booking_infor_id = 0
    var booking_status = 0
    var is_take_away = 0
    var employee = Account()

    var total_amount_avg_per_customer = 0
    var buffet_ticket_id = 0
    var order_method:Order_Method = .EAT_IN
    var order_detail_pending_quantity = 0
    var order_detail_quantity = 0
    
    private var order_id = 0{
        didSet{
            if self.id == 0{
                self.id = order_id
            }
         
        }
    }
    
    private var amount:Double = 0{
        didSet{
            if self.total_amount == 0{
                self.total_amount = Int(amount)
            }
         
        }
    }
    
    
    init?(map: Map) {
    }
    
    init(table:Table) {
        self.id = table.order_id
        self.table_name = table.name
        self.table_id = table.id
    }
    init(orderDetail:OrderDetail) {
        self.id = orderDetail.id
        self.table_name = orderDetail.table_name
        self.table_id = orderDetail.table_id
        self.buffet_ticket_id = orderDetail.buffet?.buffet_ticket_id ?? 0
    }
    
    init() {}

    mutating func mapping(map: Map) {
        id                                  <- map["id"]
        id_in_branch                        <- map["id_in_branch"]
        using_time_minutes_string           <- map["using_time_minutes_string"]
        using_slot                          <- map["using_slot"]
        table_name                          <- map["table_name"]
        table_id                            <- map["table_id"]
        table_merge_list_name               <- map["table_merge_list_name"]
        order_status                        <- map["order_status"]
        created_at                          <- map["created_at"]
        payment_date                        <- map["payment_date"]
        customer_id                         <- map["customer_id"]
        total_amount                        <- map["total_amount"]
        total_order_detail_customer_request <- map["total_order_detail_customer_request"]
        booking_infor_id                    <- map["booking_infor_id"]
        booking_status                      <- map["booking_status"]
        is_take_away                        <- map["is_take_away"]
        employee                            <- map["employee"]
        total_amount_avg_per_customer       <- map["total_amount_avg_per_customer"]
        buffet_ticket_id                    <- map["buffet_ticket_id"]
        order_method                        <- map["order_method"]
        order_detail_pending_quantity       <- map["order_detail_pending_quantity"]
        order_detail_quantity               <- map["order_detail_quantity"]
        order_id                            <- map["order_id"]
        amount                              <- map["amount"]
    }
}





struct SplitFoodResponse:Mappable{
    
    var order_id = 0

    init?(map: Map) {
    }
    mutating func mapping(map: Map) {
        order_id <- map["order_id"]
        
    }
    
}

struct OrderMethod: Mappable {
    var is_have_take_away = DEACTIVE
    
    init() {}
    
    init?(map: Map) {
    }
    mutating func mapping(map: Map) {
        is_have_take_away <- map["is_have_take_away"]
    }
}



//
//class OfflineRealTimeOrder: Mappable {
//    var id: Int?
//    var table_id: Int?
//    var table_name: String?
//    var object_data: Order?   // nested order object
//
//    required init?(map: Map) {}
//
//    func mapping(map: Map) {
//        id          <- map["id"]
//        table_id    <- map["table_id"]
//        table_name  <- map["table_name"]
//
//        // Step 1: get string
//        var objectDataString: String?
//        objectDataString <- map["object_data"]
//
//        // Step 2: convert string → JSON dictionary → map into Order
//        if let str = objectDataString,
//           let data = str.data(using: .utf8),
//           let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
//            object_data = Mapper<Order>().map(JSON: dict)
//        }
//    }
//}
