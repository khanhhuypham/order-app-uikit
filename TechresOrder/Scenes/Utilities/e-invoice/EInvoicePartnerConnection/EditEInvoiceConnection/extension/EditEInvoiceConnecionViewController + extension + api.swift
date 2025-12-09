//
//  EditEInvoiceConnecionViewController + extension + api.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 05/06/2025.
//

import UIKit
import RxSwift
import ObjectMapper
import JonAlert

extension EditEInvoiceConnectionViewController{
    func getPartnerInvoiceConnectionDetail(){
        viewModel.getPartnerInvoiceConnectionDetail().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                
                if let data = Mapper<EInvoicePartnerDetail>().map(JSONObject: response.data) {
                    
                    self.viewModel.invoice.accept(data)
                    self.setupData(data: data)
                  
                }else {
                    var invoice = self.viewModel.invoice.value
                    invoice.is_auto_export_third_party = ACTIVE
                    invoice.apply_order_types = [1]
                    self.viewModel.invoice.accept(invoice)
                    self.setupData(data: invoice)
                }
                
            }else {

                self.showErrorMessage(content: response.message ?? "")
            }
        }).disposed(by: rxbag)
    }
    
    
    func updatePartnerInvoiceConnection(invoice:EInvoicePartnerDetail){
        viewModel.updatePartnerInvoiceConnection(invoice: invoice).subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                
                
                self.dismiss(animated: true,completion: {
                    self.assignBranchForEInvoicePartner(invoice: self.viewModel.invoice.value)
                    self.showSuccessMessage(content: "Cập nhật thành công")
                })
                
            }else {

                self.showErrorMessage(content: response.message ?? "")
            }
        }).disposed(by: rxbag)
    }
    
    
    func createPartnerInvoiceConnection(branch_id:Int,invoice:EInvoicePartnerDetail){
        viewModel.createPartnerInvoiceConnection(branch_id: branch_id, invoice: invoice).subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                
                self.dismiss(animated: true,completion: {
//                    assignBranchForEInvoicePartner(v)
                    self.completion?()
                    self.showSuccessMessage(content: "Tạo liên kết thành công")
                })
                
            }else {

                self.showErrorMessage(content: response.message ?? "")
            }
        }).disposed(by: rxbag)
    }
    
    
    func assignBranchForEInvoicePartner(invoice:EInvoicePartnerDetail){
        viewModel.assignBranchForEInvoicePartner(invoice: invoice).subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                
                
            }else {

                self.showErrorMessage(content: response.message ?? "")
            }
            
        }).disposed(by: rxbag)
    }
    
    
    func unassignBranchForEInvoicePartner(invoice:EInvoicePartnerDetail){
        viewModel.unassignBranchForEInvoicePartner(invoice: invoice).subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                
                self.showSuccessMessage(content: "Gỡ gán chi nhánh thành công")
                self.getPartnerInvoiceConnectionDetail()
                self.alreadyUnassignBranch = true
                
            }else{
                
                self.showErrorMessage(content: response.message ?? "")
                
            }
        }).disposed(by: rxbag)
    }
}
