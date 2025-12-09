//
//  OrderDetailRebuildViewController + extension + print.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 03/09/2023.
//

import UIKit
import ObjectMapper
import RxSwift
import JonAlert
extension OrderDetailViewController {

    
     func getItemNeedToSendToKitchen(send:Bool = false,pay:Bool=false) {
         //CALL API COMPLETED ORDER
         viewModel.getSendToKitchen().subscribe(onNext: { [self] (response) in
             if(response.code == RRHTTPStatusCode.ok.rawValue){
                 if let items = Mapper<Food>().mapArray(JSONObject: response.data){
                     viewModel.foodsNeedToPrint.accept(items)
                     if send{
                         sendItemsToKitchen(itemIds: items.map{$0.id},pay: pay)
                     }
                 }
             }else{
                 JonAlert.showError(message: response.message ?? "", duration: 2.0)
             }
         }).disposed(by: rxbag)
     }
     
     func sendItemsToKitchen(itemIds:[Int],pay:Bool=false) {
         //CALL API COMPLETED ORDER
         viewModel.sendToKitchen(itemIds: itemIds).subscribe(onNext: { [self] (response) in
             if(response.code == RRHTTPStatusCode.ok.rawValue){
                 JonAlert.showSuccess(message: "Gửi thành công", duration: 2.0)
                 if pay{
                     getOrder(pay: pay)
                 }
             }else{
                 JonAlert.showError(message: response.message ?? "", duration: 2.0)
             }
         }).disposed(by: rxbag)
     }


}




