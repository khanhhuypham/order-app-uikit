//
//  OrderManagementOfFoodAppViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 20/08/2024.
//

import UIKit
import RxRelay
class OrderManagementOfFoodAppViewModel: BaseViewModel {
    private(set) weak var view: OrderManagementOfFoodAppViewController?

    public var pagination : BehaviorRelay<(
        limit:Int,
        page:Int,
        isGetFullData:Bool,
        isAPICalling:Bool
    )> = BehaviorRelay(value: (
            limit:50,
            page:1,
            isGetFullData:false,
            isAPICalling:false
        )
    )
    
    public var history = BehaviorRelay<OrderHistoryOfFoodAppResponse>(value:
        OrderHistoryOfFoodAppResponse(
            partnerId: -1,
            reportType: REPORT_TYPE_TODAY,
            dateString: TimeUtils.getCurrentDateTime().dateTimeNow
        )
    )
    
    public var filterType = BehaviorRelay<Int>(value: 0)
    
    public var reportTypeFilter = BehaviorRelay<[(Int, String)]>(value: [
        (REPORT_TYPE_TODAY, "Hôm nay"),
        (REPORT_TYPE_YESTERDAY, "Hôm qua"),
        (REPORT_TYPE_THIS_WEEK, "Tuần này"),
        (REPORT_TYPE_LAST_MONTH, "Tháng trước"),
        (REPORT_TYPE_THIS_MONTH, "Tháng này"),
        (REPORT_TYPE_THREE_MONTHS, "3 tháng gần nhất"),
        (REPORT_TYPE_LAST_YEAR, "Năm trước"),
        (REPORT_TYPE_THIS_YEAR, "Năm nay"),
        (REPORT_TYPE_THREE_YEAR, "3 Năm gần nhất"),
        (REPORT_TYPE_ALL_YEAR, "Tất các năm")
    ])
    
    public var partnerFilter = BehaviorRelay<[String:Int]>(value: [
        "Tất cả":-1,
        "BeFood":4,
        "Grab":2,
        "SPFood":1,
    ])
    
    func clearDataAndCallAPI(){
        var p = pagination.value
        var h = history.value
        
        p.page = 1
        p.isGetFullData = false
        p.isAPICalling = false
        h.list.removeAll()

        pagination.accept(p)
        history.accept(h)
        view?.getOrderHistoryOfFoodApp()
    }
    
    
    func bind(view: OrderManagementOfFoodAppViewController){
        self.view = view
    }
    
}
