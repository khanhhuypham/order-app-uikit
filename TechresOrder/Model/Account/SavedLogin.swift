//
//  SavedLogin.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 14/8/25.
//

import UIKit
import ObjectMapper

struct SavedLoginInfor: Mappable {
    var ip_address = ""
    var restaurant_name = ""
    var username = ""
    
    
    init() {}
    

    
    init(ip_address:String,restaurant_name:String,username:String) {
        self.ip_address = ip_address
        self.restaurant_name = restaurant_name
        self.username = username
    }
    
    init(restaurant_name:String,username:String) {
        self.restaurant_name = restaurant_name
        self.username = username
    }
    
    init?(map: Map) {}
    
    
    mutating func mapping(map: Map){
        ip_address                              <- map["ip_address"]
        restaurant_name                         <- map["restaurant_name"]
        username                                <- map["username"]
    }
}
