//
//  LoginOfflineViewController + extension + vadilate.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 12/8/25.
//

import UIKit
import RxSwift
import Network
extension LoginOfflineViewController {
    
    func firstSetup(){
        text_field_ipAddress.text = Constants.savedLoginInfor.ip_address
        text_field_restaurant.text = Constants.savedLoginInfor.restaurant_name
        text_field_account.text = Constants.savedLoginInfor.username
        view_of_account.isHidden = false
        view_of_password.isHidden = false
        view_of_code.isHidden = true
        
        hideKeyboardWhenTappedAround()
    
        mappData()
        isValid()
        NotificationCenter.default.addObserver(self, selector: #selector(reLogin(_:)), name: Notification.Name("changedPassword"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillChangeFrameNotification , object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification , object:nil)
        
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
    
    @objc private func keyboardWillShow(notification: NSNotification ) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            if text_field_code.isFirstResponder || text_field_password.isFirstResponder || text_field_account.isFirstResponder{
                root_view.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height/2.5)
            }
        }
    }
        
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        if text_field_code.isFirstResponder || text_field_password.isFirstResponder || text_field_account.isFirstResponder{
            root_view.transform = .identity
        }
    }
    

    private func mappData(){
        
        _ = text_field_ipAddress.rx.text.map{[self](str) in
            
            var ip = str ?? ""
            ip = ip.replacingOccurrences(of: " ", with: "")
            
            if text_field_ipAddress.isFirstResponder && !ip.isEmpty{
                if let _ = IPv4Address(ip) {
                    lbl_error_ipAddress.isHidden = true
                }else{
                    lbl_error_ipAddress.isHidden = false
                    lbl_error_ipAddress.text = "Địa chỉ IP không hợp lệ. VD: 192.168.1.10 hoặc 172.168.1.10"
                }
            }
       
           
            ip = String(ip.prefix(50))
            text_field_ipAddress.text = ip
            
            return ip
        }.bind(to:viewModel.ipAddress).disposed(by: rxbag)

        
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
        Observable.combineLatest(isIpAddressValid,isRestaurantNameValid,isUserNameValid,isPasswordValid,isCodeValid){($0 && $1 && $2 && $3) || ($0 && $1 && $4)}.subscribe(onNext: {[self](valid) in
            btn_login.isEnabled = valid
            btn_login.backgroundColor = valid ? ColorUtils.orange_brand_900() :ColorUtils.gray_300()
            
            if valid{
                dLog(viewModel.ipAddress.value)
                ManageCacheObject.setSavedLoginInfo(
                    SavedLoginInfor(
                        ip_address: viewModel.ipAddress.value,
                        restaurant_name: Constants.savedLoginInfor.restaurant_name,
                        username: Constants.savedLoginInfor.username
                    )
                )
                dLog(Constants.savedLoginInfor.ip_address)
                environmentMode = .offline
            }
            
        }).disposed(by: rxbag)
    }
    
    private var isIpAddressValid: Observable<Bool>{
        return viewModel.ipAddress.asObservable().map(){[self](ip) in
            if let _ = IPv4Address(ip) {
                requestLocalNetworkPermission(ipAddress:ip)
                return true
            }else{
                return false
            }
        }
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
    
    private func requestLocalNetworkPermission(ipAddress:String){
        let host = NWEndpoint.Host(ipAddress)
        let port = NWEndpoint.Port(integerLiteral:8005)
        let connection = NWConnection(host: host, port: port, using: .udp)
        connection.stateUpdateHandler = { [weak self, weak connection] state in
        
            switch state {
                
            
                case .waiting:
                    let content = "Phạm Khánh Huy say hello".data(using: .utf8)
                    connection?.send(content: content, completion: .idempotent)
                
                default:
                    break
            }

        }
        connection.start(queue: .main)
    }
    
}
