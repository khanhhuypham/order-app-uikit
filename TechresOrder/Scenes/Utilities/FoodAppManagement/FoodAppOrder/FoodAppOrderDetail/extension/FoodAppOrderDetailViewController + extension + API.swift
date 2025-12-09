//
//  OrderHistoryDetailOfFoodAppViewController + extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 30/08/2024.
//

import UIKit
import ObjectMapper
import RxSwift
extension FoodAppOrderDetailViewController {
    
    
    
    func getOrderDetail(orderId:Int){
        appServiceProvider.rx.request(.getOrderDetailOfFoodApp(orderId: orderId, is_app_food: ACTIVE))
        .filterSuccessfulStatusCodes()
        .mapJSON().asObservable()
        .showAPIErrorToast()
        .mapObject(type: APIResponse.self).subscribe(onNext: {[weak self] response in
            guard let self = self else { return }
            guard let order = Mapper<FoodAppOrder>().map(JSONObject: response.data) else { return }
            self.viewModel.order.accept(order)
            self.setupData(order: order)
        }).disposed(by: rxbag)
    }
    
    
    func cancelItem(orderId:Int,itemId:Int){
        appServiceProvider.rx.request(.postCancelItemOfFoodApp(orderId: orderId, itemId: itemId))
        .filterSuccessfulStatusCodes()
        .mapJSON().asObservable()
        .showAPIErrorToast()
        .mapObject(type: APIResponse.self).subscribe(onNext: {[weak self] response in
            guard let self = self else { return }

            if response.code == 200 {
                self.showSuccessMessage(content: "Huỷ món thánh công")
                self.getOrderDetail(orderId: orderId)
            }
            
        }).disposed(by: rxbag)
    }
    
        
}
