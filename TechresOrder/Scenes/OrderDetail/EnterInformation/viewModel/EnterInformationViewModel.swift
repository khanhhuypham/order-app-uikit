//
//  EnterInformationViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 29/03/2025.
//

import UIKit
import RxRelay
import RxSwift
class EnterInformationViewModel: NSObject {
    private(set) weak var view: EnterInformationViewController?

    public var orderId : BehaviorRelay<Int> = BehaviorRelay(value: 0)

    public var customer : BehaviorRelay<Customer> = BehaviorRelay(value:Customer.init())

    

    func bind(view: EnterInformationViewController){
        self.view = view
    }
    
    
    func assignCustomerToOrder() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.postAssignCustomerToOrder(
            branchId: Constants.branch.id,
            orderId: orderId.value,
            customer: customer.value)
        )
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
    
    func unassignCustomerFromOrder(orderId:Int) -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.postUnassignCustomerFromOrder(order_id: orderId))
           .filterSuccessfulStatusCodes()
           .mapJSON().asObservable()
           .showAPIErrorToast()
           .mapObject(type: APIResponse.self)
    }
    
    func createCustomer() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.postCreateNewCustomer(orderId: orderId.value,customer:customer.value))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
    
    func getCustomerList(phone:String) -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.getAlolineCustomer(key_search: phone, branch_id: Constants.branch.id))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
    
    
    
    
    
    
    
    
    
}
