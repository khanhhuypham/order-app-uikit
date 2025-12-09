//
//  ReprintViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 16/9/25.
//

import UIKit

class ReprintViewController: BaseViewController {
    
    @IBOutlet weak var root_view: UIView!
    @IBOutlet weak var icon_checkbox_of_kitchen_ticket: UIImageView!
    @IBOutlet weak var btn_reprint_kitchen_ticket: UIButton!
    
    @IBOutlet weak var icon_checkbox_of_stamp: UIImageView!
    @IBOutlet weak var btn_reprint_stamp: UIButton!
    
    var order:OrderDetail = OrderDetail()
    var item:OrderItem = OrderItem()
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOutSide(_:)))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
        // Do any additional setup after loading the view.
        firstSetup()
    }
    
 
    
    private func firstSetup(){
        
        if order.channel_order_id == 0{
            
            if item.is_allow_print_stamp == 1{
                icon_checkbox_of_stamp.image = UIImage(named: "un_check_2")
                btn_reprint_stamp.isEnabled = true
            }else{
                icon_checkbox_of_stamp.image = UIImage(named: "icon-check-disable")
                btn_reprint_stamp.isEnabled = false
            }
            
        }
        
      
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
        
        if order.channel_order_id > 0 {
            getReprintItemsOfFoodApp(channel_order_id: order.channel_order_id)
        }else{
            getReprintItems(orderId: order.id)
        }
               
    }
    

}
