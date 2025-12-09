//
//  FoodAppPrintFormatViewController + extension + DrawSingleStamp.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 17/07/2025.
//

import UIKit

extension FoodAppPrintFormatViewController {

    
    func drawSingleStamp(printer:Printer,order:FoodAppOrder,item:OrderItemOfFoodApp,stampOrder:String) -> [UIImage] {
        //===========================
        viewModel.currentOrder.accept(order)
        //===========================
        
        var images:[UIImage] = []

        var maximumLine = 0
        
        if printer.printer_paper_size == 60{
            maximumLine = 9
        }else if printer.printer_paper_size == 50{
            maximumLine = 8
        }else if printer.printer_paper_size == 40{
            maximumLine = 9
        }else{
            maximumLine = 9
        }
        
        var totalLine = 0
        var remainingLine = 0
    
        lbl_branch_name_of_single_stamp.text = Constants.branch.name
        
        if order.channel_order_food_code == .befood{
            lbl_order_code_of_single_stamp.text = String(format:"#%@ - %@" ,order.channel_order_food_code.rawValue,order.display_id.description)
        }else{
            lbl_order_code_of_single_stamp.text = "#" + order.display_id.description
        }
        
       
        lbl_order_of_single_stamp.text = stampOrder
        lbl_item_name_of_single_stamp.text = item.food_name
        lbl_price_of_single_stamp.text = (item.total_price_addition/item.quantity).toString
        lbl_date_of_single_stamp.text = order.created_at
        
        if !item.note.isEmpty{
            lbl_note_of_single_stamp.text = String(format: "(%@)", item.note)
            lbl_note_of_single_stamp.isHidden = false
        }else{
            lbl_note_of_single_stamp.text = ""
            lbl_note_of_single_stamp.isHidden = true
        }
        
        //================================================================================================================
        underline_of_single_stamp.createDottedLine(width: 3, color: .black)
        //================================================================================================================
 
        totalLine += Utils.getNumberOfLines(label: lbl_branch_name_of_single_stamp)
        totalLine += 1
        totalLine += Utils.getNumberOfLines(label: lbl_item_name_of_single_stamp)
        totalLine += Utils.getNumberOfLines(label: lbl_note_of_single_stamp)
        totalLine += 1
        remainingLine = maximumLine - totalLine
     
        
        if !item.food_options.isEmpty{
         
            for i in stride(from: 0, to: item.food_options.count, by: remainingLine) {
                
                let block = Array(item.food_options[i..<min(i + remainingLine, item.food_options.count)])
          
                var text = block.enumerated().map { index, value in
                    return String(format:"+ %@%@" ,value.name, index == block.count - 1 ? "" : "\n")
                }.joined()

                if block.count < remainingLine {
                    
                   text += String(repeating: "\n", count: remainingLine - block.count)
                    
                }else if i >= remainingLine {
                    let emptyLineCount = remainingLine - block.count + Utils.getNumberOfLines(label: lbl_note_of_single_stamp) + Utils.getNumberOfLines(label: lbl_price_of_single_stamp)
                    text += String(repeating: "\n", count: emptyLineCount)
                }
                
                lbl_children_item_of_single_stamp.text = text
                lbl_item_name_of_single_stamp.isHidden = i >= remainingLine ? true : false
                PrinterUtils.shared.changeTextColorForTSCPrinter(printer:printer,parentView:generalView,textColor:.black,bgColor: .white)
                view.layoutIfNeeded()
                images.append(MediaUtils.captureViewScreenshot(viewToCapture: generalView) ?? UIImage())
            }
            
        }else{
            lbl_item_name_of_single_stamp.isHidden = false
            lbl_children_item_of_single_stamp.text = String(repeating: "\n", count: remainingLine-1)
            PrinterUtils.shared.changeTextColorForTSCPrinter(printer:printer,parentView:generalView,textColor:.black,bgColor: .white)
            view.layoutIfNeeded()
            images.append(MediaUtils.captureViewScreenshot(viewToCapture: generalView) ?? UIImage())
        }
        
        return images
    }
}
