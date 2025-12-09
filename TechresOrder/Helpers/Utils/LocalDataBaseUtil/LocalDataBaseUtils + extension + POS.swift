//
//  LocalDataBaseUtils + extension + WIFI.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 23/08/2024.
//

import UIKit
import RealmSwift



//MARK: addition method
extension LocalDataBaseUtils{
    

    private func insertNewItem(order:OrderDetail,printer:Printer,img:UIImage,printItems:[Food],isLastItem:Bool,printMode:PRINT_MODE) -> ObjectId? {
        
        do {
            let realm = try realmInstance()

            if let printerObject = realm.object(ofType: PrinterObject.self, forPrimaryKey: printer.id),let data = img.pngData(){
                            
                let newItem = WIFIQueuedItemObject.init()
              
                newItem.orderId = order.id
                newItem.data = data
                var items:[ItemObject] = []
                for item in printItems{
                  items.append(ItemObject(item: item))
                }
                newItem.items.append(objectsIn: items)
                newItem.printer = printerObject
                newItem.isLastItem = isLastItem
                newItem.isFinished = false
                newItem.printMode = printMode
            
                try realm.write {
                    realm.add(newItem)
                }
                
                return newItem.id
                
            }else{
                return ObjectId()
            }

        } catch let error {
            dLog(error.localizedDescription)
            return ObjectId()
        }
    }
    
    func saveToLocalDataBase(order:OrderDetail,printer:Printer,img:UIImage,printItems:[Food],isLastItem:Bool,printMode:PRINT_MODE) -> ObjectId?{
       return insertNewItem(order: order, printer: printer, img: img, printItems: printItems, isLastItem:isLastItem,printMode:printMode)
    }

}




//MARK: Get method
extension LocalDataBaseUtils {


    func getFirstPOSQueuedItem() -> WIFIQueuedItemObject? {
        do {
            let realm = try realmInstance()
            
            let queuedItems = realm.objects(WIFIQueuedItemObject.self)
            
            
            //prioritize to query item that print foreground
            var filteredQueue = queuedItems.where {
                $0.printMode == .printBackgroundWithoutRetry && $0.isFinished == false
            }
            
            if filteredQueue.isEmpty {
                filteredQueue = queuedItems.where {
                    $0.printMode == .printBackgroundWithRetry && $0.isFinished == false
                }
                
            }
            
            return Array(filteredQueue).first
            
        } catch let error {
            dLog(error.localizedDescription)
            return nil
        }
    }
    
    
    
    func getForegroundPOSQueuedItem() -> [WIFIQueuedItemObject] {
        do {
            let realm = try realmInstance()
            
            let queuedItems = realm.objects(WIFIQueuedItemObject.self)
            
            
            //prioritize to query item that print foreground
            var filteredQueue = queuedItems.where {
                $0.printMode == .printForeground && $0.isFinished == false
            }
            

            return Array(filteredQueue)
            
        } catch let error {
            dLog(error.localizedDescription)
            return []
        }
    }
    

    func getQueuedPOSItemById(id:ObjectId) -> WIFIQueuedItemObject? {
        do {
            let realm = try realmInstance()

            return realm.object(ofType: WIFIQueuedItemObject.self, forPrimaryKey: id)

        } catch let error {
            dLog(error.localizedDescription)
            return nil
        }
    }

    
    
    func isOrderPerformingPrintProcess(orderId:Int) -> Bool {
        do {
            let realm = try realmInstance()
            
            let queue = realm.objects(WIFIQueuedItemObject.self).where{
                $0.orderId == orderId
            }
            
            let queuedItems = Array(queue)
            
            return queuedItems.count > 0 && queuedItems.filter{$0.isFinished == false}.count > 0 ? true : false
            
        } catch let error {
            dLog(error.localizedDescription)
            return false
        }
    }
    
    
}





//MARK: update method
extension LocalDataBaseUtils{
    
    func UpdateRetryNumber(id:ObjectId) {
        do {
            let realm = try realmInstance()
            guard let item = realm.object(ofType: WIFIQueuedItemObject.self, forPrimaryKey: id) else{
                return
            }
            

            try realm.write {
                // Delete the related collection
                if !item.isFinished {
                    item.retryNumber += 1
                    if item.retryNumber >= 10{
                        item.isFinished = true

                    }
                }
            }
        
        } catch let error {
            dLog(error.localizedDescription)
            return
        }
    }
    
    
    func UpdateWifiQueuedItemToFinish(id:ObjectId?) {
        do {
            let realm = try realmInstance()
            
            guard let item = realm.object(ofType: WIFIQueuedItemObject.self, forPrimaryKey: id) else{
                return
            }
    
            try realm.write {
                // Delete the related collection
                item.isFinished = true
              
            }
        
        } catch let error {
            dLog(error.localizedDescription)
            return
        }
    }
    
}




//MARK: remove method
extension LocalDataBaseUtils{
    
    func removeWifiQueuedItemByOrderId(orderId:Int){
        do {
            let realm = try realmInstance()
        
            try realm.write {
                
                let oldItems = realm.objects(WIFIQueuedItemObject.self).where{
                    $0.orderId == orderId
                }
                
                for oldItem in oldItems{
                    oldItem.isFinished = true
                }
    
            }
                

        } catch let error {
            dLog(error.localizedDescription)
            
        }
        
        
    
    }
    
    

    func removePOSQueuedItemById(id:ObjectId) {
        do {
            let realm = try realmInstance()
            
            guard let item = realm.object(ofType: WIFIQueuedItemObject.self, forPrimaryKey: id) else{
                return
            }
    
            try realm.write {
                // Delete the related collection
                item.isFinished = true
            }
        
        } catch let error {
            dLog(error.localizedDescription)
        }
    }
    
    

   
    
}
