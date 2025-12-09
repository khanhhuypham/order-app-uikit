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
    func getBrandBankAccount(order:OrderDetail){
        viewModel.getBrandBankAccount().subscribe(onNext: { [self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let bankAccount = Mapper<BankAccount>().map(JSONObject: response.data) {
                    printInvoice(orderDetail:order, bankAccount:bankAccount)
                }
            }else{
                self.showWarningMessage(content: response.message ?? "")
            }
        }).disposed(by: rxbag)
        
    }
        	
    
    func completePayment() {
        //CALL API COMPLETED ORDER
        viewModel.completedPayment().subscribe(onNext: { [self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){

                JonAlert.showSuccess(message:"Đã hoàn tất đơn hàng và in bill cho khách.", duration: 2.0)
                
                if permissionUtils.InvoicePrinter{
                    getBrandBankAccount(order:viewModel.order.value)
                }else{
                    self.navigationController?.viewControllers.removeAll(where: { (vc) -> Bool in
                        return vc.isKind(of: OrderDetailViewController.self) ? true : false
                    })
                    self.viewModel.makePopViewController()
                }
            }else{
                JonAlert.showError(message: response.message ?? "", duration: 2.0)
            }
        }).disposed(by: rxbag)
    }
    
    
    func requestPayment(paymentMethod:Int){
        viewModel.requestPayment(paymentMethod: paymentMethod).subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                JonAlert.showSuccess(message: "Yêu cầu thanh toán thành công", duration: 2.0)
                self.viewModel.makePopViewController()
            }else{
                //Chỉ dành riêng cho giải pháp 2o2
                if permissionUtils.GPBH_2_o_2{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2, execute: {
                        self.showErrorMessage(content: response.message ?? "")
                    })
                }else {
                    self.showErrorMessage(content: response.message ?? "")
                }
              
            }
        }).disposed(by: rxbag)
    }
    
  

    func updateCustomerNumberSlot(){
        viewModel.updateCustomerNumberSlot().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                self.getOrder()
            }
        }).disposed(by: rxbag)
    }
    
    
    
    //MARK: API kiểm tra cần đánh giá. API này cho GPBH2 trở lên, có GPQT lvl3
    func getFoodsNeedReview(){
        viewModel.getFoodsNeedReview().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let reviews = Mapper<OrderItem>().mapArray(JSONObject: response.data) {
                    /*
                         step3: kiểm tra món nào chưa được đánh giá thì đánh giá (có GPQT_lvl3 thì mới thực hiện bước này)
                                 + Nếu có món chưa đánh giá thì hiển thị popup yêu cầu nhập đánh giá
                                 + Nếu không có món cần đánh giá thì ta thực hiện bước thanh toán tiếp theo (chọn phương thức thanh toán)
                        */
                    reviews.count > 0
                    ? self.presentModalReviewFoodViewController(order_id: self.viewModel.order.value.id)
                    : self.executePaymentProcedure(step: 4)
                    
                }
                
            }else{
                dLog(response.message ?? "")
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.")
            }
            
        }).disposed(by: rxbag)
    }
    


