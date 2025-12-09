//
//  FoodAppReportViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 23/08/2024.
//

import UIKit
import RxSwift
import RxRelay

class FoodAppReportViewModel: BaseViewModel {
    
    private(set) weak var view: FoodAppReportViewController?
    private var router: FoodAppReportRouter?
    
    public var report = BehaviorRelay<FoodAppReport>(value: FoodAppReport.init(reportType: REPORT_TYPE_TODAY, dateString: TimeUtils.getCurrentDateTime().dateTimeNow))
    
  
    func bind(view: FoodAppReportViewController, router: FoodAppReportRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(view)
    }
    
    func makePopViewController(){
        router?.navigatePopViewController()
    }
    
}

extension FoodAppReportViewModel {

    func getRevenueSumaryReportOfFoodApp() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.getRevenueSummaryReportOfFoodApp(
            brand_id: Constants.brand.id,
            branch_id: Constants.branch.id,
            date_string: report.value.dateString,
            report_type: report.value.reportType
        ))
       .filterSuccessfulStatusCodes()
       .mapJSON().asObservable()
       .showAPIErrorToast()
       .mapObject(type: APIResponse.self)
    }
    
}


