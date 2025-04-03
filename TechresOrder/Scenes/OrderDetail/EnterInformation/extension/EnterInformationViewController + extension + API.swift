//
//  EnterInformationViewController + extension + API.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 29/03/2025.
//

import UIKit
import ObjectMapper
extension EnterInformationViewController {
    
    
    func assignCustomerToOrder(){
        viewModel.assignCustomerToOrder().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                self.showSuccessMessage(content: "Thêm thông tin khách hàng thành công")
                (self.completion ?? {})()
                self.actionCancel("")
            }else {

                self.showErrorMessage(content: response.message ?? "")
            }
        }).disposed(by: rxbag)
    }
    
    func unassignCustomerFromOrder(orderId:Int) {
        //CALL API COMPLETED ORDER
        viewModel.unassignCustomerFromOrder(orderId: orderId).subscribe(onNext: { [self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                assignCustomerToOrder()
            }else{
                self.showErrorMessage(content: response.message ?? "")
            }
        }).disposed(by: rxbag)
    }
    
    
    func createCustomer(){
        viewModel.createCustomer().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                self.showSuccessMessage(content: "Thêm thông tin khách hàng thành công")
                (self.completion ?? {})()
                self.actionCancel("")
            }else {

                self.showErrorMessage(content: response.message ?? "")
            }
        }).disposed(by: rxbag)
        
    }
    
    
    func getCustomerList(phone:String){
        viewModel.getCustomerList(phone:phone).subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let list = Mapper<Customer>().mapArray(JSONObject: response.data) {
                    
                    if !list.isEmpty {
                        self.showCustomerList(list: list)
                    }
                }
            }else {

                self.showErrorMessage(content: response.message ?? "")
            }
        }).disposed(by: rxbag)
        
    }
}
