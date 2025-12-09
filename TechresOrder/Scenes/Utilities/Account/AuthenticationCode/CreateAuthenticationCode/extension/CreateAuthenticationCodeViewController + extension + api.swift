//
//  ClosedSessionHistoryViewController + extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 17/06/2025.
//

import UIKit
import RxSwift
import ObjectMapper


extension CreateAuthenticationTokenViewController {
    

    
    func changeStatusOfAuthenticationCode(id:Int){
        appServiceProvider.rx.request(.postChangeStatusOfAuthenticationCode(id: id))
       .filterSuccessfulStatusCodes()
       .mapJSON().asObservable()
       .showAPIErrorToast()
       .mapObject(type: APIResponse.self).subscribe(onNext: { [self](response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                self.showSuccessMessage(content: "Huỷ thành công")
                actionBack("")
            }else {

                self.showErrorMessage(content: response.message ?? "")
            }
        }).disposed(by: rxbag)
    }
    
    
}
