//
//  EInvoiceManagementViewController + extension + api.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 07/06/2025.
//

import UIKit
import ObjectMapper


extension EInvoiceManagementViewController{
        
    func getInvoiceList(){
        viewModel.getInvoiceList().subscribe(onNext: { [self](response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let dataFromServer = Mapper<EInvoiceResponse>().map(JSONObject: response.data) {
                   

                    var apiParameter = viewModel.APIParameter.value
              
                    if(dataFromServer.data.count > 0 && !apiParameter.isGetFullData){
                        var array = viewModel.invoiceArray.value
                        array.append(contentsOf: dataFromServer.data)
                        viewModel.invoiceArray.accept(array)
                    }
                    tableView.reloadData()
                    
                    apiParameter.isGetFullData = dataFromServer.data.count < apiParameter.limit ? true: false
                    btnShowMore.isHidden = apiParameter.isGetFullData ? true : false
                
                    viewModel.APIParameter.accept(apiParameter)
                 
                    view_nodata.isHidden = viewModel.invoiceArray.value.count > 0 ? true : false
                }
            }else {

                self.showErrorMessage(content: response.message ?? "")
            }
        }).disposed(by: rxbag)
    }
    
    
}
