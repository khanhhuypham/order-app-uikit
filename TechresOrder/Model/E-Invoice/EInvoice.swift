//
//  EInvoice.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 07/06/2025.
//

import UIKit
import ObjectMapper

struct EInvoice: Mappable {
    
    var id = 0
    var order_id = 0
    var exported_time = ""
    var payment_date = ""
    var partner_type:PARTNER_INVOICE_TYPE = .mifi
    var total_amount = 0
    var amount = 0
    var is_app_food = 0
    
    init() {}
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id                              <- map["id"]
        order_id                        <- map["order_id"]
        exported_time                   <- map["exported_time"]
        payment_date                    <- map["payment_date"]
        partner_type                    <- map["partner_type"]
        total_amount                    <- map["total_amount"]
        amount                          <- map["amount"]
        is_app_food                     <- map["is_app_food"]
    }
    
}

struct EInvoiceResponse:Mappable{
    var limit:Int = 0
    var data:[EInvoice] = []
    var total_record:Int = 0
    var total_amount:Int = 0
    var total_vat_amount:Int = 0
    var total_discount_amount:Int = 0
    var total_payment_amount:Int = 0
      
    init?(map: Map) {}

    mutating func mapping(map: Map) {
        limit                   <- map["limit"]
        data                    <- map["list"]
        total_record            <- map["total_record"]
        total_amount            <- map["total_amount"]
        total_vat_amount        <- map["total_vat_amount"]
        total_discount_amount   <- map["total_discount_amount"]
        total_payment_amount    <- map["total_payment_amount"]
    }
    
}

