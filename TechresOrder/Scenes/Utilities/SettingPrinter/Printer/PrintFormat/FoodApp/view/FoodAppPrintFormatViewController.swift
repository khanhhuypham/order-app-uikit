//
//  FoodAppPrintFormatViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 21/08/2024.
//

import UIKit
import JonAlert
import RxSwift
class FoodAppPrintFormatViewController:UIViewController {
    
    @IBOutlet weak var progressView: UIView!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var lbl_already_printed_number: UILabel!
    
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var generalView: UIView!
    
    @IBOutlet weak var view_of_invoice: UIStackView!
    
    @IBOutlet weak var lbl_partner_of_invoice: UILabel!
    
    @IBOutlet weak var lbl_type_of_invoice: UILabel!
    
    @IBOutlet weak var lbl_restaurant_name: UILabel!
    
    @IBOutlet weak var lbl_address: UILabel!
    
    @IBOutlet weak var lbl_cumtomer_service: UILabel!
    
    @IBOutlet weak var lbl_order_id: UILabel!
    
    @IBOutlet weak var lbl_driver_name: UILabel!
    
    @IBOutlet weak var lbl_driver_phone: UILabel!
    
    @IBOutlet weak var lbl_employee_name: UILabel!
    
    @IBOutlet weak var lbl_date: UILabel!
    
    @IBOutlet weak var lbl_created_at: UILabel!
    
    @IBOutlet weak var lbl_delivery_time: UILabel!
    
    @IBOutlet weak var lbl_note: UILabel!
    

    @IBOutlet weak var tableView_of_invoice: UITableView!
    @IBOutlet weak var height_of_table_of_invoice: NSLayoutConstraint!

    //===================Tổng hoá đơn==================
    @IBOutlet weak var view_of_order_amount: UIView!
    @IBOutlet weak var lbl_title_of_total_amount: UILabel!
    @IBOutlet weak var lbl_order_amount: UILabel!
    
    //===================restaurant discount==================
    @IBOutlet weak var view_of_item_discount_amount: UIView!
    @IBOutlet weak var lbl_item_discount_amount: UILabel!

    //=====================Payment======================================================
    @IBOutlet weak var view_of_total_amount: UIView!
    @IBOutlet weak var lbl_total_amount: UILabel!
    
    //=========================greeting==================================
    @IBOutlet weak var view_of_copy_right: UIView!
    
    
    //=========================== Kitchen Ticket  =====================================
    @IBOutlet weak var view_of_kitchen_ticket: UIStackView!
    
    @IBOutlet weak var lbl_title_of_kitchen_ticket: UILabel!
    
    @IBOutlet weak var lbl_restaurant_name_of_kitchen_ticket: UILabel!
    
    @IBOutlet weak var lbl_restaurant_phone_of_kitchen_ticket: UILabel!
    
    @IBOutlet weak var lbl_date_of_kitchen_ticket: UILabel!

    @IBOutlet weak var lbl_note_of_kitchen_ticket: UILabel!
    
    @IBOutlet weak var tableView_of_kitchen_ticket: UITableView!
    
    @IBOutlet weak var height_of_table_of_kitchen_ticket: NSLayoutConstraint!
    

    //=========================== Print stamp 30x20 using TSC Printer =====================================
    @IBOutlet weak var view_of_double_stamp: UIView!
    
    @IBOutlet weak var lbl_stamp1_item_name: UILabel!
    
    @IBOutlet weak var lbl_stamp1_order: UILabel!
    
    @IBOutlet weak var underline_of_stamp1: UIView!
    
    @IBOutlet weak var lbl_stamp1_order_id: UILabel!
    
    @IBOutlet weak var lbl_stamp1_date: UILabel!

    @IBOutlet weak var lbl_stamp1_children_item: UILabel!
    
    @IBOutlet weak var lbl_stamp1_note: UILabel!
    
    @IBOutlet weak var lbl_stamp1_price: UILabel!
 
    //==============================================================================================
    
