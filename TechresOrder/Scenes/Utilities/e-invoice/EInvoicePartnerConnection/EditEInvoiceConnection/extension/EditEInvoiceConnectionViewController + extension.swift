//
//  EditEReceiptConnectionViewController + extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 05/06/2025.
//

import UIKit
import RxSwift
import RxRelay
extension EditEInvoiceConnectionViewController{

    
    func setupData(data:EInvoicePartnerDetail){
        
        lbl_title.text = String(format: "Thông tin cấu hình xuất hoá đơn cho: %@", data.partner_invoice_name)
        textfield_username.text = data.username
        textfield_password.text = data.password
        textfield_service_username.text = data.username_access_service
        textfield_service_password.text = data.password_access_service
        textfield_tax_code.text = data.tax_code
        textfield_invoice_code.text = data.invoice_denominator
        textfield_e_sign.text = data.invoice_series
        textfield_url_validation.text = data.endpoint
        
        view_of_service_username.isHidden = data.partner_electronic_invoice_type == .vnpt ? false : true
        view_of_service_password.isHidden = data.partner_electronic_invoice_type == .vnpt ? false : true
        
        btn_auto_export_bill.setImage(
            UIImage(named: data.is_auto_export_third_party == ACTIVE ? "icon-radio-checked" : "icon-radio-uncheck"),
            for: .normal
        )
        
        
        if data.apply_order_types.count == 1,let orderType = data.apply_order_types.first{
            
            if orderType == 1{
                btn_export_bill_for_order.setImage(UIImage(named: "icon-radio-checked"),for: .normal)
                btn_export_bill_for_app_food.setImage(UIImage(named: "icon-radio-uncheck"),for: .normal)
                btn_export_bill_for_all.setImage(UIImage(named: "icon-radio-uncheck"),for: .normal)
            }else if orderType == 2{
                btn_export_bill_for_order.setImage(UIImage(named: "icon-radio-uncheck"),for: .normal)
                btn_export_bill_for_app_food.setImage(UIImage(named: "icon-radio-checked"),for: .normal)
                btn_export_bill_for_all.setImage(UIImage(named: "icon-radio-uncheck"),for: .normal)
            }
            
        }else if data.apply_order_types.count == 2{
            btn_export_bill_for_order.setImage(UIImage(named: "icon-radio-uncheck"),for: .normal)
            btn_export_bill_for_app_food.setImage(UIImage(named: "icon-radio-uncheck"),for: .normal)
            btn_export_bill_for_all.setImage(UIImage(named: "icon-radio-checked"),for: .normal)
        }else{
            btn_export_bill_for_order.setImage(UIImage(named: "icon-radio-uncheck"),for: .normal)
            btn_export_bill_for_app_food.setImage(UIImage(named: "icon-radio-uncheck"),for: .normal)
            btn_export_bill_for_all.setImage(UIImage(named: "icon-radio-uncheck"),for: .normal)
        }
        btn_apply_before_discount.setImage(
            UIImage(named: data.apply_discount == ACTIVE ? "icon-radio-checked" : "icon-radio-uncheck"),
            for: .normal
        )
        btn_assign_branch.isHidden = data.branch_assigns.count > 0 ? false : true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillChangeFrameNotification , object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification , object:nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification ) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            if textfield_url_validation.isFirstResponder ||
                textfield_e_sign.isFirstResponder
            {
                root_view.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height/4)
            }
        }
    }
        
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        if textfield_url_validation.isFirstResponder ||
            textfield_e_sign.isFirstResponder
        {
            root_view.transform = .identity
        }
    }
    
    func mapData(){
        
        _ = textfield_username.rx.text.map{[self] str in
            
            lbl_username_err.isHidden = true
            
            var invoice = viewModel.invoice.value
            invoice.username = str ?? ""
            return invoice
            
        }.bind(to: viewModel.invoice).disposed(by: rxbag)
        
        _ = textfield_password.rx.text.map{[self] str in
            
            lbl_password_err.isHidden = true
            
            var invoice = viewModel.invoice.value
            invoice.password = str ?? ""
            return invoice
             
        }.bind(to: viewModel.invoice).disposed(by: rxbag)
        
        
        _ = textfield_service_username.rx.text.map{[self] str in
            
            lbl_service_username_err.isHidden = true
            
            var invoice = viewModel.invoice.value
            invoice.username_access_service = str ?? ""
            return invoice
            
        }.bind(to: viewModel.invoice).disposed(by: rxbag)
        
        _ = textfield_service_password.rx.text.map{[self] str in
            
            lbl_service_password_err.isHidden = true
            
            var invoice = viewModel.invoice.value
            invoice.password_access_service = str ?? ""
            return invoice
             
        }.bind(to: viewModel.invoice).disposed(by: rxbag)
        

        _ = textfield_tax_code.rx.text.map{[self] str in
            
            lbl_tax_code_err.isHidden = true
            
            var invoice = viewModel.invoice.value
            invoice.tax_code = str ?? ""
            return invoice
    
        }.bind(to: viewModel.invoice).disposed(by: rxbag)
        
        
        _ = textfield_invoice_code.rx.text.map{[self] str in
            
            lbl_invoice_denominator_err.isHidden = true
            
            var invoice = viewModel.invoice.value
            invoice.invoice_denominator = str ?? ""
            return invoice
    
        }.bind(to: viewModel.invoice).disposed(by: rxbag)
        
        
        _ = textfield_e_sign.rx.text.map{[self] str in
            
            lbl_e_sign_err.isHidden = true
            
            var invoice = viewModel.invoice.value
            invoice.invoice_series = str ?? ""
            return invoice
    
        }.bind(to: viewModel.invoice).disposed(by: rxbag)
        
        
        _ = textfield_url_validation.rx.text.map{[self] str in
            
            lbl_url_validation_err.isHidden = true
            
            var invoice = viewModel.invoice.value
            invoice.endpoint = str ?? ""
            return invoice
    
        }.bind(to: viewModel.invoice).disposed(by: rxbag)
        
    }
     

    var isInvoiceValid: Observable<Bool>{
        return Observable.combineLatest(isUsernameValid,isPwdValid,isTaxCodeValid,isInvoiceDenominatorValid,isESignValid,isUrlValid){$0 && $1 && $2 && $3 && $4 && $5}
    }
    
    private var isUsernameValid: Observable<Bool>{
        return viewModel.invoice.asObservable().map(){[self](invoice) in
            
            if invoice.username.isEmpty{
                lbl_username_err.text = "* Tài khoản không được bỏ trống"
                lbl_username_err.isHidden = false
            }else if invoice.username.count < 2 {
                lbl_username_err.text = "* Tài khoản tối thiểu 2 ký tự"
                lbl_username_err.isHidden = false
            }else{
                lbl_username_err.isHidden = true
            }
            
            return !invoice.username.isEmpty && invoice.username.count >= 2
            
        }
    }
    
    private var isPwdValid: Observable<Bool>{
        return viewModel.invoice.asObservable().map(){[self](invoice) in
            
            if invoice.password.isEmpty{
                lbl_password_err.text = "* Mật khẩu không được bỏ trống"
                lbl_password_err.isHidden = false
            }else if invoice.password.count < 2 {
                lbl_password_err.text = "* Mật khẩu tối thiểu 2 ký tự"
                lbl_password_err.isHidden = false
            }else{
                lbl_password_err.isHidden = true
            }
            
           return !invoice.password.isEmpty && invoice.password.count >= 2
        }
    }
    
   
    private var isTaxCodeValid: Observable<Bool>{
        
        return viewModel.invoice.asObservable().map(){[self](invoice) in
            
            if invoice.tax_code.isEmpty{
                
                lbl_tax_code_err.text = "* MST không được bỏ trống"
                lbl_tax_code_err.isHidden = false
                
            }else if invoice.tax_code.count < 10 {
                
                lbl_tax_code_err.text = "* MST tối thiểu 10 ký tự"
                lbl_tax_code_err.isHidden = false
                
            }else{
                lbl_tax_code_err.isHidden = true
            }
            
            
            return !invoice.tax_code.isEmpty && invoice.tax_code.count >= 10
        }
    }
    
    private var isInvoiceDenominatorValid: Observable<Bool>{
        
        return viewModel.invoice.asObservable().map(){[self](invoice) in
            
            if invoice.invoice_denominator.isEmpty{
                
                lbl_invoice_denominator_err.text = "* Mẫu số hoá đơn không được bỏ trống"
                lbl_invoice_denominator_err.isHidden = false
                
            }else{
                lbl_invoice_denominator_err.isHidden = true
            }
            

            return !invoice.invoice_denominator.isEmpty
        }
        
    }
    
    private var isESignValid: Observable<Bool>{
        
        return viewModel.invoice.asObservable().map(){[self](invoice) in
            
            if invoice.invoice_series.isEmpty{
                
                lbl_e_sign_err.text = "* Chữ ký điện tử không được bỏ trống"
                lbl_e_sign_err.isHidden = false
                
            }else{
                
                lbl_e_sign_err.isHidden = true
                
            }
            
            return !invoice.invoice_series.isEmpty
        }
        
    }
    
    private var isUrlValid: Observable<Bool>{
        
        return viewModel.invoice.asObservable().map(){[self](invoice) in
            
            if invoice.endpoint.isEmpty{
                
                lbl_url_validation_err.text = "* Url xác thực không được bỏ trống"
                lbl_url_validation_err.isHidden = false
                
            } else if !Utils.isValidURL(invoice.endpoint){
                
                lbl_url_validation_err.text = "* Url xác thực không hợp lệ"
                lbl_url_validation_err.isHidden = false
                
            }else{
                
                lbl_url_validation_err.isHidden = true
                
            }
            
            return !invoice.endpoint.isEmpty && Utils.isValidURL(invoice.endpoint)
            
        }
    }
    
}
