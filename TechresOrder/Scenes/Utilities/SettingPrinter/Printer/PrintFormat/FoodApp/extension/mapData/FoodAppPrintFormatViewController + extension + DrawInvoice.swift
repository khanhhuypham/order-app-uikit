//
//  FoodAppPrintFormatViewController + extension + MapDataForPrintReceipt.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 21/08/2024.
//

import UIKit


extension FoodAppPrintFormatViewController {
    
    func drawInvoice(order:FoodAppOrder){
        //===========================
        viewModel.currentOrder.accept(order)
        //===========================
        lbl_partner_of_invoice.text = order.channel_order_food_code.displayOrderCode(displayId: order.display_id)
        lbl_restaurant_name.text = order.channel_branch_name
        lbl_type_of_invoice.text = order.is_cancel_order == DEACTIVE ? "HÓA ĐƠN THANH TOÁN" :"HÓA ĐƠN HUỶ"
        lbl_order_id.text = String(format: "Đơn hàng: #%@",order.channel_order_id)
        lbl_address.text = String(format: "Địa chỉ: %@", order.channel_branch_address)
        lbl_cumtomer_service.text = String(format: "CSKH: %@", order.channel_branch_phone)
        lbl_driver_name.text = String(format: "Tên tài xế: %@", order.driver_name)
        lbl_driver_phone.text = String(format: "SĐT tài xế: %@", order.driver_phone)
        lbl_employee_name.text = String(format: "Thu ngân: %@", Constants.user.name)
        lbl_date.text = String(
            format:order.is_cancel_order == DEACTIVE ? "Ngày giờ: %@ %@" : "Thời gian huỷ: %@ %@" ,
            TimeUtils.getToday(),
            TimeUtils.getDateTimeNow()
        )
        lbl_created_at.text = String(format: "Thời gian đặt hàng: %@", order.created_at)
        lbl_delivery_time.text = String(format: "Dự kiến giao hàng lúc: %@", order.deliver_time)
        lbl_note.text = String(format: "Ghi chú: %@", order.note)
     
        lbl_delivery_time.isHidden = order.deliver_time.isEmpty
        lbl_note.isHidden = order.note.isEmpty
        
        
        lbl_order_amount.attributedText = nil
        lbl_item_discount_amount.attributedText = nil
        lbl_total_amount.attributedText = nil
        
        //========================= Payment =====================

        var total_amount = 0
        if isCustomerOrder{
            lbl_title_of_total_amount.text = "Tổng tạm tính"
            total_amount = order.customer_order_amount
        }else{
            lbl_title_of_total_amount.text = "Tổng hoá đơn"
            total_amount = order.total_amount
        }

        
        let color = NSAttributedString.Key.foregroundColor
        let crossLine = NSAttributedString.Key.strikethroughStyle
        let value = NSNumber(value: NSUnderlineStyle.single.rawValue)
        
        if order.is_cancel_order == ACTIVE{
            
            lbl_order_amount.attributedText = Utils.setAttributesForLabel(
              label: lbl_order_amount,
              attributes: [
                  (str:order.order_amount.toString,properties:[color:ColorUtils.red_600(),crossLine:value]),
            ])
            
            lbl_item_discount_amount.attributedText = Utils.setAttributesForLabel(
              label: lbl_item_discount_amount,
              attributes: [
                  (str:order.customer_discount_amount.toString,properties:[color:ColorUtils.red_600(),crossLine:value]),
            ])
            
            lbl_total_amount.attributedText = Utils.setAttributesForLabel(
              label: lbl_total_amount,
              attributes: [
                  (str:total_amount.toString,properties:[color:ColorUtils.red_600(),crossLine:value]),
            ])
            
        }else{
            lbl_order_amount.text = order.order_amount.toString
            lbl_item_discount_amount.text = order.customer_discount_amount.toString
            lbl_total_amount.text = total_amount.toString
        }
        
        
        
        view_of_order_amount.isHidden = order.is_cancel_order == ACTIVE ? true : false
        view_of_item_discount_amount.isHidden = order.is_cancel_order == ACTIVE ? true : false
        view_of_total_amount.isHidden = order.is_cancel_order == ACTIVE ? true : false

        tableView_of_invoice.reloadData()
        
        if order.details.count > 0{
            height_of_table_of_invoice.constant = 200
            for i in (0...order.details.count - 1){
                
                let cell = tableView_of_invoice.cellForRow(at: IndexPath(row: i, section: 0))
                height_of_table_of_invoice.constant += CGFloat(cell?.frame.height ?? 0)
                tableView_of_invoice.layoutIfNeeded()
            }
            height_of_table_of_invoice.constant -= 200
        }else{
            height_of_table_of_invoice.constant = 0
        }
        
        PrinterUtils.shared.changeTextColorForPOSPrinter(view:generalView,textColor:textColor,bgColor: .black)

        tableView_of_invoice.addBorder(toEdges: [.top,.bottom], color: textColor, thickness: 1)
        view_of_copy_right.addBorder(toEdges: [.top], color: textColor, thickness: 1)
        
        view.layoutIfNeeded()
    }
    
    
  
}
