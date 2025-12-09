//
//  ReportBusinessAnalyticsViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 25/02/2023.
//

import UIKit
import ObjectMapper
import RxSwift
import RxRelay

//MARK: -- CALL API
extension ReportBusinessAnalyticsViewController {
    func getCategoriesManagement(){
        viewModel.getCategories().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let categories = Mapper<Category>().mapArray(JSONObject: response.data) {
                    if(categories.count > 0){
                    
                        
                        

                        self.viewModel.date_string.accept(Constants.REPORT_TYPE_DICTIONARY[REPORT_TYPE_TODAY] ?? "")
                        self.viewModel.report_type.accept(REPORT_TYPE_TODAY)
                        
                        
                        self.cates = categories
                        self.viewPager.reloadData()
                        
                    }
                }
               
            }else{
                dLog(response.message ?? "")
            }
         
        }).disposed(by: rxbag)
    }
}
