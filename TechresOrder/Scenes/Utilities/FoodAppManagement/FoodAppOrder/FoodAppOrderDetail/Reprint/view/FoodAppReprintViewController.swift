//
//  FoodAppReprintViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 3/12/25.
//

import UIKit

class FoodAppReprintViewController: BaseViewController {
    @IBOutlet weak var root_view: UIView!
    @IBOutlet weak var icon_checkbox_of_kitchen_ticket: UIImageView!
    @IBOutlet weak var btn_reprint_kitchen_ticket: UIButton!
    
    @IBOutlet weak var icon_checkbox_of_stamp: UIImageView!
    @IBOutlet weak var btn_reprint_stamp: UIButton!
    
    var order:FoodAppOrder = FoodAppOrder()
    var item:OrderItemOfFoodApp = OrderItemOfFoodApp()
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOutSide(_:)))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
        // Do any additional setup after loading the view.
        actionChooseReprintKitchenTicket(btn_reprint_kitchen_ticket)
    }
    
 

    @objc func handleTapOutSide(_ gesture:UIGestureRecognizer){
        let tapLocation = gesture.location(in: root_view)
        if !root_view.bounds.contains(tapLocation){
           dismiss(animated: true)
        }
    }
    
    @IBAction func actionBack(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func actionChooseReprintKitchenTicket(_ sender: UIButton) {
        btn_reprint_kitchen_ticket.isSelected.toggle()
        icon_checkbox_of_kitchen_ticket.image = UIImage(named: btn_reprint_kitchen_ticket.isSelected ? "check_2" : "un_check_2")
    }
    
    @IBAction func actionChooseReprintStamp(_ sender: UIButton) {
        btn_reprint_stamp.isSelected.toggle()
        icon_checkbox_of_stamp.image = UIImage(named: btn_reprint_stamp.isSelected ? "check_2" : "un_check_2")
    }
    
    
    @IBAction func actionConfirm(_ sender: Any) {
        
        getReprintItemsOfFoodApp(channel_order_id: order.id)
               
    }

}
