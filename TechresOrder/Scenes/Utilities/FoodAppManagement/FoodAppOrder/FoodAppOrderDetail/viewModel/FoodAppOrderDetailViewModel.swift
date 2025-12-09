//
//  OrderHistoryDetailOfFoodAppViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 30/08/2024.
//

import UIKit
import RxSwift
import RxRelay

class FoodAppOrderDetailViewModel: BaseViewModel {
    
    private(set) weak var view: FoodAppOrderDetailViewController?
    public var order : BehaviorRelay<FoodAppOrder> = BehaviorRelay(value: FoodAppOrder())
    
    func bind(view: FoodAppOrderDetailViewController){
        self.view = view

    }
        
}
