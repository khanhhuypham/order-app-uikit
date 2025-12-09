//
//  ClosedWorkingSessionViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 22/02/2023.
//

import UIKit
import ObjectMapper
import RxSwift
import JonAlert

extension ClosedWorkingSessionViewController {
    
    
    func checkWorkingSession(){
        viewModel.checkWorkingSessions().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
              
                if let workingSession  = Mapper<CheckWorkingSession>().map(JSONObject: response.data){
                    
                    self.viewModel.checkWorkingSession.accept(workingSession)
                }

            }
        }).disposed(by: rxbag)
  }
    
    
    
    
    func workingSessionValue(){
            viewModel.workingSessionValue().subscribe(onNext: { (response) in
                if(response.code == RRHTTPStatusCode.ok.rawValue){
                    if let workingSessionValue = Mapper<WorkingSessionValue>().map(JSONObject: response.data) {
                        self.mapData(workingSessionValue: workingSessionValue)
                    }
                }else{
                    dLog(response.message ?? "")
                    JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình thêm món.", duration: 2.0)
                }
             
            }).disposed(by: rxbag)
        }
    
    func closeWorkingSession(){
            viewModel.closeWorkingSession().subscribe(onNext: { (response) in
                if(response.code == RRHTTPStatusCode.ok.rawValue){

                    JonAlert.showSuccess(message: "Chốt ca thành công", duration: 2.0)
                    
                    self.viewModel.makePopViewController()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                        self.delegate?.callBackReload()
                    }
                    
                }else{
                    dLog(response.message ?? "")
                    JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình thêm món.", duration: 2.0)

                }
             
            }).disposed(by: rxbag)
        }
}
