//
//  EInvoiceDetail.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 05/06/2025.
//

import UIKit
import ObjectMapper

struct EInvoicePartnerDetail: Mappable {
    
    var id = 0
    var partner_electronic_invoice_type:PARTNER_INVOICE_TYPE = .mifi
    var partner_invoice_id = 0
    var partner_invoice_name = ""
    var restaurant_id = 0
    var restaurant_brand_id = 0
    var restaurant_brand_name = ""
    var branch_id = 0
    var branch_name = ""
    var status = 0
    var tax_code = ""
    var username = ""
    var password = ""
    var username_access_service = ""
    var password_access_service = ""
    var invoice_denominator = ""
    var invoice_series = ""
    var endpoint = ""
    var is_auto_export_third_party = 0
    var apply_order_types:[Int] = []
    var apply_discount:Int = 0
    var branch_assigns:[BranchAssignmentOfEInvoicePartner] = []

    init() {}
    
    init(invoice:EInvoicePartner) {
        self.partner_invoice_id = invoice.id
        self.partner_electronic_invoice_type = invoice.type
        self.partner_invoice_name = invoice.name
    }
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id                                      <- map["id"]
        partner_electronic_invoice_type         <- map["partner_electronic_invoice_type"]
        partner_invoice_id                      <- map["partner_invoice_id"]
        partner_invoice_name                    <- map["partner_invoice_name"]
        restaurant_id                           <- map["restaurant_id"]
        restaurant_brand_id                     <- map["restaurant_brand_id"]
        restaurant_brand_name                   <- map["restaurant_brand_name"]
        branch_id                               <- map["branch_id"]
        branch_name                             <- map["branch_name"]
        status                                  <- map["status"]
        tax_code                                <- map["tax_code"]
        status                                  <- map["status"]
        username                                <- map["username"]
        password                                <- map["password"]
        username_access_service                 <- map["username_access_service"]
        password_access_service                 <- map["password_access_service"]
        invoice_denominator                     <- map["invoice_denominator"]
        invoice_series                          <- map["invoice_series"]
        endpoint                                <- map["endpoint"]
        is_auto_export_third_party              <- map["is_auto_export_third_party"]
        apply_order_types                       <- map["apply_order_types"]
        apply_discount                          <- map["apply_discount"]
        branch_assigns                          <- map["branch_assigns"]
    }
}


struct BranchAssignmentOfEInvoicePartner: Mappable {
    
    var id = 0
    var name = ""
    var phone = ""
    var address = ""
    var status = 0
    var lat = ""
    var lng = ""

    init() {}
  
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id                                      <- map["id"]
        name                                    <- map["name"]
        phone                                   <- map["phone"]
        address                                 <- map["address"]
        status                                  <- map["status"]
        lat                                     <- map["lat"]
        lng                                     <- map["lng"]
    }
}
