//
//  OrderHistoryOfFoodApp.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 29/08/2024.
//

import UIKit
import ObjectMapper


struct OrderHistoryOfFoodAppResponse: Mappable {
    var partnerId:Int = 0
    var reportType:Int = 0
    var dateString = ""
        
    var list:[OrderHistoryOfFoodApp] = []
    var total_revenue_SHF = 0
    var total_revenue_GRF = 0
    var total_revenue_GOF = 0
    var total_revenue_BEF = 0
    var total_revenue = 0
    var total_order_completed = 0
    var total_order_cancelled = 0
    var total_record = 0
    
    init?(map: Map) {}
    
    init(){}
    
    init(partnerId:Int,reportType:Int, dateString:String){
        self.reportType = reportType
        self.dateString = dateString
        self.partnerId = partnerId
    }
    
    mutating func mapping(map: Map) {
        list                    <- map["list"]
        total_revenue_SHF       <- map["total_revenue_SHF"]
        total_revenue_GRF       <- map["total_revenue_GRF"]
        total_revenue_GOF       <- map["total_revenue_GOF"]
        total_revenue_BEF       <- map["total_revenue_BEF"]
        total_revenue           <- map["total_revenue"]
        total_order_completed   <- map["total_order_completed"]
        total_order_cancelled   <- map["total_order_cancelled"]
        total_record            <- map["total_record"]
    }
    
    
}



struct OrderHistoryOfFoodApp: Mappable {
    var id = 0
    var order_id = ""
    var total_amount = 0
    var channel_order_food_id = 0
    var channel_order_food_name =  ""
    var channel_order_food_code = ""
    var display_id = ""
    var order_created_at = ""
    var is_completed:OrderStatusOfFoodApp = .complete
    init?(map: Map) {}
    init(){}
        
    mutating func mapping(map: Map) {
     
        id  <- map["id"]
        order_id <- map["order_id"]
        channel_order_food_id  <- map["channel_order_food_id"]
        channel_order_food_name  <- map["channel_order_food_name"]
        channel_order_food_code  <- map["channel_order_food_code"]
        total_amount  <- map["total_amount"]
        order_created_at <- map["order_created_at"]
        display_id <- map["display_id"]
        is_completed <- map["is_completed"]
    }
}

