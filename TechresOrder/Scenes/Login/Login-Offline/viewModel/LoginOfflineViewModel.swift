//
//  LoginOfflineViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 12/8/25.
//

import UIKit
import RxRelay
import RxSwift


class LoginOfflineViewModel: NSObject {

    private(set) weak var view: LoginOfflineViewController?
    
    var ipAddress = BehaviorRelay<String>(value: "")
    var username = BehaviorRelay<String>(value: "")
    var password = BehaviorRelay<String>(value: "")
    var restaurantName = BehaviorRelay<String>(value: "")
    var code = BehaviorRelay<String>(value: "")
    var deviceRequest = BehaviorRelay<DeviceRequest>(value: DeviceRequest.init()!)
    
    var isLoginFace = BehaviorRelay<Bool>(value: false)
    var isLoginUsingCode = BehaviorRelay<Bool>(value: false)

    


    func bind(view: LoginOfflineViewController){
        self.view = view
    
    }
}

extension LoginOfflineViewModel{
    // get data from server by rxswift with alamofire
    func getSessions() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.sessions)
//               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
       }
    

    
    func getConfig() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.config(restaurant_name: restaurantName.value))
//               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    
    func login() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.login(username: username.value, password: password.value))
            .filterSuccessfulStatusCodes()
            .mapJSON().asObservable()
            .showAPIErrorToast()
            .mapObject(type: APIResponse.self)
    }



    func loginUsingCode() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.loginUsingCode(
            code: code.value,
            device_uid: Utils.getUDID(),
            device_name: Utils.getDeviceName(),
            app_type: Utils.getAppType()
        ))
            .filterSuccessfulStatusCodes()
            .mapJSON().asObservable()
            .showAPIErrorToast()
            .mapObject(type: APIResponse.self)
    }
    
}

