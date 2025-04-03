//
//  EnterInformationViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 29/03/2025.
//

import UIKit

class EnterInformationViewController: BaseViewController {
    
    @IBOutlet weak var root_view: UIView!
    @IBOutlet weak var textfield_name: UITextField!
    @IBOutlet weak var lbl_error_name: UILabel!
    
    @IBOutlet weak var textfield_phone: UITextField!
    @IBOutlet weak var lbl_error_phone: UILabel!
    
    @IBOutlet weak var textview_address: UITextView!
    @IBOutlet weak var lbl_error_address: UILabel!
    
    @IBOutlet weak var btnConfirm: UIButton!
    
    var orderId = 0
    var customer = Customer()
    var completion:(() -> Void)?
    var viewModel = EnterInformationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self)
        mapDataAndValidate()
        // Do any additional setup after loading the view.
    }



    @IBAction func actionCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func actionConfirm(_ sender: Any) {
        viewModel.customer.value.id > 0
        ? unassignCustomerFromOrder(orderId: viewModel.orderId.value)
        : createCustomer()
    }
    
   
}
