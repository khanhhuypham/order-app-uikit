//
//  EReceiptConnectionViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 05/06/2025.
//

import UIKit

class EReceiptConnectionViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = EReceiptConnectionViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self)
        registerCell()
        getRestaurantPartnerInvoice()
        
    }

    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    

}
