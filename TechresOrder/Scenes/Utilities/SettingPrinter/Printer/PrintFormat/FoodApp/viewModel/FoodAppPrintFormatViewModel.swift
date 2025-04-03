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

    var order = BehaviorRelay<FoodAppOrder>(value: FoodAppOrder.init())
    
    var orders = BehaviorRelay<[FoodAppOrder]>(value: [])
    
    var limitLine = BehaviorRelay<Int>(value: 4)

    var printNumber = BehaviorRelay<Int>(value: 0) // số tờ cần in ra trên mỗi item
    var alreadyPrintedNumber = BehaviorRelay<Int>(value: 0) // số tờ đã được in ra
    var printType = BehaviorRelay<Constants.printType>(value: .new_item)
    
    
    var TSCWorkItem = BehaviorRelay<TSCWorkItem?>(value: nil)
    var WIFIWorkItems = BehaviorRelay<[WIFIWorkItem]>(value: [])
    var totalWIFIWorkItems = BehaviorRelay<Int>(value: 0)
    

    func bind(view: FoodAppPrintFormatViewController){
        self.view = view
    }
    
    
    func startTheNextWorkItem(){
        var wifiWorkItems = WIFIWorkItems.value
                
        if wifiWorkItems.count > 0, let currentWork = wifiWorkItems.first{
            
            currentWork.connectionWork.cancel()
            currentWork.printWork.cancel()
            
            wifiWorkItems.removeFirst()
            
            self.WIFIWorkItems.accept(wifiWorkItems)
            
            if WIFIWorkItems.value.count > 0, let nextWork = WIFIWorkItems.value.first{
                
                if currentWork.connectionWork.isCancelled{
                    let time: DispatchTime = .now() + .milliseconds(1000)
                    nextWork.connectionWork.wait(timeout:time)
                    nextWork.connectionWork.perform()
                }
            }
        }
     
    }
    

    
    func address<T: AnyObject>(of object: T) -> Int {
        return unsafeBitCast(object, to: Int.self)
    }

}
