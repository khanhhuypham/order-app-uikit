//
//  EnterInformationViewController + extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 29/03/2025.
//

import UIKit
import RxSwift
extension EnterInformationViewController {

    
    func mapDataAndValidate(){
        mapData()
        isInforValid()
        textview_address.withDoneButton()
        viewModel.orderId.accept(orderId)
        viewModel.customer.accept(customer)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOutSide(_:)))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    
    }
    
    @objc func handleTapOutSide(_ gesture:UIGestureRecognizer){
        let tapLocation = gesture.location(in: root_view)
        if !root_view.bounds.contains(tapLocation){
           dismiss(animated: true)
        }
    }
    
    func mapData(){
        
        
        _ = textfield_name.rx.text.map{[self] str in
            var customer = viewModel.customer.value
            let name = str?.prefix(255) ?? ""
            
            customer.name = String(name)
            
            return customer
            
        }.bind(to: viewModel.customer).disposed(by: rxbag)
        
        _ = textfield_phone.rx.text.map{[self] str in
            var customer = viewModel.customer.value
            var phone = str ?? ""
         

            if phone.count > 15{
                self.showWarningMessage(content: "Số điện thoại tối đa là 15 kí tự")
                phone = String(phone.prefix(15))
            }
           
            textfield_name.isUserInteractionEnabled = true
            textview_address.isUserInteractionEnabled = true

            customer.id = 0 // only customers from list have id > 0, the other will be treated as new customer => id = 0
            customer.phone = phone
            
            
            //call APi to get customer list
            if !customer.phone.isEmpty && textfield_phone.isFirstResponder{
                self.getCustomerList(phone:customer.phone)
            }
            
            return customer
             
        }.bind(to: viewModel.customer).disposed(by: rxbag)
        

        
        _ = textview_address.rx.text.map{[self] str in
          
            var customer = viewModel.customer.value
  
            customer.address = str ?? ""
            
            return customer
            
        }.bind(to: viewModel.customer).disposed(by: rxbag)
        
    }
    
    
    private func isInforValid(){
        Observable.combineLatest(isNameValid,isPhoneValid,isAddressValid).map{ (a,b,c) in
            return a && b && c
        }.subscribe(onNext: {(valid) in
            self.btnConfirm.backgroundColor = valid ? ColorUtils.orange_brand_900() : .systemGray4
            self.btnConfirm.isEnabled = valid ? true : false
        }).disposed(by: rxbag)
    }
    
    private var isNameValid: Observable<Bool>{
        return viewModel.customer.asObservable().map(){[self](customer) in
            
            if !customer.name.isEmpty {
                lbl_error_name.text = "* Tên khách hàng từ 2 đến 255 kí tự"
                lbl_error_name.isHidden = customer.name.count >= 2 && customer.name.count <= 255
            }
            
            textfield_name.text = customer.name
            
            return customer.name.count >= 2 && customer.name.count <= 255
            
        }
    }
    
    private var isPhoneValid: Observable<Bool>{
        return viewModel.customer.asObservable().map(){[self](customer) in
            
            //validate customer phone. we must take twelve character in order to send warning message for user if they try to type more
            if textfield_phone.isFirstResponder && !customer.phone.isEmpty {
                lbl_error_phone.text = "* Số điện thoại từ 7 đến 15 kí tự"
                lbl_error_phone.isHidden = customer.phone.count >= 7 && customer.phone.count < 16
            }
            
            textfield_phone.text = customer.phone
            
    
            return customer.phone.count >= 7 && customer.phone.count < 16
        }
    }
    
   
    private var isAddressValid: Observable<Bool>{
        
        return viewModel.customer.asObservable().map(){[self](customer) in
            
            textview_address.text = customer.address
//            if textview_address.isFirstResponder && !address.isEmpty{
//                lbl_error_address.text = "* Địa chỉ không được bỏ trống"
//                lbl_error_address.isHidden = !address.isEmpty
//            }
//            return !customer.address.isEmpty
            return true
        }
        
        
    }

}
