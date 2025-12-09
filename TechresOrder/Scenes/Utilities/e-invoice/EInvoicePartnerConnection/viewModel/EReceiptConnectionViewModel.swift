//
//  EReceiptConnectionViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 05/06/2025.
//

import UIKit
import RxSwift
import RxRelay
class EReceiptConnectionViewModel: NSObject {
    
    private(set) weak var view: EReceiptConnectionViewController?
    private var router: TechresShopRouter?
    

    public var invoiceArray : BehaviorRelay<[EInvoicePartner]> = BehaviorRelay(value: [])
    
    
    
    func bind(view: EReceiptConnectionViewController){
        self.view = view

    }
    
}


extension EReceiptConnectionViewModel {

    func getRestaurantPartnerInvoice() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.getPartnerInvoiceConnection)
       .filterSuccessfulStatusCodes()
       .mapJSON().asObservable()
       .showAPIErrorToast()
       .mapObject(type: APIResponse.self)
    }
    
    
    func changeStatus(id:Int) -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.postChangeStatusPartnerInvoiceConnection(id: id, is_confirm: ACTIVE))
       .filterSuccessfulStatusCodes()
       .mapJSON().asObservable()
       .showAPIErrorToast()
       .mapObject(type: APIResponse.self)
    }
    
    
    
}



