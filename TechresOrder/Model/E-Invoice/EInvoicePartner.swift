//
//  EInvoice.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 05/06/2025.
//

import UIKit
import ObjectMapper

struct EInvoicePartner: Mappable {
    
    var id = 0
    var type:PARTNER_INVOICE_TYPE = .mifi
    var name = ""
    var status = false
    var desciption = ""
    var is_connected = 0
    var invoice_series = ""

    init() {}
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id                                  <- map["id"]
        type                                <- map["type"]
        name                                <- map["name"]
        status                              <- map["status"]
        desciption                          <- map["desciption"]
        is_connected                        <- map["is_connected"]
        invoice_series                      <- map["invoice_series"]
    }
    
}
