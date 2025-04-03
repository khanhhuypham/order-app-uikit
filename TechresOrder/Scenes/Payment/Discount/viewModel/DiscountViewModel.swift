//
//  DiscountViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 20/01/2023.
//

import UIKit
import RxRelay
import RxSwift

class DiscountViewModel: BaseViewModel {
    private(set) weak var view: DiscountViewController?

    var seletecBtn = BehaviorRelay<UIButton>(value: UIButton())
    public var APIParameter : BehaviorRelay<(
        order_id:Int,
        discountType:DISCOUNT_TYPE,
        discountReasonType:Int,
        
        food_discount_amount:Int,
        drink_discount_amount:Int,
        total_bill_discount_amount:Int,
        
        food_discount_percent:Int,
        drink_discount_percent:Int,
        total_bill_discount_percent:Int,
        
    
        note:String
    )> = BehaviorRelay(value: (
            order_id:0,
            discountType:.percent,
            discountReasonType:1,
            
            
            food_discount_amount:0,
            drink_discount_amount:0,
            total_bill_discount_amount:0,
            
            food_discount_percent:0,
            drink_discount_percent:0,
            total_bill_discount_percent:0,
            
            note:""
        )
    )
    
    

    func bind(view: DiscountViewController){
        self.view = view

    }

    
}
extension DiscountViewModel{
    func discount() -> Observable<APIResponse> {
        
        return appServiceProvider.rx.request(.discount(
            order_id:APIParameter.value.order_id,
            branch_id:ManageCacheObject.getCurrentBranch().id,
            
            food_discount_percent:APIParameter.value.food_discount_percent,
            drink_discount_percent:APIParameter.value.drink_discount_percent,
            total_amount_discount_percent:APIParameter.value.total_bill_discount_percent,
            
            food_discount_amount:Double(APIParameter.value.food_discount_amount),
            drink_discount_amount:Double(APIParameter.value.drink_discount_amount),
            total_amount_discount_amount:Double(APIParameter.value.total_bill_discount_amount),
            
            note:APIParameter.value.note))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
}
