//
//  ClosedSessionHistoryViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 17/06/2025.
//

import UIKit
import RxRelay
import RxSwift

class ClosedSessionHistoryViewModel: NSObject {
    
    private(set) weak var view: ClosedSessionHistoryViewController?
    

    public var dataArray : BehaviorRelay<[WorkingSessionValue]> = BehaviorRelay(value: [])
    var dateType = BehaviorRelay<Int>(value: 0)
    var APIParameter = BehaviorRelay<(
        restaurant_id:Int,
        branch_id:Int,
        area_id:Int,
        from_date:String,
        to_date:String,
        key_search:String,
        limit:Int,
        page:Int,
        isAPICalling:Bool,
        isGetFullData:Bool
    )>(value: (
        restaurant_id:Constants.restaurant_id,
        branch_id: Constants.branch.id,
        area_id:ALL,
        from_date:Utils.getCurrentDateString(),
        to_date:Utils.getCurrentDateString(),
        key_search:"",
        limit:20,
        page:1,
        isAPICalling:false,
        isGetFullData:false
    ))
    
   
    
    func bind(view: ClosedSessionHistoryViewController){
        self.view = view

    }
    
    func clearDataAndCallAPI(){
        dataArray.accept([])
        var p = APIParameter.value
        p.page = 1
        p.isGetFullData = false
        p.isAPICalling = true
        APIParameter.accept(p)
        view?.getClosedSessionHistory()
    }
    


}


extension ClosedSessionHistoryViewModel {
    
    func getClosedSessionHistory() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(
            .getClosedSessionHistory(
                restaurant_id: APIParameter.value.restaurant_id,
                branch_id: APIParameter.value.branch_id,
                area_id: APIParameter.value.area_id,
                from: APIParameter.value.from_date,
                to: APIParameter.value.to_date,
                key_search: APIParameter.value.key_search,
                limit: APIParameter.value.limit,
                page: APIParameter.value.page
            ))
       .filterSuccessfulStatusCodes()
       .mapJSON().asObservable()
       .showAPIErrorToast()
       .mapObject(type: APIResponse.self)
    }
    

}
