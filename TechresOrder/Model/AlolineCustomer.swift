//
//  AlolineCustomer.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 31/03/2025.
//

import UIKit
import ObjectMapper

struct Customer: Mappable{
    var id = 0
    var name = ""
    var phone = ""
    var address = ""
    var avatar = ""
    
    init?(map: Map) {}
    
    init() {}
    
    init(id:Int,name:String,phone:String,address:String) {
        self.id = id
        self.name = name
        self.phone = phone
        self.address = address
    }
    
    mutating func mapping(map: Map) {
        id          <- map["id"]
        name        <- map["name"]
        phone       <- map["phone"]
        address     <- map["address"]
        avatar      <- map["avatar"]
    }
}
