//
//  OrderHistoryDetailOfFoodAppViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 30/08/2024.
//

import UIKit
import RxSwift
import RxRelay

class OrderHistoryDetailOfFoodAppViewModel: BaseViewModel {
    
    private(set) weak var view: OrderHistoryDetailOfFoodAppViewController?
    public var order : BehaviorRelay<OrderHistoryDetailOfFoodApp> = BehaviorRelay(value: OrderHistoryDetailOfFoodApp())
    
    func bind(view: OrderHistoryDetailOfFoodAppViewController){
        self.view = view

    }
    

    
    
}
