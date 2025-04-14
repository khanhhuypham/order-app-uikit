//
//  EditFoodOptionViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 26/02/2025.
//

import UIKit
import RxSwift
import RxRelay
import RxDataSources
class EditFoodOptionViewModel: NSObject {
    
    private(set) weak var view: EditFoodOptionViewController?
    var orderId = BehaviorRelay<Int>(value: 0)
    
    var orderItem = BehaviorRelay<OrderItem>(value: OrderItem())
    
    public var sectionArray = BehaviorRelay<[SectionModel<OptionOfDetailItem,OptionItem>]>(value:[
        SectionModel(model: OptionOfDetailItem(),items: [])
    ])
    
    func bind(view: EditFoodOptionViewController){
        self.view = view
    }
    
    
    func setSection(section:SectionModel<OptionOfDetailItem,OptionItem>,indexPath:IndexPath) {
    
        var sections = sectionArray.value
        sections[indexPath.section] = section
        self.sectionArray.accept(sections)

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
