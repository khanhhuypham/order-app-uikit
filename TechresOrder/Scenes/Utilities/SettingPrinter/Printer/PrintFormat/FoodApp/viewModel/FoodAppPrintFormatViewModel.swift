//
//  FoodAppPrintFormatViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 21/08/2024.
//

import UIKit
import RxRelay
class FoodAppPrintFormatViewModel: NSObject {
    
    private(set) weak var view: FoodAppPrintFormatViewController?
    var orders = BehaviorRelay<[FoodAppOrder]>(value:[])
    var currentOrder = BehaviorRelay<FoodAppOrder>(value: FoodAppOrder.init())
    

    
    func bind(view: FoodAppPrintFormatViewController){
        self.view = view
    }
    
     
    func address<T: AnyObject>(of object: T) -> Int {
        return unsafeBitCast(object, to: Int.self)
    }

}
