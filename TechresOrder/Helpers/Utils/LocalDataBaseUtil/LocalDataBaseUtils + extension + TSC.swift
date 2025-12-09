//
//  LocalDataBaseUtils + extension + Food App.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 23/08/2024.
//

import UIKit
import RealmSwift
extension LocalDataBaseUtils {
    
    
    func saveTSCDataToDB(orderId:Int,printer:Printer,imgs:[UIImage],isLastItem:Bool,printMode:PRINT_MODE){

        do {
            let realm = try realmInstance()
            
            if let printerObject = realm.object(ofType: PrinterObject.self, forPrimaryKey: printer.id){
                
                let newItem = TSCQueuedItemObject.init()
                newItem.orderId = orderId
                
                for image in imgs{
                    newItem.data.append(image.pngData() ?? Data())
                }
            
                newItem.printer = printerObject
                newItem.isLastItem = isLastItem
                newItem.isFinished = false
                newItem.printMode = printMode
            
                try realm.write {
                    realm.add(newItem)
                }
            
    
            }else{
                return
            }

        } catch let error {
            dLog(error.localizedDescription)
            return
        }
    }
    
  
    
    func UpdateRetryNumberOfTSCQueuedItem(id:ObjectId) {
        do {
            let realm = try realmInstance()
            guard let item = realm.object(ofType: TSCQueuedItemObject.self, forPrimaryKey: id) else{
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
    
    
    
    func UpdateTSCQueuedItemToFinish(id:ObjectId?) {
        do {
            let realm = try realmInstance()
            
            guard let item = realm.object(ofType: TSCQueuedItemObject.self, forPrimaryKey: id) else{
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
//MARK: Get method
extension LocalDataBaseUtils {
    
    
    func getTSCQueuedItemById(id:ObjectId) -> TSCQueuedItemObject? {
        do {
            let realm = try realmInstance()
                     
            return realm.object(ofType: TSCQueuedItemObject.self, forPrimaryKey: id)
             
        } catch let error {
            dLog(error.localizedDescription)
            return nil
        }
    }
    
    
    func getForegroundTSCQueuedItem() -> [TSCQueuedItemObject] {
        do {
            let realm = try realmInstance()
            
            let queuedItems = realm.objects(TSCQueuedItemObject.self)
            
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
    

    func getFirstTSCQueuedItem() -> TSCQueuedItemObject? {
        do {
            let realm = try realmInstance()
            
            let queuedItems = realm.objects(TSCQueuedItemObject.self)
            

            
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
    
    
}




//MARK: remove method
extension LocalDataBaseUtils{
    
    func removeTSCQueuedItemByOrderId(orderId:Int){
        do {
            let realm = try realmInstance()
        
            try realm.write {
                
                let oldItems = realm.objects(TSCQueuedItemObject.self).where{
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
    
    

    func removeTSCQueuedItemById(id:ObjectId) {
        do {
            let realm = try realmInstance()

            guard let item = realm.object(ofType: TSCQueuedItemObject.self, forPrimaryKey: id) else{
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
