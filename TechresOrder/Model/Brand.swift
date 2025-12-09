//
//  Brand.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 16/01/2023.
//

import UIKit
import ObjectMapper

struct Brand: Mappable {
    var id = 0
    var status = 0
    var restaurant_id = 0
    var customer_partner_id = 0
    var name = ""
    var address = ""
    var logo_url = ""
    var banner = ""
    var qr_code_checkin = ""
    var description = ""
    var setting = BrandSetting()
    var restaurant_brand_business_types = ""
    var total_branches = 0
    var created_at = ""
    var updated_at = ""
    var service_restaurant_level_id = 0
    var service_restaurant_level_type = 0
    var service_restaurant_level_price = 0
    var is_office = 0
   

    init() {}
    
    init?(map: Map) {
    }
    
    init(id: Int, name:String) {
        self.id = id
        self.name = name
   }
   
   
 

    mutating func mapping(map: Map) {
        id                                      <- map["id"]
        status                                    <- map["status"]
        restaurant_id                                   <- map["restaurant_id"]
        customer_partner_id                                 <- map["customer_partner_id"]
        name                                  <- map["name"]
        address                                  <- map["address"]
        logo_url                      <- map["logo_url"]
        banner                          <- map["banner"]
        qr_code_checkin                         <- map["qr_code_checkin"]
        description                               <- map["description"]
        
        setting                               <- map["setting"]
        restaurant_brand_business_types                               <- map["restaurant_brand_business_types"]
        total_branches                               <- map["total_branches"]
        created_at                               <- map["created_at"]
        updated_at                               <- map["updated_at"]
        service_restaurant_level_id                               <- map["service_restaurant_level_id"]
        service_restaurant_level_type                               <- map["service_restaurant_level_type"]
        service_restaurant_level_price                               <- map["service_restaurant_level_price"]
        
        
        is_office                               <- map["is_office"]
        
        
    }
}
struct BrandSetting: Mappable {
    var branch_type = 3
    var branch_type_option = 1
    var hour_to_take_report = 0
    var is_hide_total_amount_before_complete_bill = 0
    var is_print_bill_logo = 1
    var is_print_bill_on_mobile_app = 0

    var bank_number = ""
    var bank_name = ""
    var bank_account_name = ""
    var template_bill_printer_type = 3


    var payment_type:QRCODE_TYPE = .pay_os
    var is_hidden_payment_detail_in_bill = 0
    var is_show_vat_on_items_in_bill = 0
    var is_enable_buffet = 0

    var maximum_bef_account = 0
    var maximum_shf_account = 0
    var maximum_grf_account = 0
    
    
    var show_branch_name = 0
    var show_address = 0
    var show_cashier_name = 0
    var show_waiter_name = 0
    var show_point_staff_name = 0
    var show_total_amount = 0
    var show_customer_paid_amount = 0
    var show_bill_title = 0
    var show_table_code = 0
    var show_hotline = 0
    var show_salesperson = 0
    var show_datetime = 0
    var show_gift = 0
    var show_points_used = 0
    var show_discount = 0
    var show_vat = 0
    var show_surcharge = 0
    var show_service_charge = 0
    var show_deposit = 0
    var show_qr_code = 0
    var show_bank_info = 0
    var show_footer = 0
    var show_dev_info = 0
    
    
    init?(map: Map) {}
    init?() {}
    
    mutating func mapping(map: Map) {
        branch_type <- map["branch_type"]
        branch_type_option <- map["branch_type_option"]

        hour_to_take_report <- map["hour_to_take_report"]
        is_hide_total_amount_before_complete_bill <- map["is_hide_total_amount_before_complete_bill"]
        is_print_bill_logo <- map["is_print_bill_logo"]
        is_print_bill_on_mobile_app <- map["is_print_bill_on_mobile_app"]
        bank_number <- map["bank_number"]
        bank_name <- map["bank_name"]
        bank_account_name <- map["bank_account_name"]
        template_bill_printer_type <- map["template_bill_printer_type"]
        payment_type <- map["payment_type"]
        is_hidden_payment_detail_in_bill <- map["is_hidden_payment_detail_in_bill"]
        is_show_vat_on_items_in_bill <- map["is_show_vat_on_items_in_bill"]
        is_enable_buffet <- map["is_enable_buffet"]
        maximum_bef_account <- map["maximum_bef_account"]
        maximum_shf_account <- map["maximum_shf_account"]
        maximum_grf_account <- map["maximum_grf_account"]
        
        show_branch_name            <- map["show_branch_name"]
        show_address                <- map["show_address"]
        show_cashier_name           <- map["show_cashier_name"]
        show_waiter_name            <- map["show_waiter_name"]
        show_point_staff_name       <- map["show_point_staff_name"]
        show_total_amount           <- map["show_total_amount"]
        show_customer_paid_amount   <- map["show_customer_paid_amount"]
        show_bill_title             <- map["show_bill_title"]
        show_table_code             <- map["show_table_code"]
        show_hotline                <- map["show_hotline"]
        show_salesperson            <- map["show_salesperson"]
        show_datetime               <- map["show_datetime"]
        show_gift                   <- map["show_gift"]
        show_points_used            <- map["show_points_used"]
        show_discount               <- map["show_discount"]
        show_vat                    <- map["show_vat"]
        show_surcharge              <- map["show_surcharge"]
        show_service_charge         <- map["show_service_charge"]
        show_deposit                <- map["show_deposit"]
        show_qr_code                <- map["show_qr_code"]
        show_bank_info              <- map["show_bank_info"]
        show_footer                 <- map["show_footer"]
        show_dev_info               <- map["show_dev_info"]
        
    }
}
