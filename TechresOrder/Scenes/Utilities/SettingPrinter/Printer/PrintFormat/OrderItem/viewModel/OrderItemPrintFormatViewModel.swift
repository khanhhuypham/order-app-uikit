//
//  OrderItemPrintFormatViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 26/12/2023.
//

import UIKit
import RxRelay
import RxSwift
import RealmSwift
class OrderItemPrintFormatViewModel: BaseViewModel {
    
    private(set) weak var view: OrderItemPrintFormatViewController?

    var order = BehaviorRelay<OrderDetail>(value: OrderDetail.init())
    var printItems = BehaviorRelay<[Food]>(value: [])

    var printType = BehaviorRelay<KITCHEN_TICKET_TYPE>(value: .new_item)
    

    func bind(view: OrderItemPrintFormatViewController){
        self.view = view
    }



}
