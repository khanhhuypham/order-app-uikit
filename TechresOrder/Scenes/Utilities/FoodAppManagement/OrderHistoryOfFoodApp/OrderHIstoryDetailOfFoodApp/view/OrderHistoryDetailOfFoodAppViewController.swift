//
//  OrderHistoryDetailOfFoodAppViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 30/08/2024.
//

import UIKit

class OrderHistoryDetailOfFoodAppViewController: BaseViewController {
    
    var viewModel = OrderHistoryDetailOfFoodAppViewModel()
    var order = OrderHistoryOfFoodApp()

    
    @IBOutlet weak var lbl_title: UILabel!
    
    @IBOutlet weak var total_amount: UILabel!
    @IBOutlet weak var lbl_order_id: UILabel!
    @IBOutlet weak var lbl_display_id: UILabel!
    @IBOutlet weak var lbl_created_at: UILabel!
    @IBOutlet weak var lbl_driver_name: UILabel!
    @IBOutlet weak var lbl_customer_name: UILabel!
    @IBOutlet weak var lbl_customer_phone: UILabel!
    @IBOutlet weak var lbl_total_estimate: UILabel!
    
    @IBOutlet weak var lbl_vat: UILabel!
    
    @IBOutlet weak var lbl_discount: UILabel!

    @IBOutlet weak var lbl_commission_amount: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var height_of_table: NSLayoutConstraint!
    
    @IBOutlet weak var view_print: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self)
        bindTableViewAndRegisterCell()
        getOrderHistoryDetailOfFoodApp(id: order.id)
    }
    
    

    @IBAction func actionBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func actionPrintStamp(_ sender: Any) {
        
//        PrinterUtils.shared.PrintFoodAppItems(
//           presenter:self,
//           printers:Constants.printers.filter{$0.type == .stamp_of_food_app},
//           orders:[convertToFoodAppOrderModel(order:viewModel.order.value)]
//        )
        
    }
    
    
    @IBAction func actionPrintReceipt(_ sender: Any) {
                
//        PrinterUtils.shared.PrintFoodAppItems(
//           presenter:self,
//           printers:Constants.printers.filter{$0.type == .cashier_of_food_app},
//           orders:[convertToFoodAppOrderModel(order:viewModel.order.value)]
//        )
        
    }
    
    private func convertToFoodAppOrderModel(order:OrderHistoryDetailOfFoodApp) -> FoodAppOrder{
   
        var result = FoodAppOrder()
        result.driver_name = order.driver_name
        result.driver_phone = order.driver_phone
        result.channel_branch_name = ""
        result.channel_branch_address = ""
        result.channel_branch_phone = ""
        result.note = ""
        result.is_app_food = ACTIVE
        result.order_amount = order.order_amount
        result.customer_order_amount = order.customer_order_amount
        result.total_amount = order.total_amount
        result.shipping_fee = 0
        result.customer_discount_amount = order.commission_amount
        result.item_discount_amount = order.item_discount_amount
        
        result.details = order.details.map{element in
            var item = element
            item.food_options = element.food_options.map{FoodOption(name:$0.food_name, quantity:$0.quantity, price:$0.price)}
            return item
        }
        result.deliver_time = ""
        result.created_at = order.created_at
        
        return result
    }

    
//    var id = 0
//    var driver_name:String = ""
//    var driver_phone:String = ""
//    var channel_order_id:String = ""
//    var channel_order_code:String = ""
//    var channel_order_food_id = 0
//    var channel_order_food_code:APP_PARTNER = .shoppee
//
//    var channel_branch_name =  ""
//    var channel_branch_phone = ""
//    var channel_branch_address = ""
//    var note = ""
//    
//    var is_app_food = ACTIVE
//    var order_amount = 0
//    var customer_order_amount = 0
//    var total_amount = 0
//    var shipping_fee = 0
//
//    var customer_discount_amount = 0
//    var item_discount_amount = 0
//    var display_id = ""
//    
//    var details:[OrderItemOfFoodApp] = []
//    
//    var created_at = ""
//    var deliver_time = ""

    
}
