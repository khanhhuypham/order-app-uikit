//
//  FoodAppPrintFormatViewController + extension + DrawKitchenticket.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 31/07/2025.
//

import UIKit

extension FoodAppPrintFormatViewController {
    
    
    func drawKitchenTicket(order:FoodAppOrder){
        //===========================
        viewModel.currentOrder.accept(order)
        //===========================
        
        let title = order.is_cancel_order == ACTIVE
        ? String(format:"PHIẾU HUỶ\n%@",order.channel_order_food_code.displayOrderCode(displayId: order.display_id))
        : order.channel_order_food_code.displayOrderCode(displayId: order.display_id)
        
//        if order.is_cancel_order == ACTIVE{
//            lbl_title_of_kitchen_ticket.attributedText = Utils.setAttributesForLabel(
//              label: lbl_title_of_kitchen_ticket,
//              attributes: [
//                (str:"PHIẾU HUỶ",properties:[.font:UIFont.systemFont(ofSize: 36, weight: .bold)]),
//            ])
//        }else{
//            lbl_title_of_kitchen_ticket.attributedText = nil
//            lbl_title_of_kitchen_ticket.text = title
//        }
        
        
        lbl_title_of_kitchen_ticket.text = title
        lbl_restaurant_name_of_kitchen_ticket.text = String(format: "Tên quán: %@", order.channel_branch_name)
        lbl_restaurant_phone_of_kitchen_ticket.text = String(format: "SĐT quán: %@", order.channel_branch_phone)
        lbl_note_of_kitchen_ticket.text = String(format: "Ghi chú: %@", order.note)
        lbl_date_of_kitchen_ticket.text = String(
            format:order.is_cancel_order == DEACTIVE ? "Ngày: %@ %@" : "Ngày huỷ: %@ %@" ,
            TimeUtils.getToday(),
            TimeUtils.getDateTimeNow()
        )
        
        lbl_note_of_kitchen_ticket.isHidden = order.note.isEmpty
        tableView_of_kitchen_ticket.reloadData()
        
        if order.details.count > 0{
            height_of_table_of_kitchen_ticket.constant = 200
            for i in (0...order.details.count - 1){
                
                let cell = tableView_of_kitchen_ticket.cellForRow(at: IndexPath(row: i, section: 0))
                height_of_table_of_kitchen_ticket.constant += CGFloat(cell?.frame.height ?? 0)
                tableView_of_kitchen_ticket.layoutIfNeeded()
            }
            height_of_table_of_kitchen_ticket.constant -= 200
        }else{
            height_of_table_of_kitchen_ticket.constant = 0
        }
        
        PrinterUtils.shared.changeTextColorForPOSPrinter(view:generalView,textColor:textColor,bgColor: .black)
        tableView_of_kitchen_ticket.addBorder(toEdges: [.top], color: textColor, thickness: 1)
        view.layoutIfNeeded()

    }

}
