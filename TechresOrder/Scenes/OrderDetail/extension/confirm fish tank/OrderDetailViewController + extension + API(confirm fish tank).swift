//
//  OrderDetailViewController + extension + API(confirm fish tank).swift
//  TechresOrder
//
//  Created by Pham Khanh Huy on 18/11/25.
//

import UIKit
import ObjectMapper
import RxSwift
import JonAlert
extension OrderDetailViewController{
   
    
    
    func customerConfirmFishTank(item:OrderItem){
        appServiceProvider.rx.request(.postTransferConfirmationToFishTank(item_id: item.id))
       .filterSuccessfulStatusCodes()
       .mapJSON().asObservable()
       .showAPIErrorToast()
       .mapObject(type: APIResponse.self).subscribe(onNext: {[weak self](response) in
            guard let self = self else {return}
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                let list = self.repairAndUpdateFoods(items: [item])
                self.updateSeaFoodToOrder(items: list)
            }else{
                JonAlert.showError(message: response.message ?? "", duration: 3.0)
            }
        }).disposed(by: rxbag)
        
    }
    
    
    private func updateSeaFoodToOrder(items:[FoodUpdate]){
        appServiceProvider.rx.request(.updateFoods(
            branch_id: viewModel.branch_id.value,
            order_id: viewModel.order.value.id,
            foods: items
        ))
       .filterSuccessfulStatusCodes()
       .mapJSON().asObservable()
       .showAPIErrorToast()
       .mapObject(type: APIResponse.self).subscribe(onNext: {[weak self](response) in
            guard let self = self else {return}
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                self.showSuccessMessage(content: "Xác nhận thành công")
            }else{
                JonAlert.showError(message: response.message ?? "", duration: 3.0)
            }
        }).disposed(by: rxbag)
        
    }
       
}