    @IBOutlet weak var lbl_stamp2_item_name: UILabel!
    
    @IBOutlet weak var lbl_stamp2_order: UILabel!
    
    @IBOutlet weak var underline_of_stamp2: UIView!
    
    @IBOutlet weak var lbl_stamp2_order_id: UILabel!
    
    @IBOutlet weak var lbl_stamp2_date: UILabel!

    @IBOutlet weak var lbl_stamp2_children_item: UILabel!
    
    @IBOutlet weak var lbl_stamp2_note: UILabel!
    
    @IBOutlet weak var lbl_stamp2_price: UILabel!

    //========================= print stamp 40x30, 50x30, 60x40 using TSC Printer ===========================
    @IBOutlet weak var view_of_single_stamp: UIView!
    @IBOutlet weak var lbl_branch_name_of_single_stamp: UILabel!
    @IBOutlet weak var lbl_order_code_of_single_stamp: UILabel!
    @IBOutlet weak var lbl_order_of_single_stamp: UILabel!
    @IBOutlet weak var underline_of_single_stamp: UIView!
    @IBOutlet weak var lbl_item_name_of_single_stamp: UILabel!
    @IBOutlet weak var lbl_children_item_of_single_stamp: UILabel!
    @IBOutlet weak var lbl_note_of_single_stamp: UILabel!
    @IBOutlet weak var lbl_date_of_single_stamp: UILabel!
    @IBOutlet weak var lbl_price_of_single_stamp: UILabel!
    
    
    var printers:[Printer] = []
    var orders:[FoodAppOrder] = []
    var isCustomerOrder:Bool = true
    var onlyPrintKitchenTicket:Bool = false
    var printMode:PRINT_MODE = .printForeground
    
    var viewModel = FoodAppPrintFormatViewModel()
    var completeHandler:(()->Void)? = nil
    let textColor:UIColor = .systemGray4
    let rxbag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self)
        bindTableViewAndRegisterCell()
        view.isHidden = true
        view.backgroundColor = .clear
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.orders.accept(orders)

        if onlyPrintKitchenTicket{
            reprint()
        }else{
            printFoodAppOrder()
        }

        finishAndRemoveViewController()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    
    private func reprint(){

        for order in viewModel.orders.value{
            
            for printer in printers {

                var cloneOrder = order
                
                switch printer.type{
    
                    case .stamp_of_food_app:
                        printStamp(printer: printer,order: order)
                        break
    
                    case .cashier_of_food_app:
                        cloneOrder.details.removeAll(where: {$0.restaurant_kitchen_place_id != 0}) // if item has printer id == 0, it'll be printed by cashier printer
                        printKitchenTicket(printer:printer,order: cloneOrder)
                        break
                    
                    default:
                        cloneOrder.details.removeAll(where: {$0.restaurant_kitchen_place_id != printer.id})
                        printKitchenTicket(printer:printer,order: cloneOrder)
                        break
                }
            }
        }
    }
    
    private func printFoodAppOrder(){

        for order in viewModel.orders.value{
            
            for printer in printers {

                var cloneOrder = order
                
                switch printer.type{
    
                    case .stamp_of_food_app:
                        printStamp(printer: printer,order: order)
                        break
    
                    case .cashier_of_food_app:
                        printInvoice(printer:printer,order: order)
                        cloneOrder.details.removeAll(where: {$0.restaurant_kitchen_place_id != 0}) // if item has printer id == 0, it'll be printed by cashier printer
                        printKitchenTicket(printer:printer,order: cloneOrder)
                        break
                    
                    default:
                        cloneOrder.details.removeAll(where: {$0.restaurant_kitchen_place_id != printer.id})
                        printKitchenTicket(printer:printer,order: cloneOrder)
                        break
                }
            }
        }
    }

        
    private func finishAndRemoveViewController(){
        DispatchQueue.main.async {
            self.completeHandler?()
            self.willMove(toParent: nil)
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }
    
   
}
