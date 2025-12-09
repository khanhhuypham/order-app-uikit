//
//  CouponViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 24/10/25.
//

import UIKit
import RxRelay
class CouponViewModel: NSObject {
    private (set) var view: CouponViewController?
    var order = BehaviorRelay<OrderDetail>(value: OrderDetail())
    var list = BehaviorRelay<[Coupon]>(value: [])
    
    func bind(view:CouponViewController){
        self.view = view
    }
}
