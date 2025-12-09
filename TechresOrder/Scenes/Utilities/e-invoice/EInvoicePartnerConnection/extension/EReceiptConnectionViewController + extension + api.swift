//
//  EReceiptConnectionViewController + extension + api.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 05/06/2025.
//

import UIKit
import ObjectMapper
extension EReceiptConnectionViewController{
    
    func getRestaurantPartnerInvoice(){
        viewModel.getRestaurantPartnerInvoice().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let list = Mapper<EInvoicePartner>().mapArray(JSONObject: response.data) {
                    
                    self.viewModel.invoiceArray.accept(list)
                    self.tableView.reloadData()
                }
            }else {

                self.showErrorMessage(content: response.message ?? "")
            }
        }).disposed(by: rxbag)
    }
    
    
    func changeStatus(id:Int){
        viewModel.changeStatus(id:id).subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                self.getRestaurantPartnerInvoice()
            }else {

                self.showErrorMessage(content: response.message ?? "")
            }
        }).disposed(by: rxbag)
    }

}
