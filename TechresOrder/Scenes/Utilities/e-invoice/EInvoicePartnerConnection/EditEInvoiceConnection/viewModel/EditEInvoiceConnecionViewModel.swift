//
//  EditEInvoiceConnecionViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 05/06/2025.
//

import UIKit
import RxSwift
import RxRelay


class EditEInvoiceConnecionViewModel: NSObject {
    
    private(set) weak var view: EditEInvoiceConnectionViewController?

    public var invoice : BehaviorRelay<EInvoicePartnerDetail> = BehaviorRelay(value: EInvoicePartnerDetail())
    
    func bind(view: EditEInvoiceConnectionViewController){
        self.view = view
    }
    
}



extension EditEInvoiceConnecionViewModel {

    func getPartnerInvoiceConnectionDetail() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.getPartnerInvoiceConnectionDetail(partner_electronic_invoice_type: invoice.value.partner_electronic_invoice_type))
       .filterSuccessfulStatusCodes()
       .mapJSON().asObservable()
       .showAPIErrorToast()
       .mapObject(type: APIResponse.self)
    }
    
    
    func updatePartnerInvoiceConnection(invoice:EInvoicePartnerDetail) -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.postUpdatePartnerInvoiceConnection(invoice: invoice))
       .filterSuccessfulStatusCodes()
       .mapJSON().asObservable()
       .showAPIErrorToast()
       .mapObject(type: APIResponse.self)
    }
    
    
    func createPartnerInvoiceConnection(branch_id:Int,invoice:EInvoicePartnerDetail) -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.postCreatePartnerInvoiceConnection(branch_id: branch_id, invoice: invoice))
       .filterSuccessfulStatusCodes()
       .mapJSON().asObservable()
       .showAPIErrorToast()
       .mapObject(type: APIResponse.self)
    }
    
    func assignBranchForEInvoicePartner(invoice:EInvoicePartnerDetail) -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.postAssignBranchForEInvoicePartner(invoice: invoice))
       .filterSuccessfulStatusCodes()
       .mapJSON().asObservable()
       .showAPIErrorToast()
       .mapObject(type: APIResponse.self)
    }
    
    func unassignBranchForEInvoicePartner(invoice:EInvoicePartnerDetail) -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.postUnassignBranchForEInvoicePartner(invoice: invoice))
       .filterSuccessfulStatusCodes()
       .mapJSON().asObservable()
       .showAPIErrorToast()
       .mapObject(type: APIResponse.self)
    }
    

}


