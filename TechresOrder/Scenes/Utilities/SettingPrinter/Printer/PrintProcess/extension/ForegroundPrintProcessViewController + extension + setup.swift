//
//  OrderItemPrintFormatViewController + extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 22/12/2023.
//

import UIKit
import RealmSwift
extension ForegroundPrintProcessViewController {

    
    func firstSetup(){

        let blurEffectView: UIVisualEffectView = {
            let blurEffect = UIBlurEffect(style: .systemThickMaterialDark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            
            blurEffectView.alpha = 0.8
            
            // Setting the autoresizing mask to flexible for
            // width and height will ensure the blurEffectView
            // is the same size as its parent view.
            blurEffectView.autoresizingMask = [
                .flexibleWidth, .flexibleHeight
            ]
            return blurEffectView
        }()

        // Add the blurEffectView with the same
        // size as view
        blurEffectView.frame = self.progressView.bounds
        progressView.insertSubview(blurEffectView, at: 0)
        progressView.backgroundColor = UIColor.systemGray4

        progressBar.progress = 0.0
        progressBar.layer.cornerRadius = 1.5
        progressBar.clipsToBounds = true
        progressBar.layer.sublayers![1].cornerRadius = 1.5
        progressBar.subviews[1].clipsToBounds = true
        
        progressBarTimer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(updateProgressView), userInfo: nil, repeats: true)
        NotificationCenter.default.addObserver(self,selector:#selector(connectPrinterSuccessfully(_:)),name: NSNotification.Name(PRINTER_NOTIFI.CONNECT_SUCCESS),object: nil)
        NotificationCenter.default.addObserver(self,selector:#selector(connectPrinterFail(_:)),name: NSNotification.Name(PRINTER_NOTIFI.CONNECT_FAIL),object: nil)
        NotificationCenter.default.addObserver(self,selector:#selector(printSuccessFully(_:)),name: NSNotification.Name(PRINTER_NOTIFI.PRINT_SUCCESS),object: nil)
        NotificationCenter.default.addObserver(self,selector:#selector(printFail(_:)),name: NSNotification.Name(PRINTER_NOTIFI.PRINT_FAIL),object: nil)
    }
    
    
    @objc func updateProgressView(){
        progressBar.setProgress(progressPercent, animated: true)
        
        switch viewModel.printType.value{
            
           case .print_test:
            
                if progressBar.progress == 1.0{
                    
                    progressBarTimer.invalidate()
                    Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
                        self.actionBack("")
                    }
                    
                }
            
               break
            
           default:

               break
       }
    }
    
    
    @objc func printSuccessFully(_ notification: Notification){
        
        let object = notification.object as! [String:Any]
        
        if !object.isEmpty,
           let id = try? ObjectId(string: object["id"] as? String ?? ""),
           let isLastItem = object["isLastItem"]as? Bool,
           let printMethod = PRINTER_METHOD.init(rawValue: object[PRINTER_NOTIFI.PRINTER_METHOD_KEY] as? Int ?? 0)
        {
            
            progressPercent +=  1.0/Float(viewModel.printNumber.value)
            //===================================================================================
            viewModel.alreadyPrintedNumber.accept(viewModel.alreadyPrintedNumber.value + 1)//||
            //===================================================================================
            lbl_already_printed_number.text = String(format: "%d/%d",viewModel.alreadyPrintedNumber.value,viewModel.printNumber.value)

            switch printMethod {
                
                case .POSPrinter:
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        LocalDataBaseUtils.shared.removePOSQueuedItemById(id: id)
                        self.POSPrinterUtility?.wifiDisconnect()
                        self.viewModel.startTheNextPOSWorkItem()
                    })

                    break
                
            case .TSCPrinter:
                    if isLastItem{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                            self.TSCPrinterUtility?.wifiDisconnect()
                            LocalDataBaseUtils.shared.removeTSCQueuedItemById(id: id)
                            self.viewModel.startTheNextTSCWorkItem()
                        })
                    }
                    break
                
                case .BLEPrinter:
                    isLastItem ? BLEPrinterUtility?.bleManager.disconnectRootPeripheral() : {}()
                    break
                
            }
            
            if isLastItem{
                switch viewModel.printType.value{
                    case .new_item,.cancel_item,.return_item:
                        updateAlreadyPrintedItem()
                        break

                    default:
                        break
                }
            }
            
            
            
        }

    }
    
    @objc func printFail(_ notification: Notification){
//        messageBox("Lỗi In", withTitle: "Cảnh báo", withAutoDismiss: true)
    }
                                        
    @objc func connectPrinterFail(_ notification: Notification){
        let object = notification.object as! [String:Any]
        guard
            let id = try? ObjectId(string: object["id"] as? String ?? ""),
            let error = object["error"] as? NSError,
            let printer = object["printer"] as? Printer,
            let rawValue = object[PRINTER_NOTIFI.PRINT_MODE] as? Int,
            let printMode = PRINT_MODE(rawValue: rawValue),
            let printMethod = PRINTER_METHOD.init(rawValue: object[PRINTER_NOTIFI.PRINTER_METHOD_KEY] as? Int ?? 0)
        else{
            actionBack("")
            return
        }
        updateAlreadyPrintedItem(id:id,printMethod: printMethod,WithError: true)
        Toast.show(message: error.localizedDescription, controller: self)
        if viewModel.unconnectedPrinters.value.first(where: {$0.id == printer.id}) == nil && printer.connection_type == .wifi{
            var unconnectedPrinters = viewModel.unconnectedPrinters.value
            unconnectedPrinters.append(printer)
            viewModel.unconnectedPrinters.accept(unconnectedPrinters)
        }
    }
    
    
    @objc func connectPrinterSuccessfully(_ notification: Notification){
        let object = notification.object as! [String:Any]
        let printMethod = PRINTER_METHOD.init(rawValue: object[PRINTER_NOTIFI.PRINTER_METHOD_KEY] as? Int ?? 0)
        switch printMethod {
            
            case .POSPrinter:
                if let id = try? ObjectId(string: object["id"] as? String ?? ""){
                    let posWorkItems = viewModel.POSWorkItems.value
                    if let p = posWorkItems.firstIndex(where: {$0.objectId == id}){
                        posWorkItems[p].printWork.perform()
                    }
                }
            
            case .TSCPrinter:
                if let id = try? ObjectId(string: object["id"] as? String ?? ""){
                    let tscWorkItems = viewModel.TSCWorkItems.value
                    if let p = tscWorkItems.firstIndex(where: {$0.objectId == id}){
                        tscWorkItems[p].printWork.perform()
                    }
                }
            
            case .BLEPrinter:
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1){
                    let workItem = self.viewModel.BLEWorkItem.value
                    workItem?.printWork.perform()
                }
            
            default:
                actionBack("")
                break
                
        }

    }
    

    
    func updateAlreadyPrintedItem(id:ObjectId? = nil,printMethod:PRINTER_METHOD? = nil,WithError:Bool = false){
        var printNumber = viewModel.printNumber.value
        
        if WithError,let method = printMethod{
           
            switch method{
                
                case .POSPrinter:
                
                    var posWorkItems = viewModel.POSWorkItems.value
                    if let pos = posWorkItems.firstIndex(where: {$0.objectId == id}),let printer = posWorkItems[pos].printer{
                        self.POSPrinterUtility?.wifiDisconnect()
                        for (index,workItem) in posWorkItems.enumerated(){
                            if workItem.printer?.id == printer.id{
                                posWorkItems[index].connectionWork.cancel()
                                posWorkItems[index].printWork.cancel()
                                handlePOSError(workItem: workItem)
                            }
                        }
                        posWorkItems.removeAll(where: {$0.printer?.id == printer.id})
                    }
                    self.viewModel.POSWorkItems.accept(posWorkItems)
                    
                    if viewModel.POSWorkItems.value.count > 0, let nextWork = viewModel.POSWorkItems.value.first {
                        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                            nextWork.connectionWork.perform()
                        }
                    }
                
                case .TSCPrinter:
                    var tscWorkItems = viewModel.TSCWorkItems.value
                    if let pos = tscWorkItems.firstIndex(where: {$0.objectId == id}),let printer = tscWorkItems[pos].printer{
                        self.TSCPrinterUtility?.wifiDisconnect()

                        for (index,workItem) in tscWorkItems.enumerated(){
                            if workItem.printer?.id == printer.id{
                                tscWorkItems[index].connectionWork.cancel()
                                tscWorkItems[index].printWork.cancel()
                                handleTSCError(workItem: workItem)
                            }
                        }
                        tscWorkItems.removeAll(where: {$0.printer?.id == printer.id})
                    }
                    self.viewModel.TSCWorkItems.accept(tscWorkItems)
                
                    if viewModel.TSCWorkItems.value.count > 0, let nextWork = viewModel.TSCWorkItems.value.first{
                        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)){
                            nextWork.connectionWork.perform()
                        }
                    }
                                
                case .BLEPrinter:
                    printNumber -= viewModel.BLEWorkItem.value?.image.count ?? 0
                    viewModel.BLEWorkItem.accept(nil)
            }
            printNumber = viewModel.POSWorkItems.value.count + viewModel.TSCWorkItems.value.flatMap{$0.image}.count

            viewModel.printNumber.accept(printNumber)
            
            lbl_already_printed_number.text = String(format: "%d/%d",viewModel.alreadyPrintedNumber.value,printNumber)
            
            if (viewModel.alreadyPrintedNumber.value == 0 && printNumber == 0) || (viewModel.alreadyPrintedNumber.value >= printNumber ){
               lbl_already_printed_number.text = "--/--"
            }
        }
        
        if viewModel.alreadyPrintedNumber.value >= printNumber{
            progressBar.setProgress(1, animated: true)
            progressBarTimer.invalidate()
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
                self.actionBack("")
                (self.completeHandler ?? {})()
            }
        }
    }
    
    func handlePOSError(workItem:WIFIWorkItem){
        
        if let id = workItem.objectId, let printer = workItem.printer,let image = workItem.image,let isLastItem = workItem.islastItem{
            var order = OrderDetail()
            order.id = workItem.orderId
            
            //remove first them add then add later
            LocalDataBaseUtils.shared.removePOSQueuedItemById(id: id)
            
            _ = LocalDataBaseUtils.shared.saveToLocalDataBase(
                order:order,
                printer: printer,
                img: image,
                printItems: [],
                isLastItem: isLastItem,
                printMode: .printBackgroundWithRetry
            )
            
        }
      
    }
    
    func handleTSCError(workItem:TSCWorkItem){
        
        if let id = workItem.objectId ,let printer = workItem.printer{
            //remove first them add then add later
            LocalDataBaseUtils.shared.removeTSCQueuedItemById(id: id)
            
            LocalDataBaseUtils.shared.saveTSCDataToDB(
                orderId: workItem.orderId,
                printer: printer,
                imgs: workItem.image,
                isLastItem: workItem.islastItem,
                printMode: .printBackgroundWithRetry
            )
            
        }
      
        
    }

}
