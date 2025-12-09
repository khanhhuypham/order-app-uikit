//
//  LoginOfflineViewController + extension + API.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 12/8/25.
//

import UIKit
import JonAlert
import RxSwift
import ObjectMapper

extension LoginOnlineViewController{
    
    
    func getSessions(){
        viewModel.getSessions().subscribe(onNext: { (response) in
        
            if(response.code == RRHTTPStatusCode.ok.rawValue){
               
                self.getConfig(session: response.data as! String)
            }else{
                dLog(response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại")
            }
          
        }).disposed(by: rxbag)
    }
    
    func getConfig(session:String){
        viewModel.getConfig().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let config = Mapper<Config>().map(JSONObject: response.data){
                    var obj_config = config
                    obj_config.api_key = String(format: "%@:%@", session, obj_config.api_key)
                    
                    ManageCacheObject.setConfig(obj_config)
                    // call api login here...
                    self.viewModel.isLoginUsingCode.value ? self.loginUsingCode() : self.login()
                    
                }
            }else{
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại", duration: 2.0)
                dLog(response.message ?? "")
            }
        }).disposed(by: rxbag)
    }
    
    
    func login(){
        // Get data from Server
        viewModel.login().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
  
                if let account = Mapper<Account>().map(JSONObject: response.data){
                    
                    if(!Utils.checkRoleOrderFood(permission: account.permissions)){
                        JonAlert.showError(message: "Bạn chưa có quyền gọi món. Vui lòng liên hệ quản lý để được cấp quyền.", duration: 3.0)
                        return
                    }
                
                    ManageCacheObject.saveCurrentUser(account)
                    ManageCacheObject.setAccessToken(account.access_token)
                    ManageCacheObject.setPassword(self.text_field_password.text!)
                    
                    
                    ManageCacheObject.setSavedLoginInfo(
                        SavedLoginInfor(
                            ip_address: Constants.savedLoginInfor.ip_address,
                            restaurant_name: account.restaurant_name,
                            username: account.username
                        )
                    )


                    
                    var brand = Brand.init()
                    brand.id = account.restaurant_brand_id
                    brand.name = account.brand_name
                    brand.restaurant_id = account.restaurant_id
                    ManageCacheObject.saveCurrentBrand(brand)

            
                    SettingUtils.getSetting(
                        brandId: account.restaurant_brand_id,
                        branchId: account.branch_id,
                        closureForFoodCourt: {
                            self.presentModalDialogConfirmViewController()
                        },
                        closureChangePassword: account.is_enable_change_password == DEACTIVE
                        ? { self.presentDialogRequiredSetPassword(currentPassword: self.viewModel.password.value)}
                        : nil
                        ,
                        completion: {
                            self.loadMainView()
                            self.showSuccessMessage(content:  "Đăng nhập thành công",duration: 1.5)
                            FoodAppPrintUtils.shared.performPrintOrderForFoodAppOnBackground()
                            ManageCacheObject.setEnvironment(environmentMode)// save environment mode
                        },
                        incompletion:self.clearCache
                        
                    )
              
                }

            }else{
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ. Vui lòng thử lại", duration: 2.0)
                dLog(response.message ?? "")

            }
        }).disposed(by: rxbag)
    }
    
    
    func loginUsingCode(){
        // Get data from Server
        viewModel.loginUsingCode().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
  
                if let account = Mapper<Account>().map(JSONObject: response.data){
                    
                    if(!Utils.checkRoleOrderFood(permission: account.permissions)){
                        JonAlert.showError(message: "Bạn chưa có quyền gọi món. Vui lòng liên hệ quản lý để được cấp quyền.", duration: 3.0)
                        return
                    }
                
                    ManageCacheObject.saveCurrentUser(account)
                    ManageCacheObject.setAccessToken(account.access_token)
         
                    ManageCacheObject.setPassword(self.text_field_password.text!)
                    
                    
                    ManageCacheObject.setSavedLoginInfo(
                        SavedLoginInfor(
                            ip_address: Constants.savedLoginInfor.ip_address,
                            restaurant_name: account.restaurant_name,
                            username: account.username
                        )
                    )

                    
                    var brand = Brand.init()
                    brand.id = account.restaurant_brand_id
                    brand.name = account.brand_name
                    brand.restaurant_id = account.restaurant_id
                    ManageCacheObject.saveCurrentBrand(brand)

           
                    SettingUtils.getSetting(
                        brandId: account.restaurant_brand_id,
                        branchId: account.branch_id,
                        closureForFoodCourt: {
                            self.presentModalDialogConfirmViewController()
                        },
                        closureChangePassword: account.is_enable_change_password == DEACTIVE
                        ? { self.presentDialogRequiredSetPassword(currentPassword: self.viewModel.password.value)}
                        : nil
                        ,
                        completion: {
                            self.loadMainView()
                            self.showSuccessMessage(content:  "Đăng nhập thành công")
                            FoodAppPrintUtils.shared.performPrintOrderForFoodAppOnBackground()
                            
                        },
                        incompletion:self.clearCache
                        
                    )
                    
                }

            }else{
  
                self.showErrorMessage(content: response.message ?? "")
                dLog(response.message ?? "")

            }
            
            
        }).disposed(by: rxbag)
    }
    

}

