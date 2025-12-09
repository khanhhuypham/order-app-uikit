//
//  LoginOfflineViewController + extension + vadilate.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 12/8/25.
//

import UIKit
import RxSwift
import LocalAuthentication
extension LoginOnlineViewController {
    
    func firstSetup(){
        text_field_restaurant.text = Constants.savedLoginInfor.restaurant_name
        text_field_account.text = Constants.savedLoginInfor.username
        view_of_account.isHidden = false
        view_of_password.isHidden = false
        view_of_code.isHidden = true
        
        hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(reLogin(_:)), name: Notification.Name("changedPassword"), object: nil)
        
//        checkBiometricFunctionality()
        
        mappData()
        isValid()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillChangeFrameNotification , object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification , object:nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification ) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            if text_field_password.isFirstResponder {
                root_view.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height/2.5)
            }
        }
    }
        
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        if text_field_password.isFirstResponder{
            root_view.transform = .identity
        }
    }
    
    
    private func checkBiometricFunctionality(){
//        self.iconClick = false
//        view_faceid.isHidden = true
        
        if ManageCacheObject.getBiometric() == "1"{
            if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &err){

                if context.biometryType == .faceID{
                    if #available(iOS 13.0, *) {
                        view_faceid.isHidden = false
                        image_biometric.image = UIImage(named: "icon-face-id")
                    } else {
                        // Fallback on earlier versions
                    }
                }else{
                    if #available(iOS 13.0, *) {
                        image_biometric.image = UIImage(systemName: "touchid")
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }else{
//                UIAlertController.showAlert(title: nil, message: "Vân tay/Face ID chưa thiết lập")
            }
        }
    }
    
    
    @objc private func reLogin(_ notification:Notification){
        if let account = notification.object as? Account {
           text_field_restaurant.text = account.restaurant_name
           text_field_account.text = account.username
           text_field_password.text = account.password
           viewModel.username.accept(account.username)
           viewModel.password.accept(account.password)
           Utils.resetConfig()
           self.getSessions()
        }
    }
    

    private func mappData(){

        
        _ = text_field_restaurant.rx.text.map{[self](str) in
            
            var name = str ?? ""
            name = name.replacingOccurrences(of: " ", with: "")
            
            if text_field_restaurant.isFirstResponder && name.count > 0{
                lbl_error_restaurant.isHidden = name.count >= 2 && name.count <= 50
            }
           
            name = String(name.prefix(50))
            text_field_restaurant.text = name
            
            return name
        }.bind(to:viewModel.restaurantName).disposed(by: rxbag)
        
        
        
        _ = text_field_account.rx.text.map{[self](str) in
            
            var username = str ?? ""
            username = username.replacingOccurrences(of: " ", with: "")
            

            if text_field_account.isFirstResponder && username.count > 0{
                lbl_account_error.text = "* Tên đăng nhập từ 8 đến 10 kí tự"
                lbl_account_error.isHidden = username.count >= 8 && username.count <= 10
            }
          
            text_field_account.text = username
            
            return username
        }.bind(to: viewModel.username).disposed(by: rxbag)
        
        
        _ = text_field_password.rx.text.map{[self](str) in

                        
            let pwd = str ?? ""
                        
                        
            if text_field_password.isFirstResponder && pwd.count > 0{
                lbl_error_pwd.isHidden = pwd.count >= 4 && pwd.count <= 20
            }
            
          
            return pwd
        }.bind(to: viewModel.password).disposed(by: rxbag)
        
        
        _ = text_field_code.rx.text.map{[self](str) in

                        
            let code = str ?? ""
                        
            if text_field_code.isFirstResponder && !code.isEmpty{
                lbl_error_code.isHidden = !code.isEmpty
            }
            
          
            return code
        }.bind(to: viewModel.code).disposed(by: rxbag)
        
    }
        
    private func isValid(){
        Observable.combineLatest(isRestaurantNameValid,isUserNameValid,isPasswordValid,isCodeValid){($0 && $1 && $2) || ($0 && $3)}.subscribe(onNext: {[self](valid) in
            btn_login.isEnabled = valid
            btn_login.backgroundColor = valid ? ColorUtils.orange_brand_900() :ColorUtils.gray_300()
        }).disposed(by: rxbag)
    }
    
    private var isRestaurantNameValid: Observable<Bool>{
        return viewModel.restaurantName.asObservable().map(){[self](name) in
            return name.count >= 2 && name.count <= 50
        }
    }
    
    private var isUserNameValid: Observable<Bool>{
        return viewModel.username.asObservable().map(){[self](name) in
            return name.count >= 8 && name.count <= 10
        }
    }
    
   
    private var isPasswordValid: Observable<Bool>{
        return viewModel.password.asObservable().map(){[self](pwd) in
            return pwd.count >= 4 && pwd.count <= 20
        }
    }
    
    private var isCodeValid: Observable<Bool>{
        return viewModel.code.asObservable().map(){[self](code) in
            return !code.isEmpty
        }
    }
    
}
