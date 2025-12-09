//
//  OrderItemPrintFormatViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 22/12/2023.
//

import UIKit
import RxSwift

class OrderItemPrintFormatViewController: BaseViewController {
    

    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var generalView: UIView!
    
//===========================print food using POS Printer=====================================
    
    @IBOutlet weak var view_of_print_food: UIStackView!
    
    @IBOutlet weak var lbl_title: UILabel!
    
    @IBOutlet weak var lbl_item_name: UILabel!
    
    @IBOutlet weak var lbl_ordered_quantity: UILabel!
    
    @IBOutlet weak var lbl_used_quantity: UILabel!
    
    @IBOutlet weak var lbl_returned_quantity: UILabel!
    
    @IBOutlet weak var lbl_date: UILabel!
    
    @IBOutlet weak var lbl_order_id: UILabel!
    
    @IBOutlet weak var lbl_table_name: UILabel!
    
    @IBOutlet weak var lbl_note: UILabel!
    
    @IBOutlet weak var lbl_employee_name: UILabel!
    
    @IBOutlet weak var view_of_table: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var height_of_table: NSLayoutConstraint!
    
//===========================print stamp using TSC Printer=====================================
    
    @IBOutlet weak var view_of_double_stamp: UIStackView!
    
    @IBOutlet weak var view_of_stamp_1: UIView!
    
    @IBOutlet weak var lbl_stamp1_date: UILabel!
    
    @IBOutlet weak var lbl_stamp1_order_id: UILabel!
    
    @IBOutlet weak var lbl_stamp1_item_name: UILabel!
    
    @IBOutlet weak var lbl_stamp1_children_item: UILabel!
    
    @IBOutlet weak var lbl_stamp1_note: UILabel!
    
    @IBOutlet weak var lbl_stamp1_price: UILabel!
    
    @IBOutlet weak var view_of_stamp_2: UIView!
    
    @IBOutlet weak var lbl_stamp2_date: UILabel!
    
    @IBOutlet weak var lbl_stamp2_order_id: UILabel!
    
    @IBOutlet weak var lbl_stamp2_item_name: UILabel!
    
    @IBOutlet weak var lbl_stamp2_children_item: UILabel!
    
    @IBOutlet weak var lbl_stamp2_note: UILabel!
    
    @IBOutlet weak var lbl_stamp2_price: UILabel!
    
//=======================================================================================================================================

    @IBOutlet weak var view_of_single_stamp: UIView!
    
    @IBOutlet weak var stack_view_of_single_stamp: UIStackView!
    @IBOutlet weak var lbl_branch_name_of_single_stamp: UILabel!
    @IBOutlet weak var lbl_order_code_of_single_stamp: UILabel!
    @IBOutlet weak var lbl_order_of_single_stamp: UILabel!
    @IBOutlet weak var underline_of_single_stamp: UIView!
    @IBOutlet weak var lbl_item_name_of_single_stamp: UILabel!
    @IBOutlet weak var lbl_children_item_of_single_stamp: UILabel!
    @IBOutlet weak var lbl_note_of_single_stamp: UILabel!
    
    @IBOutlet weak var stack_view_of_price: UIStackView!
    @IBOutlet weak var lbl_date_of_single_stamp: UILabel!
    @IBOutlet weak var lbl_price_of_single_stamp: UILabel!
   
//=======================================================================================================================================

    var printers:[Printer] = []
    var order = OrderDetail.init()
    var printItem:[Food] = []
    var printMode:PRINT_MODE = .printForeground
    var viewModel = OrderItemPrintFormatViewModel()
    var completeHandler:(()->Void)? = nil
    let textColor:UIColor = .systemGray4

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self)
        bindTableViewAndRegisterCell()
        view.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.order.accept(order)

        for printer in printers {
          
            if (printer.type == .chef || printer.type == .bar){
                
                let printItems = self.printItem.filter{$0.restaurant_kitchen_place_id == printer.id}
               
                switch printer.connection_type{
                    
                    case .blueTooth:
//                        printBLE(printer: printer, order: order, printItems: printItems)
                        break
                    
                    case .wifi:
                        printPOS(printer: printer, order: order, printItems: printItems)
                        break
                    
                    default:
                        break
                }
            }else if printer.type == .stamp{
                dLog(self.printItem)
                let printItems = self.printItem.filter{$0.is_allow_print_stamp == ACTIVE && $0.TSCPrinter_id == printer.id}

                printTSC(printer:printer,order:order,printItems:printItems)
                
            }
            
        }
        
        finishAndRemoveViewController()
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
        
    @IBAction func actionBack(_ sender: Any) {
        dismiss(animated: true)
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



