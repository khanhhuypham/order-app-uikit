
import UIKit
import ObjectMapper
import JonAlert
import RxSwift
import RxRelay

extension PaymentRebuildViewController{
    
    func getOrder(){
        viewModel.getOrder().subscribe(onNext: { [self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
              
                if let order = Mapper<OrderDetail>().map(JSONObject: response.data){

                    viewModel.order.accept(order)
                    mapDataAndCheckLvl(order:order)
                
                }
            }
        }).disposed(by: rxbag)
    }
    
    func applyExtraChargeOnTotalBill(){
        viewModel.applyExtraChargeOnTotalBill().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                JonAlert.showSuccess(message: "Hủy áp dụng phụ thu thành công", duration: 2.0)
                self.getOrder()
            }else{
                JonAlert.showError(message: response.message ?? "", duration: 2.0)
            }
         
        }).disposed(by: rxbag)
    }
    
    func applyVAT(applyVAT:Int){
        viewModel.applyVAT(applyVAT:applyVAT).subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                JonAlert.showSuccess(message: applyVAT == ACTIVE ? "Áp dụng VAT thành công" : "Hủy áp dụng VAT thành công", duration: 2.0)
                self.getOrder()
            }else{
                JonAlert.showError(message:response.message ?? "", duration: 2.0)
            }
        }).disposed(by: rxbag)
    }
    
    func applyDiscount(){
        viewModel.applyDiscount().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                JonAlert.show(message: self.viewModel.order.value.discount_percent > 0 ? "Giảm giá thành công" : "Hủy giảm giá thành công", duration: 2.0)
                self.getOrder()
            }else{
                dLog(response.message ?? "")
                JonAlert.showError(message: response.message ?? "", duration: 2.0)
            }
         
        }).disposed(by: rxbag)
    }
    
    
    func unassignCustomerFromOrder(orderId:Int) {
        //CALL API COMPLETED ORDER
        viewModel.unassignCustomerFromOrder(orderId: orderId).subscribe(onNext: { [self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                getOrder()
            }else{
                JonAlert.showError(message: response.message ?? "", duration: 2.0)
            }
        }).disposed(by: rxbag)
    }

    
    func updateCustomer(orderId:Int,customer:Customer) {
        //CALL API COMPLETED ORDER
        viewModel.updateCustomer(orderId: orderId, customer: customer).subscribe(onNext: { [self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                getOrder()
            }else{
                JonAlert.showError(message: response.message ?? "", duration: 2.0)
            }
        }).disposed(by: rxbag)
    }
    
    
    func applyCoupon(couponId:Int) {
        appServiceProvider.rx.request(.postApplyCoupon(branchId: viewModel.branch_id.value, orderId: viewModel.order.value.id, couponId: couponId))
        .filterSuccessfulStatusCodes()
        .mapJSON().asObservable()
        .showAPIErrorToast()
        .mapObject(type: APIResponse.self).subscribe(onNext: { [weak self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                self?.showSuccessMessage(content: "Huỷ coupon thành công")
            }else{
                JonAlert.showError(message: response.message ?? "", duration: 2.0)
            }
            
        }).disposed(by: rxbag)
    }
    
        
}
	
