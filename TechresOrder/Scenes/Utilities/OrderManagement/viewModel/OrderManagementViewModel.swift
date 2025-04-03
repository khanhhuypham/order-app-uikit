//
//  OrderManagementViewModel.swift
//  TechresOrder
//
//  Created by Kelvin on 25/01/2023.
//

import UIKit
import RxRelay
import RxSwift

class OrderManagementViewModel: BaseViewModel {
    private(set) weak var view: OrderManagementViewController?
    private var router: OrderManagementRouter?
    
    // MARK: - Variable -
    // listing data array observe by rxswift
    public var dataArray : BehaviorRelay<[Order]> = BehaviorRelay(value: [])

    public var employeeId : BehaviorRelay<Int> = BehaviorRelay(value: permissionUtils.isSaleReport ? -1 : ManageCacheObject.getCurrentUser().id)
    
    var APIParameter = BehaviorRelay<(
        brand_id:Int,
        branch_id:Int,
        report_type:REPORT_TYPE,
        from_date:String,
        to_date:String,
        key_search:String,
        limit:Int,
        page:Int,
        isGetFullData:Bool
    )>(value: (
        brand_id: Constants.brand.id,
        branch_id: Constants.branch.id,
        report_type:.today,
        from_date:REPORT_TYPE.today.from_date,
        to_date:REPORT_TYPE.today.to_date,
        key_search:"",
        limit:20,
        page:1,
        isGetFullData:false
    ))
   

    func bind(view: OrderManagementViewController, router: OrderManagementRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    
    
    
      func clearDataAndCallAPI(){
          dataArray.accept([])
          var apiParameter = APIParameter.value
          apiParameter.page = 1
          apiParameter.isGetFullData = false
          APIParameter.accept(apiParameter)
          view?.ordersHistory()
          view?.getTotalAmountOfOrders()
      }
    
    
    func makePayMentViewController(order:Order){
        router?.navigateToPayMentViewController(order: OrderDetail(order: order))
    }
    
    func makePopViewController(){
        router?.navigateToPopViewController()
    }
    
}
extension OrderManagementViewModel {
    
    func orders() -> Observable<APIResponse> {
        
        return appServiceProvider.rx.request(.ordersHistory(
            brand_id:APIParameter.value.brand_id,
            branch_id:APIParameter.value.branch_id,
            from_date:APIParameter.value.from_date,
            to_date:APIParameter.value.to_date,
            order_status: String(format: "%d,%d,%d", ORDER_STATUS_COMPLETE, ORDER_STATUS_DEBT_COMPLETE, ORDER_STATUS_CANCEL),
            limit: APIParameter.value.limit,
            page: APIParameter.value.page,
            key_search: APIParameter.value.key_search
          ))
           .filterSuccessfulStatusCodes()
           .mapJSON().asObservable()
           .showAPIErrorToast()
           .mapObject(type: APIResponse.self)
    }
    
    func getTotalAmountOfOrders() -> Observable<APIResponse> {
     
        return appServiceProvider.rx.request(.getTotalAmountOfOrders(
            restaurant_brand_id: ManageCacheObject.getCurrentBrand().id,
            branch_id: ManageCacheObject.getCurrentBranch().id,
//            is_take_away_table: (permissionUtils.GPBH_1 || permissionUtils.GPBH_2_o_1) ? ALL : DEACTIVE,
            order_status: String(format: "%d,%d,%d", ORDER_STATUS_COMPLETE, ORDER_STATUS_DEBT_COMPLETE, ORDER_STATUS_CANCEL),
            key_search:APIParameter.value.key_search,
            from_date:APIParameter.value.from_date,
            to_date:APIParameter.value.to_date
        ))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
                                    
    }
    
}
