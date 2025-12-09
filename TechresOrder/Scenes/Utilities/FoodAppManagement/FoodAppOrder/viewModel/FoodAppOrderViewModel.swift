//
//  FoodAppOrderViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 19/11/25.
//

import UIKit
import RxRelay

class FoodAppOrderViewModel: NSObject {
    private(set) weak var view: FoodAppOrderViewController?
    

    public var APIParameter = BehaviorRelay<(confirmation:Int,partner:APP_PARTNER)>(value: (confirmation:0,partner:.shoppee))
    
    public var array : BehaviorRelay<[FoodAppOrder]> = BehaviorRelay(value: [])
    
    
    func bind(view: FoodAppOrderViewController){
        self.view = view
    }
    
}
