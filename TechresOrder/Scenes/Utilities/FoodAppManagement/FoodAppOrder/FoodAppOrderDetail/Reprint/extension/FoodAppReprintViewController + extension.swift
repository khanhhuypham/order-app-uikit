//
//  ReprintViewController + extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 16/9/25.
//

import UIKit
import ObjectMapper

extension FoodAppReprintViewController {
    
    func getReprintItemsOfFoodApp(channel_order_id:Int){
        appServiceProvider.rx.request(.getReprintItemsOfFoodApp(channel_order_id: channel_order_id))
           .filterSuccessfulStatusCodes()
           .mapJSON().asObservable()
           .showAPIErrorToast()
           .mapObject(type: APIResponse.self)
           .subscribe(onNext: {[weak self] (response) in
               guard let self = self else {return}
               
               if(response.code == RRHTTPStatusCode.ok.rawValue){
                   
                   if var order = Mapper<FoodAppOrder>().map(JSONObject: response.data){
                       
                       if let vc = Utils.getTopMostViewController(){
                           
                           var printer:[Printer] = []
                           
                           if self.btn_reprint_kitchen_ticket.isSelected{
                               printer += Constants.printers.filter{$0.type == .cashier_of_food_app && $0.is_have_printer == ACTIVE}
                           }
                           
                           if self.btn_reprint_stamp.isSelected{
                               printer += Constants.printers.filter{$0.type == .stamp_of_food_app && $0.is_have_printer == ACTIVE}
                           }
                           
                           
                           if printer.isEmpty{
                               
                               self.showWarningMessage(content: "Không tìm thấy máy in đang hoạt động cho chức năng in stamp của Food App")
                               self.dismiss(animated: true)
                           }
                           
                           
                           order.details.removeAll { item in
                               let isDifferentFood = item.food_name != self.item.food_name
                               let isDifferentQuantity = item.quantity != self.item.quantity
                               let isDifferentNote = item.note != self.item.note

                               // Convert additions to a Set for fast comparison
                               let additionNames = Set(self.item.food_options.map { $0.name })
                               
                               // Check if all food_options exist in additionNames
                               let isDifferentOptions = !item.food_options.allSatisfy { additionNames.contains($0.name) }
                               
                               // Remove if ANY difference exists
                               return isDifferentFood || isDifferentQuantity || isDifferentNote || isDifferentOptions
                           }

                           
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
