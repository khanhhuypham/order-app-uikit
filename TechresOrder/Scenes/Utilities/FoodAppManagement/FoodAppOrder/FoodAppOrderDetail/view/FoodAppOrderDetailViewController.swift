//
//  OrderHistoryDetailOfFoodAppViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 30/08/2024.
//

import UIKit

class FoodAppOrderDetailViewController: BaseViewController {
        
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var total_amount: UILabel!
    @IBOutlet weak var lbl_display_id: UILabel!
    @IBOutlet weak var lbl_created_at: UILabel!
    @IBOutlet weak var lbl_driver_name: UILabel!
    @IBOutlet weak var lbl_driver_phone: UILabel!

    @IBOutlet weak var lbl_customer_name: UILabel!
    @IBOutlet weak var lbl_customer_phone: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var height_of_table: NSLayoutConstraint!
    
    @IBOutlet weak var view_print: UIView!
    
    var viewModel = FoodAppOrderDetailViewModel()
    var order = FoodAppOrder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self)
        bindTableViewAndRegisterCell()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.order.accept(order)
        setupData(order: order)
        getOrderDetail(orderId: order.id)
    }
    
    
    @IBAction func actionBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
            
}
