//
//  EInvoiceManagementViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 07/06/2025.
//

import UIKit
import RxSwift
import RxRelay

class EInvoiceManagementViewModel: NSObject {
    
    private(set) weak var view: EInvoiceManagementViewController?
    
    private var router: EInvoiceManagementRouter?
    
    public var tabType : BehaviorRelay<Int> = BehaviorRelay(value: 1)
    
    public var invoiceArray : BehaviorRelay<[EInvoice]> = BehaviorRelay(value: [])
    
    var APIParameter = BehaviorRelay<(
        apply_order_type:Int,
        cct_duyet:Int,
        invoice_status:Int,
        branch_id:Int,
        from_date:String,
        to_date:String,
        key_search:String,
        limit:Int,
        page:Int,
        isGetFullData:Bool
    )>(value: (
        apply_order_type:ALL,
        cct_duyet:-1,
        invoice_status:-1,
        branch_id: Constants.branch.id,
        from_date:REPORT_TYPE.today.from_date,
        to_date:REPORT_TYPE.today.to_date,
        key_search:"",
        limit:20,
        page:1,
        isGetFullData:false
    ))
    
    func bind(view: EInvoiceManagementViewController, router: EInvoiceManagementRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
    
    
    func clearDataAndCallAPI(){
        invoiceArray.accept([])
        var apiParameter = APIParameter.value
        apiParameter.page = 1
        apiParameter.isGetFullData = false
        APIParameter.accept(apiParameter)
        view?.getInvoiceList()
    }
    
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
         
    

    func makePayMentViewController(order:Order){
        router?.navigateToPayMentViewController(order: OrderDetail(order: order))
    }
    

}


extension EInvoiceManagementViewModel {
    
    func getInvoiceList() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.getEInvoiceList(
            apply_order_type: APIParameter.value.apply_order_type,
            key_search: APIParameter.value.key_search,
            branch_id: APIParameter.value.branch_id,
            limit: APIParameter.value.limit,
            page: APIParameter.value.page,
            from: APIParameter.value.from_date,
            to: APIParameter.value.to_date,
            cct_duyet: APIParameter.value.cct_duyet,
            invoice_status:APIParameter.value.invoice_status
        ))
       .filterSuccessfulStatusCodes()
       .mapJSON().asObservable()
       .showAPIErrorToast()
       .mapObject(type: APIResponse.self)
    }
    

}
