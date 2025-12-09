//
//  OrderManagementOfFoodAppViewController + extension + api.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 20/08/2024.
//

import UIKit
import RxSwift
import RxRelay
import ObjectMapper
extension OrderManagementOfFoodAppViewController {
    
    
    func getOrderHistoryOfFoodApp(){
        
        appServiceProvider.rx.request(.getOrderHistoryOfFoodApp(
            brand_id: Constants.brand.id,
            branch_id: Constants.branch.id,
            food_channel_id: viewModel.history.value.partnerId,
            report_type: viewModel.history.value.reportType,
            date_string: viewModel.history.value.dateString,
            page:viewModel.pagination.value.page,
            limit: viewModel.pagination.value.limit
        ))
        .filterSuccessfulStatusCodes()
        .mapJSON().asObservable()
        .showAPIErrorToast()
        .mapObject(type: APIResponse.self).subscribe(onNext: {[weak self] (response) in
            guard let self = self else { return }
            
            if var data = Mapper<OrderHistoryOfFoodAppResponse>().map(JSONObject: response.data){
                var history = viewModel.history.value
                var p = viewModel.pagination.value
                data.reportType = history.reportType
                data.dateString = history.dateString
                data.partnerId = history.partnerId
                
                
                if(data.list.count > 0 && !p.isGetFullData){
                    history.list.append(contentsOf: data.list)
                }
                history.total_revenue = data.total_revenue
                history.total_revenue_GRF = data.total_revenue_GRF
                history.total_revenue_SHF = data.total_revenue_SHF
                history.total_revenue_BEF = data.total_revenue_BEF
                history.total_record = data.total_record
                
                
                p.isGetFullData = history.list.count >= data.total_record ? true : false
                p.isAPICalling = false
                
                viewModel.pagination.accept(p)
                viewModel.history.accept(history)
                
                lbl_total_revenue.text = data.total_revenue.toString
                lbl_GRF_total_revenue.text = String(format: "GrabFood: %@", data.total_revenue_GRF.toString)
                lbl_SHF_total_revenue.text = String(format: "SPFood: %@", data.total_revenue_SHF.toString)
                lbl_BEF_total_revenue.text = String(format: "BeFood: %@", data.total_revenue_BEF.toString)
                lbl_total_complete.text = String(data.total_order_completed)
                lbl_total_cancel.text = String(data.total_order_cancelled)
                view_no_data.isHidden = !history.list.isEmpty

            }
            
        }).disposed(by: rxbag)
    }
}
