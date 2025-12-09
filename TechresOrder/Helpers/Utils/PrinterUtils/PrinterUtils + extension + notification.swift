//
//  PrinterUtils + extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 05/07/2024.
//

import UIKit
import RxSwift
import RealmSwift

extension PrinterUtils {
    
    @objc func printSuccessFully(_ notification: Notification){
  
        let object = notification.object as! [String:Any]
        
        if !object.isEmpty{

            guard
                let printMethod = PRINTER_METHOD.init(rawValue: object[PRINTER_NOTIFI.PRINTER_METHOD_KEY] as? Int ?? 0),
                let _ = object["isLastItem"]as? Bool
            else{
                dLog("phạm khánh huy")
                return
            }

            do {
                
                let id = try ObjectId.init(string: object["id"] as? String ?? "")
                
                switch printMethod {
                    
                    case .POSPrinter:
                        canncelWorkItem(id: id, isErrorOccur: false)
                    
                    case .TSCPrinter:
                        canncelTSCWorkItem(id: id, isErrorOccur: false)
                    
                    case .BLEPrinter:
                        break
                }
                
            }catch{}
            
        }
    }
    
    
    @objc func printFail(_ notification: Notification){
        canncelAllWorkItem()
    }
    
    
    @objc func connectPrinterFail(_ notification: Notification){
        
        let object = notification.object as! [String:Any]

        if let id = try? ObjectId.init(string: object["id"] as? String ?? ""),
           let error = object["error"] as? NSError,
           let printer = object["printer"]as? Printer,
           let rawValue = object[PRINTER_NOTIFI.PRINT_MODE] as? Int,
           let printMode = PRINT_MODE(rawValue: rawValue),
           let printerMethod = PRINTER_METHOD.init(rawValue: object[PRINTER_NOTIFI.PRINTER_METHOD_KEY] as? Int ?? 0)
        {
    
            switch printerMethod {
                case .POSPrinter:
                
                    if printMode == .printBackgroundWithoutRetry {
                        handleConnectPOSPrinterFail(id:id)
                    }else if printMode == .printBackgroundWithRetry{
                        canncelWorkItem(id: id, isErrorOccur: true)
                    }
                
                case .TSCPrinter:
                    if printMode == .printBackgroundWithoutRetry  {
                        handleConnectTSCPrinterFail(id:id)
                    }else if printMode == .printBackgroundWithRetry{
                        canncelTSCWorkItem(id: id, isErrorOccur: true)
                    }
                    
                case .BLEPrinter:
                    break
            }
        
            
        }
        
    }
     
    
    @objc func connectPrinterSuccessfully(_ notification: Notification){
        
        backGroundQueue.async(execute: {
            
            let object = notification.object as! [String:Any]
            
            if
                let printMethod = PRINTER_METHOD.init(rawValue: object[PRINTER_NOTIFI.PRINTER_METHOD_KEY] as? Int ?? 0),
                let printer = object["printer"]as? Printer
            {

                switch printMethod {

                    case .POSPrinter:
                    
                         do{
                             let queueId = try ObjectId.init(string: object["id"] as? String ?? "")
                             
                             if let position = self.workItems.firstIndex(where: {$0.objectId == queueId}){
                                 self.workItems[position].printWork.perform()
                             }
                             
                         }catch{
                             
                         }


                    case .TSCPrinter:
                        if let tscWorkItem = self.tscWorkItem{
                            tscWorkItem.printWork.perform()
                        }


                    case .BLEPrinter:
                        break
                }
                
//                self.unconnectedPrinters.removeAll(where: {$0.id == printer.id})
                
            }
           
        })
    }
    
    @objc func getUnconnectedPrinters(_ notification: Notification){
        let printers = notification.object as? [Printer] ?? []
        
        if let topVc = self.getTopUIViewcontroller(){

            let vc = PrinterConnectionWarningViewController()
            vc.printers = printers
            vc.view.backgroundColor = ColorUtils.blackTransparent()
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            topVc.present(vc, animated: false, completion: nil)
        }

    }
        
    
    private func getTopUIViewcontroller() -> UIViewController?{

       let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

       if var topController = keyWindow?.rootViewController {

           while let presentedViewController = topController.presentedViewController {
               topController = presentedViewController
           }

           
           if !topController.isKind(of: PrinterConnectionWarningViewController.self) && !topController.isKind(of: DetailedPrinterViewController.self){
               return topController
           }

           // topController should now be your topmost view controller

       }

       return nil
   }
    

    
    private func handleConnectPOSPrinterFail(id:ObjectId) {
        guard let posItem = LocalDataBaseUtils.shared.getQueuedPOSItemById(id: id),let printer = posItem.printer,let image = UIImage(data: posItem.data) else {
            return
        }
     
        _ = LocalDataBaseUtils.shared.saveToLocalDataBase(
            order: OrderDetail(),
            printer: Printer(printerObject: printer),
            img: image,
            printItems: [],
            isLastItem:  posItem.isLastItem,
            printMode: .printBackgroundWithRetry
        )
       
        LocalDataBaseUtils.shared.UpdateWifiQueuedItemToFinish(id: id)
   
        if let p = workItems.firstIndex(where: {$0.objectId == id}){
            workItems[p].printWork.cancel()
            workItems[p].connectionWork.cancel()
            
            if workItems[p].connectionWork.isCancelled{
                POSPrinterUtility?.wifiDisconnect()
            }
        
            workItems.remove(at: p)
        }
        
   }
    
    private func handleConnectTSCPrinterFail(id:ObjectId) {
        guard let tscItem = LocalDataBaseUtils.shared.getTSCQueuedItemById(id: id),let printer = tscItem.printer else {
            return
        }
     
        
        var images:[UIImage] = []
        
        for data in tscItem.data{
            if let image = UIImage(data: data){
                images.append(image)
            }
        }
        

        LocalDataBaseUtils.shared.saveTSCDataToDB(orderId:tscItem.orderId,printer:Printer(printerObject: printer),imgs:images,isLastItem: tscItem.isLastItem,printMode:.printBackgroundWithRetry)
        
        LocalDataBaseUtils.shared.UpdateTSCQueuedItemToFinish(id: id)
   
        if let workItem = self.tscWorkItem{
            workItem.connectionWork.cancel()
            workItem.printWork.cancel()
            if workItem.connectionWork.isCancelled{
                TSCPrinterUtility?.wifiDisconnect()
            }
            tscWorkItem = nil
        }
        
   }
    
 
    
}


