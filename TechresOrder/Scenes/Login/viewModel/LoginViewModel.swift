//
//  LoginViewModel.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 12/01/2023.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa
class LoginViewModel : BaseViewModel{

    private(set) weak var view: LoginViewController?
    private var router: LoginRouter?

    var deviceRequest = BehaviorRelay<DeviceRequest>(value: DeviceRequest(appType: Utils.getAppType(), deviceUID:Utils.getUDID(), pushToken: ManageCacheObject.getPushToken()))
  

    func bind(view: LoginViewController, router: LoginRouter){
        self.view = view
        self.router = router
        self.router?.setSourceView(self.view)
    }
    

}
extension LoginViewModel{
    
    func registerDeviceUDID() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.regisDevice(deviceRequest: deviceRequest.value))
            .filterSuccessfulStatusCodes()
            .mapJSON().asObservable()
            .showAPIErrorToast()
            .mapObject(type: APIResponse.self)
       }
    
    
    
}
