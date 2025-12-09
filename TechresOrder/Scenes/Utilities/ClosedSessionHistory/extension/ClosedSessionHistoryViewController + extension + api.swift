//
//  ClosedSessionHistoryViewController + extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 17/06/2025.
//

import UIKit
import RxSwift
import ObjectMapper


extension ClosedSessionHistoryViewController {
    
    func getClosedSessionHistory(){
        viewModel.getClosedSessionHistory().subscribe(onNext: { [self](response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let dataFromServer = Mapper<WorkingSessionResponse>().map(JSONObject: response.data) {
                   

                    var apiParameter = viewModel.APIParameter.value
              
                    if(dataFromServer.data.count > 0 && !apiParameter.isGetFullData){
                        var array = viewModel.dataArray.value
                        array.append(contentsOf: dataFromServer.data)
                        viewModel.dataArray.accept(array)
                    }
                    tableView.reloadData()
                    
                    apiParameter.isGetFullData = dataFromServer.data.count < apiParameter.limit ? true: false
                    apiParameter.isAPICalling = false
                    viewModel.APIParameter.accept(apiParameter)
                 
                    view_nodata.isHidden = viewModel.dataArray.value.count > 0 ? true : false
                }
            }else {

                self.showErrorMessage(content: response.message ?? "")
            }
        }).disposed(by: rxbag)
    }
    
    
}


extension ClosedSessionHistoryViewController:dateTimePickerDelegate{
    func callbackToGetDateTime(didSelectDate: Date) {
     
        var parameter = viewModel.APIParameter.value
        let result = convertDateToDateString(date: didSelectDate)
        
        switch viewModel.dateType.value{
            case 1:
                if isDateValid(fromDateStr: result, toDateStr: parameter.to_date){
                    parameter.from_date = result
                    lbl_from_date.text = result
                    viewModel.APIParameter.accept(parameter)
                }else {
                    showWarningMessage(content: "Ngày bắt đầu không được lớn hơn ngày kết thúc")
                    lbl_from_date.text = parameter.from_date
                }
                break

            case 2:
                if isDateValid(fromDateStr: parameter.from_date, toDateStr:result){
                    parameter.to_date = result
                    viewModel.APIParameter.accept(parameter)
                    lbl_to_date.text = result
                }else {
                    showWarningMessage(content: "Ngày kết thúc không được bé hơn ngày bắt đầu")
                    lbl_to_date.text = parameter.to_date
                }
                break

            default:
                break
            
        }
        
        viewModel.clearDataAndCallAPI()
    }
    
    
    private func isDateValid(fromDateStr:String, toDateStr:String) -> Bool{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let fromDate = dateFormatter.date(from: fromDateStr) ?? Date()
        let toDate = dateFormatter.date(from: toDateStr) ?? Date()
        return fromDate.isSmallerThan(toDate)
    }
    
    
    private func convertDateStringToDate(dateString:String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.date(from: dateString)
        return date ?? Date()
    }
    
    private func convertDateToDateString(date:Date) -> String{
        // Create Date Formatter
        let dateFormatter = DateFormatter()

        // Set Date Format
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return  dateFormatter.string(from: date)
        
    }
    
}

