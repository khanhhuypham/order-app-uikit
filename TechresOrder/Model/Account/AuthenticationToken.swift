//
//  AuthenticationToken.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 13/8/25.
//

import UIKit
import ObjectMapper

struct AuthenticationToken: Mappable {
    var id = 0
    var status = 0
    var user_id = 0
    var username=""
    var client_id = ""
    var code = ""
    var expire_at = ""
  
    init() {}
    
    init?(map: Map) {
        
    }
    
    
    mutating func mapping(map: Map){
        id <- map["id"]
        status <- map["status"]
        user_id <- map["user_id"]
        username <- map["username"]
        client_id <- map["client_id"]
        code <- map["code"]
        expire_at <- map["expire_at"]
    }
    
}
