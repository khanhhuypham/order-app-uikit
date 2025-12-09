//
//  EditEReceiptConnectionViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 05/06/2025.
//

import UIKit

class EditEInvoiceConnectionViewController: BaseViewController {
    
    @IBOutlet weak var root_view: UIView!
    @IBOutlet weak var lbl_title: UILabel!
    
    @IBOutlet weak var textfield_username: UITextField!
    @IBOutlet weak var lbl_username_err: UILabel!
    
    @IBOutlet weak var textfield_password: UITextField!
    @IBOutlet weak var btn_show_password: UIButton!
    @IBOutlet weak var lbl_password_err: UILabel!
    
    
    
    @IBOutlet weak var view_of_service_username: UIView!
    @IBOutlet weak var textfield_service_username: UITextField!
    @IBOutlet weak var lbl_service_username_err: UILabel!
    
    @IBOutlet weak var view_of_service_password: UIView!
    @IBOutlet weak var textfield_service_password: UITextField!
    @IBOutlet weak var btn_show_service_password: UIButton!
    @IBOutlet weak var lbl_service_password_err: UILabel!
    
    
    @IBOutlet weak var textfield_tax_code: UITextField!
    @IBOutlet weak var lbl_tax_code_err: UILabel!
    
    @IBOutlet weak var textfield_invoice_code: UITextField!
    @IBOutlet weak var lbl_invoice_denominator_err: UILabel!
    
    @IBOutlet weak var textfield_e_sign: UITextField!
    @IBOutlet weak var lbl_e_sign_err: UILabel!
    
    @IBOutlet weak var textfield_url_validation: UITextField!
    @IBOutlet weak var lbl_url_validation_err: UILabel!
    
    
    @IBOutlet weak var btn_auto_export_bill: UIButton!
    
    
    @IBOutlet weak var btn_export_bill_for_order: UIButton!
    @IBOutlet weak var btn_export_bill_for_app_food: UIButton!
    @IBOutlet weak var btn_export_bill_for_all: UIButton!
    @IBOutlet weak var btn_apply_before_discount: UIButton!
    @IBOutlet weak var btn_assign_branch: UIButton!
    
    
    
    var viewModel = EditEInvoiceConnecionViewModel()
    var invoice = EInvoicePartner()
    var completion:(() -> Void)? = nil
    var alreadyUnassignBranch:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapData()
        dLog(invoice)
        viewModel.invoice.accept(EInvoicePartnerDetail(invoice: invoice))
        getPartnerInvoiceConnectionDetail()
    }
    
    
    @IBAction func actionEdit(_ sender: Any) {
        isInvoiceValid.take(1).subscribe(onNext: { [self] isValid in
            
            if isValid {
                
                if viewModel.invoice.value.id > 0{
                    
                    updatePartnerInvoiceConnection(invoice: viewModel.invoice.value)
                    
                }else{
                    
                    createPartnerInvoiceConnection(branch_id: Constants.branch.id, invoice: viewModel.invoice.value)
                    
                }
            }
            
        }).disposed(by: rxbag)
    }
    
    @IBAction func actionShowPassword(_ sender: Any) {
                
        textfield_password.becomeFirstResponder()
        textfield_password.isSecureTextEntry = !textfield_password.isSecureTextEntry
        btn_show_password.setImage(UIImage(named:textfield_password.isSecureTextEntry ? "icon_eye_pass" : "eye"), for: .normal)

    }
    
    @IBAction func actionShowServicePassword(_ sender: Any) {
                
        textfield_service_password.becomeFirstResponder()
        textfield_service_password.isSecureTextEntry = !textfield_service_password.isSecureTextEntry
        btn_show_service_password.setImage(UIImage(named:textfield_service_password.isSecureTextEntry ? "icon_eye_pass" : "eye"), for: .normal)

    }
    
    
    
    
    @IBAction func actionAutoExportBill(_ sender: Any) {
        
        var invoice = viewModel.invoice.value
        
        invoice.is_auto_export_third_party = invoice.is_auto_export_third_party == ACTIVE ? DEACTIVE : ACTIVE
        
        viewModel.invoice.accept(invoice)
        
        btn_auto_export_bill.setImage(
            UIImage(named: invoice.is_auto_export_third_party == ACTIVE ? "icon-radio-checked" : "icon-radio-uncheck"),
            for: .normal
        )
        
    }
    
    
    
    @IBAction func actionChooseType(_ sender: UIButton) {
        
        var invoice = viewModel.invoice.value
        
        if sender.tag == 3 {
            invoice.apply_order_types = [1,2]
        }else{
            invoice.apply_order_types = [sender.tag]
        }
        setupData(data:invoice)
        
        viewModel.invoice.accept(invoice)
    }
    
    
    @IBAction func actionApplyBeforeDiscount(_ sender: Any) {
        var invoice = viewModel.invoice.value
        
        invoice.apply_discount = invoice.apply_discount == ACTIVE ? DEACTIVE : ACTIVE
        
        viewModel.invoice.accept(invoice)
        
        btn_apply_before_discount.setImage(
            UIImage(named: invoice.apply_discount == ACTIVE ? "icon-radio-checked" : "icon-radio-uncheck"),
            for: .normal
        )
        
    }
    
    
    
    
    @IBAction func actionAssignBranch(_ sender: Any) {
        
        if !alreadyUnassignBranch{
            unassignBranchForEInvoicePartner(invoice: viewModel.invoice.value)
        }
        
       
    }
    
    
    
    

}
