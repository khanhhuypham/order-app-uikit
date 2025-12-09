//
//  EmployeeRevenueReport.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 14/09/2023.
//

import UIKit
import ObjectMapper

struct EmployeeRevenueReport:Mappable{
    
    
    var reportType = 0
    var dateString = ""
    var fromDate = ""
    var toDate = ""
    var reportData:[RevenueEmployee] = []
    var total_revenue = 0

    
 
    
    init?(map: Map) {
    }
    init?(){}
    
    init(reportType:Int, dateString:String){
        self.reportType = reportType
        self.dateString = dateString
    }
    
    init(reportType:Int, dateString:String,fromDate:String,toDate:String){
        self.reportType = reportType
        self.dateString = dateString
        self.fromDate = fromDate
        self.toDate = toDate
    }
    
    mutating func mapping(map: Map) {
        reportData <- map["list"]
        total_revenue <- map["total_revenue"]

    }
    
}
