//
//  ForegroundPrintProcess.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 11/9/25.
//

import UIKit
import RxSwift
import RxRelay


class ForegroundPrintProcessViewModel: NSObject {
    
    private(set) weak var view: ForegroundPrintProcessViewController?

    var order = BehaviorRelay<OrderDetail>(value: OrderDetail.init())
    var printItems = BehaviorRelay<[Food]>(value: [])

    var printNumber = BehaviorRelay<Int>(value: 0) // số tờ cần in ra trên mỗi item
    var alreadyPrintedNumber = BehaviorRelay<Int>(value: 0) // số tờ đã được in ra
    var printType = BehaviorRelay<Constants.printType>(value: .new_item)
    

    
    public var POSWorkItems = BehaviorRelay<[WIFIWorkItem]>(value: [])
    public var TSCWorkItems = BehaviorRelay<[TSCWorkItem]>(value: [])
    public var BLEWorkItem = BehaviorRelay<BLEWorkItem?>(value: nil)

    public var unconnectedPrinters = BehaviorRelay<[Printer]>(value: [])
    
    func bind(view: ForegroundPrintProcessViewController){
        self.view = view
        
//        logAddresses(of: TSCWorkItems.value)

    }
    
    func startTheNextPOSWorkItem(){
        
        var wifiWorkItems = POSWorkItems.value
                
        if wifiWorkItems.count > 0, let currentWork = wifiWorkItems.first{
            
            currentWork.connectionWork.cancel()
            currentWork.printWork.cancel()
            
            wifiWorkItems.removeFirst()
            
            self.POSWorkItems.accept(wifiWorkItems)
            
            if POSWorkItems.value.count > 0, let nextWork = POSWorkItems.value.first{
                
                if currentWork.connectionWork.isCancelled{
                    let time: DispatchTime = .now() + .milliseconds(1000)
                    nextWork.connectionWork.wait(timeout:time)
                    nextWork.connectionWork.perform()
                }
            }
        }
    }
    
    
    func startTheNextTSCWorkItem(){
        
        var tscWorkItems = TSCWorkItems.value
                
        if tscWorkItems.count > 0, let currentWork = tscWorkItems.first{
            
            currentWork.connectionWork.cancel()
            currentWork.printWork.cancel()
            
            tscWorkItems.removeFirst()
            
            self.TSCWorkItems.accept(tscWorkItems)
            
            if TSCWorkItems.value.count > 0, let nextWork = TSCWorkItems.value.first{
                
                if currentWork.connectionWork.isCancelled{
                    let time: DispatchTime = .now() + .milliseconds(1000)
                    nextWork.connectionWork.wait(timeout:time)
                    nextWork.connectionWork.perform()
                }
            }
        }
    }
    
    
    func calculatePrintNumber(){
        var printNumber = 0
      
//        printNumber += POSWorkItems.value.count + TSCWorkItems.value.flatMap{$0.image}.count
        printNumber += POSWorkItems.value.count + TSCWorkItems.value.count
        if let BLEWorkItem = BLEWorkItem.value{
            printNumber += BLEWorkItem.image.count
        }
        
        self.printNumber.accept(printNumber)
        
        self.view?.lbl_already_printed_number.text = String(format: "0/%d",printNumber)
        
        if self.printNumber.value == 0 && self.alreadyPrintedNumber.value == 0{
            view?.progressBar.setProgress(1, animated: true)
            view?.progressBarTimer.invalidate()
            view?.lbl_already_printed_number.text = "--/--"
            Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false) { timer in
                self.view?.completeHandler?()
                self.view?.actionBack("")
            }
        }
    }
    
  
    func logAddresses<T>(of items: [T]) {
        for (index, var item) in items.enumerated() {
            withUnsafePointer(to: &item) { ptr in
                let address = String(format: "%018p", ptr)
                print("TSCWorkItem[\(index)] address: \(address)")
            }
        }
    }

//    func address<T: AnyObject>(of object: T) -> Int {
//        return unsafeBitCast(object, to: Int.self)
//    }

    func updateReadyPrinted(alreadyPrintedItems:[Int]) -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.updateReadyPrinted(order_id: order.value.id, order_detail_ids: alreadyPrintedItems))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
}
