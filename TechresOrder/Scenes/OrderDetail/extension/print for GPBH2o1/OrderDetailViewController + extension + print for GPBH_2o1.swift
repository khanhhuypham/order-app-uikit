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
    
    // ================================== only for 2o1 =====================================================
    
    func getOrderNeedToPrintFor2o1(print:Bool = false,pay:Bool = false){
        viewModel.requestPrintChefBar(printType:.new_item).subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                
              
                if print{
                    self.getFoodsNeedPrintFor2o1(print: print,pay:pay,print_type:2)
                }else{
                    self.getFoodsNeedPrintFor2o1(print_type:2)
                }
                
                
            }else{
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại.", duration: 3.0)
            }
        }).disposed(by: rxbag)
    }
    
    
    private func getFoodsNeedPrintFor2o1(itemsMustPrint:[Food] = [],print:Bool? = nil,pay:Bool? = nil,print_type:Int){
        viewModel.getOrderNeedToPrintForGPBH_2o1(print_type:print_type).subscribe(onNext: {[self] (response) in
            
            if(response.code == RRHTTPStatusCode.ok.rawValue){
        
                if print_type == 2{
                    let printItems = mapKitchenTicketPrintData(from: response)
                    let pendingItem = printItems.filter{$0.status == PENDING}
                    let cancelItem = printItems.filter{$0.status == CANCEL_FOOD}
                    let returnedItem = printItems.filter{$0.category_type == .drink && $0.return_quantity_for_drink > 0}
                    
                    if cancelItem.count > 0{
                        self.updateReadyPrinted(order_detail_ids: cancelItem.map{$0.id})
                        self.printItems(items: cancelItem,printType: .cancel_item)
                    }
                    
                    if returnedItem.count > 0{
                        self.updateReadyPrinted(order_detail_ids: returnedItem.map{$0.id})
                        self.printItems(items: returnedItem,printType: .return_item)
                    }
                    
                    viewModel.foodsNeedToPrint.accept(pendingItem)
                                        
                    if let allowPrint = print, allowPrint {
                        self.updateReadyPrinted(itemsMustPrint: pendingItem,pay: pay,order_detail_ids: pendingItem.map{$0.id})
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
                    self.printItems(items: finalPrintItems,printType: .new_item)
                }
            }
        }).disposed(by: rxbag)
    }
    
    
    
    private func updateReadyPrinted(itemsMustPrint:[Food] = [],pay:Bool? = nil ,order_detail_ids:[Int]){
        viewModel.updateReadyPrinted(order_detail_ids:order_detail_ids).subscribe(onNext: { (response) in
            
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                
                if !itemsMustPrint.isEmpty{
                    self.getFoodsNeedPrintFor2o1(itemsMustPrint:itemsMustPrint, print_type: 1)
                }
                
                if let allowPay = pay, allowPay{
                    self.getOrder(pay:allowPay)
                }
                
                                
            }else{
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại.", duration: 3.0)
            }
        }).disposed(by: rxbag)
        
    }
    

    // ============== Handler printer ==============
    
    //MARK: print_type = 0 => món mới; print_type = 1 => món cập nhật tăng giảm; print_type = 2 => món huỷ;
    private func printItems(items:[Food], printType:Constants.printType) {
        
        let printers = Constants.printers.filter{($0.type == .bar || $0.type == .chef || $0.type == .stamp) && $0.is_have_printer == ACTIVE}

        //check whether tsc printer has the same name as other wifi printer, in order to avoid error
        let valid = PrinterUtils.shared.checkValidPrinters(presenter: self)
        
        if !valid{
            return
        }
        
        
        if items.count > 0 && printers.filter{$0.is_have_printer == ACTIVE}.count > 0{
            
            PrinterUtils.shared.PrintItems(
                presenter: self,
                order:viewModel.order.value,
                printItem:items,
                printers:printers,
                printMode:viewModel.order.value.order_method == .TAKE_AWAY ? .printBackgroundWithoutRetry : .printForeground,
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




