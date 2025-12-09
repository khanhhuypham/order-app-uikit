//
//  ClosedSessionHistoryViewController + extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 17/06/2025.
//

import UIKit
import RxSwift
import ObjectMapper


extension CodeAuthenticationViewController {
    

    
    func getCodeAuthenticationList(){
        appServiceProvider.rx.request(.getCodeAuthenticationList)
       .filterSuccessfulStatusCodes()
       .mapJSON().asObservable()
       .showAPIErrorToast()
       .mapObject(type: APIResponse.self).subscribe(onNext: { [self](response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let data = Mapper<AuthenticationToken>().mapArray(JSONObject: response.data) {
                
                    viewModel.dataArray.accept(data.filter{$0.status == ACTIVE && TimeUtils.getRemainingSeconds(from: $0.expire_at) > 0})
                    view_nodata.isHidden = viewModel.dataArray.value.count > 0 ? true : false
                }
            }else {

                self.showErrorMessage(content: response.message ?? "")
            }
        }).disposed(by: rxbag)
    }
    
    
    
    func changeStatusOfAuthenticationCode(id:Int){
        appServiceProvider.rx.request(.postChangeStatusOfAuthenticationCode(id: id))
       .filterSuccessfulStatusCodes()
       .mapJSON().asObservable()
       .showAPIErrorToast()
       .mapObject(type: APIResponse.self).subscribe(onNext: { [self](response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                getCodeAuthenticationList()
            }else {

                self.showErrorMessage(content: response.message ?? "")
            }
        }).disposed(by: rxbag)
    }
    
    
    func createAuthenticationCode(expire_at:String,code:String){
        appServiceProvider.rx.request(.postCreateAuthenticationCode(expire_at: expire_at, code: code))
       .filterSuccessfulStatusCodes()
       .mapJSON().asObservable()
       .showAPIErrorToast()
       .mapObject(type: APIResponse.self).subscribe(onNext: { [self](response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                getCodeAuthenticationList()
            }else {

                self.showErrorMessage(content: response.message ?? "")
            }
        }).disposed(by: rxbag)
    }
    
    
}
