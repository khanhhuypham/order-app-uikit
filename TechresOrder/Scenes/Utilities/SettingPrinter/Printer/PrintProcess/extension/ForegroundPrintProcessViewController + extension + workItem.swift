//
//  ForegroundPrintProcessViewController + extension + workItem.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 11/9/25.
//

import UIKit

extension ForegroundPrintProcessViewController {
        
    func setupTSCWorkItem(item:TSCQueuedItemObject){
        guard let printerObject = item.printer else {
            return
        }
        var TSCWorkItems = viewModel.TSCWorkItems.value
        let dictionaryItem:[String : Any] = ["id":item.id.stringValue]
        let printer = Printer(printerObject:printerObject)
        var images:[UIImage] = []
        
        for data in item.data{
            if let image = UIImage(data: data){
                images.append(image)
            }
        }
        
        let connectionWork = DispatchWorkItem(block: { [self] in
            TSCPrinterUtility?.connectType = .WIFI
            TSCPrinterUtility?.printMode = .FOREGROUND
            TSCPrinterUtility?.wifiConnect(printer, id:dictionaryItem)
        })

        let printWork = DispatchWorkItem(block: {
            PrinterUtils.shared.printTSCData(printer:printer,id:item.id.stringValue,images:images)
        })
        
        let TSCWorkItem = TSCWorkItem(
            objectId:item.id,
            orderId: item.orderId,
            printer:printer,
            image: images,
            connectionWork: connectionWork,
            printWork: printWork,
        )
        
        TSCWorkItems.append(TSCWorkItem)
        viewModel.TSCWorkItems.accept(TSCWorkItems)
    }

    func setupPOSWorkItem(item:WIFIQueuedItemObject){
        guard let printerObject = item.printer,let image = UIImage(data: item.data) else {
            return
        }
        var posWorkItems = viewModel.POSWorkItems.value
        let printer = Printer(printerObject:printerObject)
        
        let connectionWork = DispatchWorkItem(block: { [self] in
            let dictionaryItem:[String : Any] = ["id":item.id.stringValue,"isLastItem":item.isLastItem]
            POSPrinterUtility?.connectType = .WIFI
            POSPrinterUtility?.printMode = .FOREGROUND
            POSPrinterUtility?.wifiConnect(printer, queuedItem: dictionaryItem)
        })
 
        let printWork = DispatchWorkItem(block: {
            PrinterUtils.shared.printWifiData(id:item.id.stringValue, printer:printer, img:image, isLastItem:item.isLastItem)
        })
        
        let posWorkItem = WIFIWorkItem(
            objectId:item.id,
            orderId: item.orderId,
            image: image,
            printer:printer,
            printItems:[],
            islastItem: item.isLastItem,
            connectionWork: connectionWork,
            printWork: printWork
        )
        
        posWorkItems.append(posWorkItem)
        
        viewModel.POSWorkItems.accept(posWorkItems)
    }
    
}
