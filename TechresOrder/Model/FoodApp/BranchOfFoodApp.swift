//
//  BranchOfFoodApp.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 30/09/2024.
//

import UIKit
import ObjectMapper
struct BranchOfFoodApp: Mappable {
    var branch_id = ""
    var branch_name = ""
    var branch_address = ""
    var branch_phone = ""
    var channel_order_food_token_id = 0
    var channel_order_food_token_name:String = ""
    var isSelect:Bool = false
    
//    var channel_branch_id:String?
    
    init?(map: Map) {}
    
    init(){}
    
    init(name:String,branchId:String){
        self.branch_name = name
        self.branch_id = branchId
    }
    
    
    
    mutating func mapping(map: Map) {
        branch_id <- map["branch_id"]
        branch_name <- map["branch_name"]
        channel_order_food_token_id <- map["channel_order_food_token_id"]
        channel_order_food_token_name <- map["channel_order_food_token_name"]
        branch_name <- map["branch_name"]
        branch_address <- map["branch_address"]
        branch_phone <- map["branch_phone"]
//        channel_branch_id <- map["channel_branch_id"]
    }
    
}
