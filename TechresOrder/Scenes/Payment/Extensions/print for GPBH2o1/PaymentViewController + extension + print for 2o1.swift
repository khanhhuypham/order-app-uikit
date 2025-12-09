//
//  PaymentRebuildViewController + Extension + print.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 24/10/2023.
//

import UIKit
import JonAlert
import ObjectMapper


extension PaymentRebuildViewController {
    
    
    func getOrderNeedToPrintFor2o1(){
        viewModel.requestPrintChefBar(printType:.new_item).subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                self.a(print_type: 2)
            }else{
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại.", duration: 3.0)
            }
        }).disposed(by: rxbag)
    }
    

    func a(itemsMustPrint:[Food] = [],print_type:Int){
        viewModel.getOrderNeedToPrintForGPBH_2o1(print_type:print_type).subscribe(onNext: {[self] (response) in
            
            if(response.code == RRHTTPStatusCode.ok.rawValue){
            
                if print_type == 2{
                    
                    let items_need_to_print = mapKitchenTicketPrintData(from: response)
                   
                    if (items_need_to_print.count > 0) {
                        self.presentModalDialogConfirmViewController(
                            content: "Hiện tại còn món chưa gửi Bếp/Bar bạn có muốn gửi Bếp/Bar trước khi thanh toán không?",
                            confirmClosure: {
                                if(items_need_to_print.count > 0){
                                    permissionUtils.GPBH_2_o_2
                                    ? self.requestPrintChefBar(printType: .new_item)
                                    : self.updateReadyPrinted(itemsMustPrint: items_need_to_print, order_detail_ids: items_need_to_print.map{$0.id})
                                }
                            }
                        )
                    }else{
                        self.executePaymentProcedure(step: 2)
                    }
                }
                
                if print_type == 1 {
                    var finalPrintItems = itemsMustPrint
                    let printStampItems = mapStampPrintData(from: response)
                    for (i,_) in finalPrintItems.enumerated() {
                        if let item = printStampItems.first(where: {$0.id == itemsMustPrint[i].id}){
                            finalPrintItems[i].TSCPrinter_id = item.restaurant_kitchen_place_id
                        }
                    }
                    self.print(items: finalPrintItems,printType: .new_item)
                }
            }
            
        }).disposed(by: rxbag)
    }
    
    //MARK: API gửi in bếp. API này chỉ sử dụng cho GPBH2o2, vì GPBH2o2 print trực tiếp qua máy thu ngân nên ta sẽ gọi API này để gửi tín hiệu SERVER, sau đó server sẽ gửi tín hiệu qua cho WINDOWN để thực hiện quá trình print
    private func requestPrintChefBar(printType:Constants.printType){
        viewModel.requestPrintChefBar(printType:printType).subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                
                /*
                      sau khi Gửi bếp bar thành công thì ta thực hiện bước thanh toán tiếp theo (step2: yêu cầu nhập số lượng nguời)
                    */
                JonAlert.showSuccess(message: "Gửi bếp bar thành công", duration: 1.0)
                self.executePaymentProcedure(step: 2)
            }
            else{
                JonAlert.showError(message: response.message ?? "", duration: 2.0)
            }
        }).disposed(by: rxbag)
        
    }
    
    
    
   private func updateReadyPrinted(itemsMustPrint:[Food] = [],order_detail_ids:[Int]){
        viewModel.updateReadyPrinted(order_detail_ids: order_detail_ids).subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                
                /*
                      sau khi cập nhật xong các món cần in thì ta thực hiện bước thanh toán tiếp theo (step2: nhập số lượng người)
                */
                
                if !itemsMustPrint.isEmpty{
                    self.a(itemsMustPrint:itemsMustPrint, print_type: 1)
                }
                
                self.getOrder()
                self.executePaymentProcedure(step:2)
                
            }else{
                JonAlert.showError(message:response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại.", duration: 2.0)
            }
        }).disposed(by: rxbag)
    }
    
    
    //MARK: print_type = 0 => món mới; print_type = 1 => món cập nhật tăng giảm; print_type = 2 => món huỷ;
    private func print(items:[Food], printType:Constants.printType) {
        

        let printers = Constants.printers.filter{($0.type == .bar || $0.type == .chef || $0.type == .stamp) && $0.is_have_printer == ACTIVE}

        //check whether tsc printer has the same name as other wifi printer, in order to avoid error
        let valid = PrinterUtils.shared.checkValidPrinters(presenter: self)
        
        if !valid{
            return
        }
        
        if let vc = Utils.getTopMostViewController(),items.count > 0 && printers.filter{$0.is_have_printer == ACTIVE}.count > 0{
            
            PrinterUtils.shared.PrintItems(
                presenter: vc,
                order:viewModel.order.value,
                printItem:items,
                printers:printers,
                printMode:.printForeground,
                completetHandler: {
                    self.getOrder()
                }
            )
        }
        
    }
    

    
    private func mapStampPrintData(from response: APIResponse) -> [Food] {
        
        guard let dataArray = response.data as? [[String: Any]] else {
            dLog("response.data is not an array of dictionaries.")
            return []
        }
        
        guard let result = dataArray.first(where: {
            guard let id = $0["id"] as? Int else { return false }
            return id == self.viewModel.order.value.id
        }) else {
            dLog("No matching item found.")
            return []
        }
        
        guard let objectDataString = result["object_data"] as? String,
              let jsonData = objectDataString.data(using: .utf8) else {
            dLog("object_data is not a valid JSON string.")
            return []
        }
        
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] {
                let printItems = Mapper<Food>().mapArray(JSONArray: jsonArray)
                return printItems
            } else {
                dLog("object_data string is not a valid JSON array.")
                return []
            }
        } catch {
            dLog("Failed to parse object_data: \(error)")
            return []
        }
    }
    
    private func mapKitchenTicketPrintData(from response: APIResponse) -> [Food] {
        
        guard let dataArray = response.data as? [[String: Any]] else {
            dLog("response.data is not an array of dictionaries.")
            return []
        }
        
        guard let result = dataArray.first(where: {
            guard let id = $0["id"] as? Int else { return false }
            return id == self.viewModel.order.value.id
        }) else {
            dLog("No matching item found.")
            return []
        }
        

        
        if let result = Mapper<Food>().mapArray(JSONObject: result["order_details"] as? [[String: Any]]){
            return result
        }
        
        return []
        
    }

    
}




