//
//  FoodAppPrintFormatViewController + extension + Print.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 21/08/2024.
//



import UIKit
//import RealmSwift

extension FoodAppPrintFormatViewController {
    

    func printStamp(printer:Printer,order:FoodAppOrder){
        
        if order.is_cancel_order == ACTIVE{
            return
        }
        
        let printItems = order.details
        var images:[UIImage] = []

       
        for _ in 1...printer.print_number{
            
            switch printer.printer_paper_size{
                
                case 30:
                    for j in stride(from: 0, to: printItems.count, by: 2) {
                        /*
                            if we reach to the last item of array and the last item is odd number. we will get Array(itemsOfStampPrint[1...1])
                        */
                        viewModel.currentOrder.accept(order)
                        
                        let array = j == printItems.count - 1 && printItems.count%2 == 1
                        ? Array(printItems[j...j])
                        : Array(printItems[j...j+1])
                        
                        images.append(renderDoubleStamp(printer:printer,printItems: array,infor: (printItems.count,j)))
                    }
                
                default:
                    
                    let totalStamp = Int(printItems.map{ceil($0.quantity)}.reduce(0, +))
                    var currentOrder = 0

                
                    for (_,item) in printItems.enumerated(){
               
                        for _ in 1...Int(ceil(item.quantity)) { //when item is allowed to sell by weight the quantity could be floating point number
                            currentOrder += 1
                           
                            images.append(contentsOf: renderSingleStamp(printer:printer,order:order,item: item,stampOrder: String(format: "%d/%d", currentOrder,totalStamp)))
                        }

                    }

            }

        }
        
        LocalDataBaseUtils.shared.saveTSCDataToDB(
            orderId:order.id,
            printer: printer,
            imgs:images,
            isLastItem: true,
            printMode: printMode
        )
    }
    

    func printKitchenTicket(printer:Printer,order:FoodAppOrder){
        
        if order.details.isEmpty{
            return
            
        }else if printer.connection_type != .wifi{
            return
            
        }
        

        switch printer.is_print_each_food{

            case ACTIVE:

                for item in order.details {
                    
                    for i in 1...printer.print_number{
                        
                        var cloneOrder = order
                        cloneOrder.details.removeAll(where: {$0.id != item.id})

                        setupWorkItemForKitchenTicket(printer:printer,order:cloneOrder,islastItem: i == printer.print_number ? true : false)
                        
                    }
                }

            default:
                for i in 1...printer.print_number{
                    setupWorkItemForKitchenTicket(printer:printer,order:order,islastItem: i == printer.print_number ? true : false)
                }
            
        }
         
    }
    
    
    
    func printInvoice(printer:Printer,order:FoodAppOrder,islastItem:Bool = true){
        
        _ = LocalDataBaseUtils.shared.saveToLocalDataBase(
            order: OrderDetail(),
            printer: printer,
            img: renderInvoice(printer:printer,order: order),
            printItems: [],
            isLastItem:islastItem,
            printMode: printMode
        )

    }
    
    
    func setupWorkItemForKitchenTicket(printer:Printer,order:FoodAppOrder,islastItem:Bool = true){
        
        _ = LocalDataBaseUtils.shared.saveToLocalDataBase(
            order: OrderDetail(),
            printer: printer,
            img: renderKitchenTicket(order: order),
            printItems: [],
            isLastItem:islastItem,
            printMode: printMode
        )

    }

    
}
