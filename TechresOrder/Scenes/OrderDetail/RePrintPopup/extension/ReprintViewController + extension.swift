//
//  ReprintViewController + extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 16/9/25.
//

import UIKit
import ObjectMapper
extension ReprintViewController {
    
    func getReprintItems(orderId:Int){
        appServiceProvider.rx.request(.getReprintItems(order_id: orderId))
           .filterSuccessfulStatusCodes()
           .mapJSON().asObservable()
           .showAPIErrorToast()
           .mapObject(type: APIResponse.self)
           .subscribe(onNext: {(response) in
               
               if(response.code == RRHTTPStatusCode.ok.rawValue){
                   var result:Food = Food()
                   var printers:[Printer] = []
                   
                   if let kitchenTicketItems = Mapper<Food>().mapArray(JSONObject: response.data?["kitchen"]){
                       
                       if let item = kitchenTicketItems.first(where: {$0.id == self.item.id}){
                           result = item
                           
                           if let printer = Constants.printers.first(where: {$0.id == result.restaurant_kitchen_place_id}),self.btn_reprint_kitchen_ticket.isSelected{
                               printers.append(printer)
                           }
                         
                       }
                   }
                   
                   
                   if let stampItems = Mapper<Food>().mapArray(JSONObject: response.data?["stamp"]), self.btn_reprint_stamp.isSelected{
                       if let item = stampItems.first(where: {$0.id == self.item.id}){
                           
                           result.TSCPrinter_id = item.restaurant_kitchen_place_id
                     
                           if let printer = Constants.printers.first(where: {$0.id == result.TSCPrinter_id}){
                               printers.append(printer)
                           }
                           
                       }
                   }
                   
      
                   PrinterUtils.shared.PrintItems(
                       presenter: self,
                       order:self.order,
                       printItem:[result],
                       printers:printers,
                       printMode:.printForeground,
                       completetHandler: {
                           self.dismiss(animated: true)
                       }
                   )
                   
                 
                   
               }else{
                   self.showErrorMessage(content: response.message ?? "")
               }
               
           }).disposed(by: rxbag)
    }
    
    
    func getReprintItemsOfFoodApp(channel_order_id:Int){
        appServiceProvider.rx.request(.getReprintItemsOfFoodApp(channel_order_id: channel_order_id))
           .filterSuccessfulStatusCodes()
           .mapJSON().asObservable()
           .showAPIErrorToast()
           .mapObject(type: APIResponse.self)
           .subscribe(onNext: {(response) in
            
               if(response.code == RRHTTPStatusCode.ok.rawValue){
                   
                   if var order = Mapper<FoodAppOrder>().map(JSONObject: response.data){
                       
                       if let vc = Utils.getTopMostViewController(){
                           
                           var printer:[Printer] = []
                           
                           if  self.btn_reprint_kitchen_ticket.isSelected{
                               printer += Constants.printers.filter{$0.type == .cashier_of_food_app}
                           }
                           
                           if  self.btn_reprint_stamp.isSelected{
                               printer += Constants.printers.filter{$0.type == .stamp_of_food_app}
                           }
                           
                          
                           order.details.removeAll { item in
                               let isDifferentFood = item.food_name != self.item.name
                               let isDifferentQuantity = item.quantity != self.item.quantity
                               let isDifferentNote = item.note != self.item.note

                               // Convert additions to a Set for fast comparison
                               let additionNames = Set(self.item.order_detail_additions.map { $0.name })
                               
                               // Check if all food_options exist in additionNames
                               let isDifferentOptions = !item.food_options.allSatisfy { additionNames.contains($0.name) }
                               
                               // Remove if ANY difference exists
                               return isDifferentFood || isDifferentQuantity || isDifferentNote || isDifferentOptions
                           }

                           dLog(order.toJSON())
                           PrinterUtils.shared.PrintFoodAppItems(
                                presenter:vc,
                                onlyPrintKitchenTicket:true,
                                printers:printer,
                                orders: [order],
                                printMode: .printForeground,
                                completetHandler: {
                                    self.dismiss(animated: true)
                                }
                           )
                       }
                   }
               }else{
                   self.showErrorMessage(content: response.message ?? "")
               }
               
           }).disposed(by: rxbag)
    }
    

}
