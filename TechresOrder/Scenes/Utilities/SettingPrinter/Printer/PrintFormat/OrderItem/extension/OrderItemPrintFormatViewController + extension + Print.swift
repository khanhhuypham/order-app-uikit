//
//  OrderItemPrintFormatViewController + extension + BLEPrint.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 13/07/2024.
//

import UIKit
import RealmSwift

extension OrderItemPrintFormatViewController {
    
   
    
    func printTSC(printer:Printer,order:OrderDetail,printItems:[Food],islastItem:Bool = true){
        
        if printItems.isEmpty{
            return
        }
        
        var images:[UIImage] = []
        
        for _ in 1...printer.print_number{
            
            switch printer.printer_paper_size{
                
                case 30:
                    for j in stride(from: 0, to: printItems.count, by: 2) {
                        /*
                                if we reach to the last item of array and the last item is odd number. we will get Array(itemsOfStampPrint[1...1])
                            */
                        _ = j == printItems.count - 1 && printItems.count%2 == 1
                        ? Array(printItems[j...j])
                        : Array(printItems[j...j+1])
                        
                        images.append(renderSreen(printer:printer,order: order, printItems: printItems))
                    }
                
                default:
                
                    for (_,item) in printItems.enumerated(){
                        images.append(renderSreen(printer:printer,order: order, printItems: [item]))
                    }
                
                    break
                
            }

        }
        

        let id = UUID()
        
        let dictionaryItem:[String : Any] = ["id":id.uuidString]
        
        let connectionWork = DispatchWorkItem(block: { [self] in
            TSCPrinterUtility?.isPrintLive = true
            TSCPrinterUtility?.wifiConnect(printer, id:dictionaryItem)
        })

        let printWork = DispatchWorkItem(block: { [self] in
            PrinterUtils.shared.printTSCData(printer:printer,id:id.uuidString,images:images)
        })
        
        let TSCWorkItem = TSCWorkItem(printer:printer,connectionWork: connectionWork,printWork: printWork,images: images)
             
        viewModel.TSCWorkItem.accept(TSCWorkItem)
    }
    
    

    func printBLE(printer:Printer,order:OrderDetail,printItems:[Food]){
        
        
        if printItems.isEmpty{
            return
        }
        
        let id = UUID()
        
        var images:[UIImage] = []
        
        switch printer.is_print_each_food{
            
            case ACTIVE:
            
                for printItem in printItems {
                    for _ in 1...printer.print_number{
                        let image = renderSreen(printer:printer,order: order, printItems:[printItem])
                        images.append(image)
                    }
                }
            
            default:
            
                for _ in 1...printer.print_number{
                    images.append(renderSreen(printer:printer,order: order, printItems: printItems))
                }
            
        }
        
        
        let connectionWork = DispatchWorkItem(block: { [self] in
           
            if let BLEPrinter = Constants.BLEPrinter.first(where: {$0.name == printer.printer_name}){
                BLEPrinterUtility?.bleManager.connectDevice(BLEPrinter)
            }else{
                let error = NSError(domain: "Phạm khánh Huy gà", code: 0, userInfo: [NSLocalizedDescriptionKey : "Không tìm Thấy thiết bị Bluetooth để kết nối"])
                let dictionary = [
                    "error":error,
                    PRINTER_NOTIFI.PRINTER_METHOD_KEY: PRINTER_METHOD.BLEPrinter.rawValue
                ]
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: PRINTER_NOTIFI.CONNECT_FAIL),object: dictionary)
            }
        })

        let printWork = DispatchWorkItem(block: { [self] in
            PrinterUtils.shared.printBLEData(printer:printer,id:id.uuidString,images:images)
        })
        
        
        let BLEWorkItem = BLEWorkItem(connectionWork: connectionWork,printWork: printWork,images: images)

        viewModel.BLEWorkItem.accept(BLEWorkItem)
    }

    
    
    func printWIFI(printer:Printer,order:OrderDetail,printItems:[Food]){
        
        if printItems.isEmpty{
            return
        }
        
    
        switch printer.is_print_each_food{

            case ACTIVE:

                for item in printItem {
                    for i in 1...printer.print_number{
                        setupWifiWorkItem(printer:printer,order:order,printItems:[item],islastItem: i == printer.print_number ? true : false)
                    }
                }

            default:

                for i in 1...printer.print_number{
                    setupWifiWorkItem(printer:printer,order:order,printItems:printItem,islastItem: i == printer.print_number ? true : false)
                }
            
        }
              
    }
    
    private func setupWifiWorkItem(printer:Printer,order:OrderDetail,printItems:[Food],islastItem:Bool = true){
        let image = renderSreen(printer:printer,order: order, printItems: printItems)
        var wifiWorkItems = viewModel.WIFIWorkItem.value
        
        let id = UUID()
        
        let connectionWork = DispatchWorkItem(block: { [self] in
            
            let dictionaryItem:[String : Any] = ["id":id.uuidString,"isLastItem":islastItem]
    
            POSPrinterUtility?.isPrintLive = true
            POSPrinterUtility?.connectType = .WIFI
            POSPrinterUtility?.wifiConnect(printer, queuedItem: dictionaryItem)
          
        })
        
        let printWork = DispatchWorkItem(block: { [self] in
            PrinterUtils.shared.printWifiData(id:id.uuidString, printer:printer, img:image, isLastItem:islastItem)
        })
        
        
        let wifiWorkItem = WIFIWorkItem(id: id,image: image,printer: printer,printItems: printItems,connectionWork: connectionWork, printWork: printWork)
        
        wifiWorkItems.append(wifiWorkItem)
        
        viewModel.WIFIWorkItem.accept(wifiWorkItems)
    
    }
    
 
}
