//
//  NotificationSetting.swift
//  TECHRES-ORDER
//
//  Created by Kelvin on 14/12/24.
//

import UIKit
import ObjectMapper

struct NotificationSetting: Mappable{
    var is_enable_checkin_checkout = 0
    var is_on_leave = 0
    var is_salary_advance = 0
    var is_browse_kaizen_articles = 0
    var is_personal_kaizen = 0
    var is_notice_from_supplier = 0
    var is_booking = 0
    var is_support_reward_punishment_of_employees = 0
    var is_inventory = 0
    var is_goods_request = 0
    var is_purchase_manager = 0
    var is_warehouse_management = 0
    var is_set_goals = 0
    var is_change_password = 0
    var is_create_temporary_jobs = 0
    var is_temporarily_lock_staff = 0
    var is_check_payroll = 0
    var is_turn_it_all_off = 0
    var is_enable_chat = 0
 
    init?(map: Map) {
    }
    init?() {
    }
    
    mutating func mapping(map: Map) {
        is_enable_checkin_checkout <- map["is_enable_checkin_checkout"]
        is_on_leave <- map["is_on_leave"]
        is_salary_advance <- map["is_salary_advance"]
        is_browse_kaizen_articles <- map["is_browse_kaizen_articles"]
        is_personal_kaizen <- map["is_personal_kaizen"]
        is_notice_from_supplier <- map["is_notice_from_supplier"]
        is_booking <- map["is_booking"]
        is_support_reward_punishment_of_employees <- map["is_support_reward_punishment_of_employees"]
        is_inventory <- map["is_inventory"]
        is_goods_request <- map["is_goods_request"]
        is_purchase_manager <- map["is_purchase_manager"]
        is_warehouse_management <- map["is_warehouse_management"]
        is_set_goals <- map["is_set_goals"]
        is_change_password <- map["is_change_password"]
        is_create_temporary_jobs <- map["is_create_temporary_jobs"]
        is_temporarily_lock_staff <- map["is_temporarily_lock_staff"]
        is_check_payroll <- map["is_check_payroll"]
        is_turn_it_all_off <- map["is_turn_it_all_off"]
        is_enable_chat <- map["is_enable_chat"]
    }
}

