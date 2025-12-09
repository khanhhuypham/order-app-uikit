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

    // ================================== API get items need to print =====================================================
    func getFoodsNeedPrint(print:Bool = false,pay:Bool = false){
        viewModel.getFoodsNeedPrint().subscribe(onNext: { [self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
   
                if let printItem = Mapper<Food>().mapArray(JSONObject: response.data){
                 
                    let pendingItem = printItem.filter{$0.status == PENDING}
                    let cancelItem = printItem.filter{$0.status == CANCEL_FOOD}
                    let returnedItem = printItem.filter{$0.category_type == .drink && $0.return_quantity_for_drink > 0}
                    
                    if pendingItem.count > 0 && print{
                        permissionUtils.GPBH_2_o_2
                        ? requestPrintChefBar(printType:.new_item, pay:pay)
                        : self.print(items:pendingItem, printType:.new_item)
                    }
                    
                    if cancelItem.count > 0{
                        permissionUtils.GPBH_2_o_2
                        ? requestPrintChefBar(printType:.cancel_item)
                        : self.print(items:cancelItem, printType:.cancel_item)
                    }
                    
                    
                    if returnedItem.count > 0{
                        permissionUtils.GPBH_2_o_2
                        ? requestPrintChefBar(printType: .return_item)
                        : self.print(items: returnedItem,printType: .return_item)
                    }
                    
                    viewModel.foodsNeedToPrint.accept(pendingItem)
                    
                }
            }
        }).disposed(by: rxbag)
    }
    
    
    private func requestPrintChefBar(printType:Constants.printType,pay:Bool = false){
        
        viewModel.requestPrintChefBar(printType:printType).subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){

                self.showSuccessMessage(content: "Gửi bếp bar thành công")
                
                if pay{
                    self.getOrder(pay:pay)
                }
            
            }else{
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại.", duration: 3.0)
            }
        }).disposed(by: rxbag)
    }
    
    
    
    
    private func updateReadyPrinted(order_detail_ids:[Int]){
        viewModel.updateReadyPrinted(order_detail_ids:order_detail_ids).subscribe(onNext: { (response) in
            
            if(response.code == RRHTTPStatusCode.ok.rawValue){

                
            }else{
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại.", duration: 3.0)
            }
        }).disposed(by: rxbag)
        
    }
    
    
    
    
    // ============== Handler printer ==============
    
    //MARK: print_type = 0 => món mới; print_type = 1 => món cập nhật tăng giảm; print_type = 2 => món huỷ;
    private func print(items:[Food], printType:Constants.printType) {
        
        var printers = Constants.printers.filter{$0.type == .bar || $0.type == .chef}
        var itemSendToPrinter:[Food] = []
        var itemSendToServer:[Food] = []
        
        for printer in printers.filter{$0.is_have_printer == ACTIVE}{
            itemSendToPrinter += items.filter{$0.restaurant_kitchen_place_id == printer.id}
        }
        
        itemSendToServer += items
        
        //check whether tsc printer has the same name as other wifi printer, in order to avoid error
        let valid = PrinterUtils.shared.checkValidPrinters(presenter: self)
        
        if !valid{
            return
        }
        
        if itemSendToServer.count > 0{
            updateReadyPrinted(order_detail_ids: itemSendToServer.map{$0.id})
        }
        
        // we insert stamp printer to print stamp for items which is allow to print stamp
        if let stampPrinter = Constants.printers.filter{$0.type == .stamp}.filter{$0.is_have_printer == ACTIVE}.first{
            printers.append(stampPrinter)
            
            for (i,_) in itemSendToPrinter.enumerated() {
                if itemSendToPrinter[i].is_allow_print_stamp == ACTIVE{
                    
                    itemSendToPrinter[i].TSCPrinter_id = stampPrinter.id
                    
                }
            }
            
        }
        

        if itemSendToPrinter.count > 0 && printers.filter{$0.is_have_printer == ACTIVE}.count > 0{
            
            PrinterUtils.shared.PrintItems(
                presenter: self,
                order:viewModel.order.value,
                printItem:itemSendToPrinter,
                printers:printers,
                printMode:viewModel.order.value.order_method == .TAKE_AWAY ? .printBackgroundWithoutRetry : .printForeground,
                completetHandler: {
                    self.getOrder()
                }
            )

        }
    }
    
    
    
    
}




