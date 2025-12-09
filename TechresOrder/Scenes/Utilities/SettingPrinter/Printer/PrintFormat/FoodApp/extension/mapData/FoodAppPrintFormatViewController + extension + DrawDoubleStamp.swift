//
//  FoodAppPrintFormatViewController + extension + MapDataForPrintFood.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 21/08/2024.
//

import UIKit

extension FoodAppPrintFormatViewController {
    
    
    func drawDoubleStamp(printer:Printer,printItems:[OrderItemOfFoodApp],infor:(total:Int,nth:Int)){
                
        let limitLine = 2
        lbl_stamp1_item_name.numberOfLines = limitLine
        lbl_stamp2_item_name.numberOfLines = limitLine
        lbl_stamp1_children_item.numberOfLines = limitLine
        lbl_stamp2_children_item.numberOfLines = limitLine
        lbl_stamp1_note.numberOfLines = 1
        lbl_stamp2_note.numberOfLines = 1
    
        if printItems.count == 2{
            
            drawStamp1(printer:printer,item: printItems[0],nth: String(format: "%d/%d", infor.nth + 1,infor.total))
            drawStamp2(printer:printer,item: printItems[1],nth: String(format: "%d/%d", infor.nth + 2,infor.total))
            
        }else if printItems.count == 1{
            lbl_stamp2_note.isHidden = true
            lbl_stamp2_order.text = ""
            lbl_stamp2_order_id.text = ""
            lbl_stamp2_item_name.text = ""
            lbl_stamp2_children_item.text = ""
            lbl_stamp2_note.text = ""
            lbl_stamp2_price.text = ""
            lbl_stamp2_date.text = ""
            drawStamp1(printer:printer,item: printItems[0],nth: String(format: "%d/%d", infor.nth + 1,infor.total))
        }
        
        PrinterUtils.shared.changeTextColorForTSCPrinter(printer:printer,parentView:generalView,textColor:.black,bgColor: .white)
        view.layoutIfNeeded()
    }
    
    
    private func drawStamp1(printer:Printer,item:OrderItemOfFoodApp,nth:String) {

        var text = ""
        
        item.food_options.enumerated().forEach{(i,value) in
            
            if i == 0{
                text += String(format: " + %@, ",  value.food_name)
            }else if i == item.food_options.count - 1{
                text += String(format: "%@",  value.food_name)
            }else{
                text += String(format: "%@, ",  value.food_name)
            }
                      
            
        }
        lbl_stamp1_order.text = nth
        lbl_stamp1_note.isHidden = item.note.isEmpty ? true : false
        lbl_stamp1_children_item.isHidden = text.isEmpty ? true : false
        lbl_stamp1_item_name.text = item.food_name
        lbl_stamp1_children_item.text = text
        
        
        //================================================================================================================
        underline_of_stamp1.createDottedLine(width: printer.printer_paper_size == 50 ? 3 : 1, color: .black)
        //================================================================================================================
        
        lbl_stamp1_order_id.text = "#" + String(viewModel.currentOrder.value.display_id)
        lbl_stamp1_note.text = String(format: "(%@)", item.note)
        lbl_stamp1_price.text = "Giá: " + (item.total_price_addition/item.quantity).toString
        lbl_stamp1_date.text = viewModel.currentOrder.value.created_at
        

    }
    
    
    private func drawStamp2(printer:Printer,item:OrderItemOfFoodApp,nth:String) {
        var text = ""

        item.food_options.enumerated().forEach{(i,value) in

            if i == 0{
                text += String(format: " + %@,",  value.food_name)
            }else if i == item.food_options.count - 1{
                text += String(format: "%@",value.food_name)
            }else{
                text += String(format: "%@,",value.food_name)
            }

        }
        
        lbl_stamp2_order.text = nth
        lbl_stamp2_note.isHidden = item.note.isEmpty ? true : false
        lbl_stamp2_children_item.isHidden = text.isEmpty ? true : false
        
        
        lbl_stamp2_order_id.text = "#" + String(viewModel.currentOrder.value.id)
        
        //================================================================================================================
        underline_of_stamp2.createDottedLine(width: printer.printer_paper_size == 50 ? 3 : 1, color: .black)
        //================================================================================================================
        
        lbl_stamp2_item_name.text = item.food_name
        lbl_stamp2_children_item.text = text
        lbl_stamp2_note.text = String(format: "(%@)", item.note)
        
        lbl_stamp2_price.text = "Giá: " + (item.total_price_addition/item.quantity).toString
        lbl_stamp2_date.text = viewModel.currentOrder.value.created_at
    }

}
