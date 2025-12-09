//
//  PrinterUtils + extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 05/07/2024.
//

import UIKit
import RxSwift


extension PrinterUtils {
    
    func performPrintBackGround(){
        printUnFinishedQueue()
        deleteFinishedQueue()
    }
    
    func clearWorkItemUnderBackGround(){
        self.workItems.removeAll()
        self.tscWorkItem = nil
    }
    
    func stopPrintBackGround(){
        printTimer?.invalidate()
        printTimer = nil
        
        deleteTimer?.invalidate()
        deleteTimer = nil
        
        for workItem in workItems{
            workItem.printWork.cancel()
            workItem.connectionWork.cancel()
            if workItem.connectionWork.isCancelled{
                POSPrinterUtility?.ids = []
                POSPrinterUtility?.wifiDisconnect()
            }
            workItems.removeAll(where: {$0.objectId == workItem.objectId})
        }
        
        if let tscWorkItem = self.tscWorkItem{
            tscWorkItem.connectionWork.cancel()
            tscWorkItem.printWork.cancel()
            if tscWorkItem.connectionWork.isCancelled{
                TSCPrinterUtility?.isPrintLive = false
                TSCPrinterUtility?.ids = []
                TSCPrinterUtility?.wifiDisconnect()
            }
        
            self.tscWorkItem = nil
        }
        
    }
    
    private func printUnFinishedQueue(){
        printTimer?.invalidate()
        printTimer = nil
        printTimer = Timer.scheduledTimer(withTimeInterval:0.5, repeats: true) { [weak self] _ in
            
            if self?.workItems.count == 0{
                if let queuedItem = LocalDataBaseUtils.shared.getFirstPOSQueuedItem(){
                    PrinterUtils.shared.print(wifiQueuedItem: WIFIQueuedItem(wifiQueuedItem: queuedItem))
                }
            }
            
            if self?.tscWorkItem == nil{
                if let tscQueuedItem = LocalDataBaseUtils.shared.getFirstTSCQueuedItem(){
                    PrinterUtils.shared.print(tscQueuedItem: TSCQueuedItem(tscQueuedItem: tscQueuedItem))
        }
            }
        }
        
    }
    
    private func deleteFinishedQueue(){
        deleteTimer?.invalidate()
        deleteTimer = nil
        deleteTimer = Timer.scheduledTimer(withTimeInterval:10, repeats: true) { [weak self] _ in
            LocalDataBaseUtils.shared.CheckFinishedQueuedItem()
        }
    }
 
    
}


