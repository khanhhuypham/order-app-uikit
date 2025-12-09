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
                        
                        images.append(renderDoubleStamp(printer:printer,order: order, printItems: printItems))
                    }
                
                default:
                    let totalStamp = printItems.map{ceil($0.quantity)}.reduce(0, +)
                    var currentOrder = 0

                    for (_,item) in printItems.enumerated(){
                        
                        for _ in 1...Int(ceil(item.quantity)) { //when item is allowed to sell by weight the quantity could be floating point number
                            currentOrder += 1
                
                            images.append(contentsOf:renderSingleStamp(printer:printer,item: item,order: String(format: "%d/%d", currentOrder,Int(totalStamp))))
                        }

                    }
                    break
    
            }
        }

        LocalDataBaseUtils.shared.saveTSCDataToDB(
            orderId: order.id,
            printer: printer,
            imgs: images,
            isLastItem: islastItem,
            printMode: printMode
        )
        
    }
    

    
    
    func printPOS(printer:Printer,order:OrderDetail,printItems:[Food]){
        
        if printItems.isEmpty{
            return
        }
        
        switch printer.is_print_each_food{

            case ACTIVE:

                for item in printItems {
            
                    for i in 1...printer.print_number{
    
                        _ = LocalDataBaseUtils.shared.saveToLocalDataBase(
                            order: viewModel.order.value,
                            printer: printer,
                            img: renderKitchenTicket(printer:printer,order: order, printItems: [item]),
                            printItems: [item],
                            isLastItem: i == printer.print_number ? true : false,
                            printMode: printMode
                        )
                    }
                }

            default:

                for i in 1...printer.print_number{
                    
                    _ = LocalDataBaseUtils.shared.saveToLocalDataBase(
                        order: viewModel.order.value,
                        printer: printer,
                        img: renderKitchenTicket(printer:printer,order: order, printItems: printItems),
                        printItems: printItems,
                        isLastItem: i == printer.print_number ? true : false,
                        printMode: printMode
                    )
                    
                }

        }
              
    }
    

 
}