//    
//    func updateReadyPrinted(order_detail_ids:[Int]){
//        viewModel.updateReadyPrinted(order_detail_ids: order_detail_ids).subscribe(onNext: { (response) in
//            if(response.code == RRHTTPStatusCode.ok.rawValue){
//                
//                /*
//                      sau khi cập nhật xong các món cần in thì ta thực hiện bước thanh toán tiếp theo (step2: nhập số lượng người)
//                    */
//                
//                self.getOrder()
//                self.executePaymentProcedure(step:2)
//                
//            }else{
//                JonAlert.showError(message:response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại.", duration: 2.0)
//            }
//        }).disposed(by: rxbag)
//    }
//    

    func executePaymentProcedure(step:Int){
        let order = viewModel.order.value
        
        
        /*
            Có 5 bước thực hiện quá trình thanh toán hoặc yêu cầu thanh toán
            
          
         
             step1: kiểm tra món vào chưa được in thì in
                    $ Chỉ app dụng cho GPBH1 và GPBH2
                    + if: có món cần in thì show popup yêu càu in
                         + if user chọn "xác nhận"
                                         nếu ở GPBH_1 || GPBH2o1 -> gọi updateReadyPrinted() -> thực hiện bước tiếp theo nhập số lượng người
                                         nếu GPBH2o2 -> gọi requestPrintChefBar() -> thực hiện bước tiếp theo nhập số lượng người
                            
                    + if: ko có cần in thì ta thực hiện chọn thanh toán thanh toán tiếp theo

         
            step2: yêu cầu người dùng nhập số lượng người (chỉ có account có GPQT_lvl3 và is_require_update_customer_slot_in_order == ACTIVE  thì mới thực hiện bước này)
                    $ Chỉ app dụng cho GPBH2 và GPBH3 mà có GPQT >= 3
                    + if: order.customer_slot_number == 0 -> show popup yêu cầu nhập số lượng người -> sau khi nhập thành công -> gọi API updateCustomerNumberSlot() và thực hiện bước thức thanh toán tiếp theo
                    + if: order.customer_slot_number > 0 thì thực hiện bước thức thanh toán tiếp theo
         
            step3: kiểm tra món nào chưa được đánh giá thì đánh giá (có GPQT_lvl3 thì mới thực hiện bước này)
                    $ Chỉ app dụng cho GPBH3 mà có GPQT >= 3
                    + if: có món chưa đánh giá thì hiển thị popup yêu cầu nhập đánh giá
                    + if: không có món cần đánh giá thì ta thực hiện bước thanh toán tiếp theo
         
            step4: chỉ có GPBH1 || GPBH2 với role== cashier, owner thì mới thực hiện bước này
                    + if: nếu setting có bật trường is_apply_only_cash_amount_payment_method -> thì mặc định chọn phương thức thanh toán bằng tiền mặt
                    + if: ko bật thì hiển thị popup chọn phương thức thanh toán
         
            step5: thanh toán hoặc yêu cầu thanh toán
         */
        switch step{
            
            case 1://kiểm tra món vào chưa được in thì in
                if permissionUtils.GPBH_1{
                    checkFoodNotPrints()
                }else if permissionUtils.GPBH_2{
                    
                    permissionUtils.GPBH_2_o_1
                    ? getOrderNeedToPrintFor2o1()
                    : checkFoodNotPrints()
                    
                }else if permissionUtils.GPBH_3{
                    executePaymentProcedure(step: 2)
                }
                
                break
                
            case 2://yêu cầu người dùng nhập số lượng người
                
                if permissionUtils.GPBH_1{
                    executePaymentProcedure(step: 3)
                }else if permissionUtils.GPBH_2{
                    
                    ManageCacheObject.getSetting().is_require_update_customer_slot_in_order == ACTIVE && order.customer_slot_number == 0 && permissionUtils.GPQT_3_and_above
                    ? presentModalUpdateCustomerSlotViewController()
                    : executePaymentProcedure(step: 3)
                    
                }else if permissionUtils.GPBH_3{

                    ManageCacheObject.getSetting().is_require_update_customer_slot_in_order == ACTIVE && order.customer_slot_number == 0 && permissionUtils.GPQT_3_and_above
                    ? presentModalUpdateCustomerSlotViewController()
                    : executePaymentProcedure(step: 3)
                }

                break
            
            case 3://kiểm tra món chưa được đánh giá
            
                if  permissionUtils.GPBH_1{
                    executePaymentProcedure(step: 4)
                }else if permissionUtils.GPBH_2{
                    executePaymentProcedure(step: 4)
                }else if permissionUtils.GPBH_3{
                    permissionUtils.GPQT_3_and_above ? getFoodsNeedReview() : executePaymentProcedure(step: 4)
                }
            
                break

            case 4:
            
                let condition = permissionUtils.GPBH_1 || (permissionUtils.GPBH_2_o_1 && permissionUtils.OwnerOrCashier)
          
                if condition{
                    ManageCacheObject.getPaymentMethod().is_apply_only_cash_amount_payment_method == ACTIVE
                    ? callBackToGetPaymentMethod(paymentMethod: Constants.PAYMENT_METHOD.CASH)
                    : presentPaymentPopupViewController(totalPayment: order.total_final_amount)
                }else{
                    executePaymentProcedure(step: 5)
                }

            
                break
            
            case 5:
                if permissionUtils.GPBH_1{
                    
                    completePayment()
                    
                }else if permissionUtils.GPBH_2{
                    
                    if permissionUtils.GPBH_2_o_1{
                        completePayment()
                    }else{
                        requestPayment(paymentMethod: 1)
                    }
                   
                }else if permissionUtils.GPBH_3{
                    requestPayment(paymentMethod: 1)
                }
                break
            
        
            default:
                
                break
        }
       
    }
}
