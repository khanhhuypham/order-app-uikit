//
//  EditFoodOptionViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 26/02/2025.
//

import UIKit
import RxSwift
import RxRelay
class EditFoodOptionViewModel: NSObject {
    
    private(set) weak var view: EditFoodOptionViewController?
    var orderId = BehaviorRelay<Int>(value: 0)
    var orderItem = BehaviorRelay<OrderItem>(value: OrderItem())
    
    func bind(view: EditFoodOptionViewController){
        self.view = view
    }
    
   
    func updateFoods(updateFood: [FoodUpdate]) -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.updateFoods(
                branch_id: ManageCacheObject.getCurrentBranch().id,
                order_id: orderId.value,
                foods: updateFood))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
}
