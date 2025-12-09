//
//  PaymentViewController + extension + API(Payment).swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 03/05/2024.
//

import UIKit
import ObjectMapper
import JonAlert
import RxSwift
import RxRelay

extension PaymentRebuildViewController{


    
    //MARK: Kiểm tra số món chưa in có ko ? Nếu chưa in thì thông báo in trước khi thanh toán bill
    func checkFoodNotPrints(){
        viewModel.getFoodsNeedPrint().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let items_need_to_print = Mapper<Food>().mapArray(JSONObject: response.data){
                    
                    /*
                        nếu có món cần in thì in
                        nếu ko có cần in thì ta thực hiện bước thanh toán tiếp theo (step2: yêu cầu người dùng nhập số lượng người)
                        */
                    
                    if (items_need_to_print.count > 0) {
                        self.viewModel.itemsNeedToPrint.accept(items_need_to_print)
                        self.presentModalDialogConfirmViewController(
                            content: "Hiện tại còn món chưa gửi Bếp/Bar bạn có muốn gửi Bếp/Bar trước khi thanh toán không?",
                            confirmClosure: {
                                let itemsNeedToPrint = self.viewModel.itemsNeedToPrint.value

                                if(itemsNeedToPrint.count > 0){
                                    permissionUtils.GPBH_2_o_2
                                    ? self.requestPrintChefBar(printType: .new_item)
                                    : self.print(items:itemsNeedToPrint,printType: .new_item)
              
                                }
                            }
                        )
                    }else{                                              
                        self.executePaymentProcedure(step: 2)
                    }
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
    
    
    
    private func updateReadyPrinted(order_detail_ids:[Int]){
        viewModel.updateReadyPrinted(order_detail_ids: order_detail_ids).subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                
                /*
                    sau khi cập nhật xong các món cần in thì ta thực hiện bước thanh toán tiếp theo (step2: nhập số lượng người)
                */
                
                self.getOrder()
                self.executePaymentProcedure(step:2)
                
            }else{
                JonAlert.showError(message:response.message ?? "", duration: 2.0)
            }
        }).disposed(by: rxbag)
    }
    
    //MARK: print_type = 0 => món mới; print_type = 1 => món cập nhật tăng giảm; print_type = 2 => món huỷ;
    private func print(items:[Food], printType:Constants.printType) {
        
        var printers = Constants.printers.filter{$0.type == .chef || $0.type == .bar}
        
        var itemSendToPrinter:[Food] = []
        var itemSendToServer:[Food] = []
        
        for printer in printers{
    
            if printer.is_have_printer == ACTIVE{
                itemSendToPrinter += items.filter{$0.restaurant_kitchen_place_id == printer.id}
            }
            
            itemSendToServer += items.filter{$0.restaurant_kitchen_place_id == printer.id}
        }
            
        itemSendToServer += items.filter{(item) in
            let printerIds = printers.map{$0.id}
            
            return !printerIds.contains(item.restaurant_kitchen_place_id) ? true : false
        }
        
        
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
       
        if let vc = Utils.getTopMostViewController(), itemSendToPrinter.count > 0 && printers.filter{$0.is_have_printer == ACTIVE}.count > 0{
            
            PrinterUtils.shared.PrintItems(
                presenter: vc,
                order:viewModel.order.value,
                printItem:itemSendToPrinter,
                printers:printers,
                printMode:.printForeground,
                completetHandler: {
                    self.getOrder()
                }
            )
        }
        
        
        
    }
    
}
