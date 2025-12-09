//
//  OrderItemPrintFormatViewController + extension + DrawSingleStamp.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 18/07/2025.
//

import UIKit

extension OrderItemPrintFormatViewController {

    func drawSingleStamp(printer:Printer,item:Food,order:String) -> [UIImage] {
        
        var images:[UIImage] = []
        var childrenItem:[FoodAddition] = []
        
        childrenItem.append(contentsOf: item.order_detail_additions.map {
            FoodAddition(name: $0.name, quantity: Int($0.quantity))
        })

        // Safely flatten and map option foods
        let optionFoods = item.order_detail_options.flatMap { $0.food_option_foods }
        childrenItem.append(contentsOf: optionFoods.filter{$0.status == ACTIVE}.map {
            FoodAddition(name: $0.food_name, quantity: Int($0.quantity))
        })

        lbl_branch_name_of_single_stamp.text = Constants.branch.name
        lbl_order_code_of_single_stamp.text = "#" + viewModel.order.value.id_in_branch.description
        lbl_order_of_single_stamp.text = order
        lbl_item_name_of_single_stamp.text = item.name
        lbl_children_item_of_single_stamp.text = ""
        lbl_date_of_single_stamp.text = TimeUtils.getFullCurrentDate()
        
        if item.is_sell_by_weight == ACTIVE{
            lbl_price_of_single_stamp.text = item.total_price_include_addition_foods.toString
        }else{
            lbl_price_of_single_stamp.text = (Float(item.total_price_include_addition_foods)/item.quantity).toString
        }
        
    
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
        PrinterUtils.shared.changeTextColorForTSCPrinter(printer:printer,parentView:generalView,textColor:.black,bgColor: .white)
        let maximumLine = PrinterUtils.shared.getMaximumLineOfStampForTSCPrinter(printer: printer)
        var totalLine = 0
        var remainingLine = 0
    
        totalLine += Utils.getNumberOfLines(label: lbl_branch_name_of_single_stamp)
        totalLine += 1 // number of line of id
        totalLine += Utils.getNumberOfLines(label: lbl_item_name_of_single_stamp)
        totalLine += Utils.getNumberOfLines(label: lbl_note_of_single_stamp)
        totalLine += 1 // number of line of price
        remainingLine = maximumLine - totalLine
     
        
        if !childrenItem.isEmpty{
         
            for i in stride(from: 0, to: childrenItem.count, by: remainingLine){
            
                let block = Array(childrenItem[i..<min(i + remainingLine,childrenItem.count)])
       
              
                var text = block.enumerated().map { index, value in
                    let str = String(format:"+ %@%@" ,value.name, index == block.count - 1 ? "" : "\n")
                 
                    return limitTextLines(str,font: lbl_children_item_of_single_stamp.font, width: lbl_children_item_of_single_stamp.frame.width, maxLines: 1)

                }.joined()

                if block.count < remainingLine {
                   text += String(repeating: "\n", count: remainingLine - block.count)
                }else if i >= remainingLine {
                    let emptyLineCount = remainingLine - block.count + Utils.getNumberOfLines(label: lbl_note_of_single_stamp) + Utils.getNumberOfLines(label: lbl_price_of_single_stamp)
                    text += String(repeating: "\n", count: emptyLineCount)
                }

                lbl_item_name_of_single_stamp.isHidden = i >= remainingLine ? true : false
                stack_view_of_price.isHidden = i >= remainingLine ? true : false
                lbl_children_item_of_single_stamp.text = text
                
        
                view.layoutIfNeeded()
                images.append(MediaUtils.captureViewScreenshot(viewToCapture: generalView) ?? UIImage())
            }
            
        }else{
            
            lbl_item_name_of_single_stamp.isHidden = false
            stack_view_of_price.isHidden = false
            lbl_children_item_of_single_stamp.text = String(repeating: "\n", count: remainingLine - Utils.getNumberOfLines(label: lbl_price_of_single_stamp))
            view.layoutIfNeeded()
            images.append(MediaUtils.captureViewScreenshot(viewToCapture: generalView) ?? UIImage())
            
        }
        
        return images
    }
    
    

    func limitTextLines(_ text: String,font: UIFont,width: CGFloat,maxLines: Int) -> String {
        // Paragraph setup
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .paragraphStyle: paragraphStyle
        ]
        
        // 🧠 Function to count actual visual lines
        func lineCount(for string: String) -> Int {
            let textStorage = NSTextStorage(string: string, attributes: attributes)
            let textContainer = NSTextContainer(size: CGSize(width: width, height: .greatestFiniteMagnitude))
            textContainer.lineFragmentPadding = 0
            textContainer.maximumNumberOfLines = 0 // we measure manually
            textContainer.lineBreakMode = .byWordWrapping
            
            let layoutManager = NSLayoutManager()
            layoutManager.addTextContainer(textContainer)
            textStorage.addLayoutManager(layoutManager)
            
            var lineCount = 0
            var index = 0
            
            while index < layoutManager.numberOfGlyphs {
                var lineRange = NSRange()
                layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
                index = NSMaxRange(lineRange)
                lineCount += 1
            }
            
            return lineCount
        }
        
        // ✅ Preserve explicit trailing newline
        let hasTrailingNewline = text.hasSuffix("\n")
        
        if lineCount(for: text) <= maxLines {
            return text
        }
        
        // ⚡ Binary search to truncate efficiently
        let characters = Array(text)
        var lower = 0
        var upper = characters.count
        var result = text
        
        while lower < upper {
            let mid = (lower + upper) / 2
            let substring = String(characters.prefix(mid)) + "…"
            
            if lineCount(for: substring) <= maxLines {
                result = substring
                lower = mid + 1
            } else {
                upper = mid
            }
        }
        
        // ✅ Restore newline if needed
        if hasTrailingNewline, !result.hasSuffix("\n") {
            result += "\n"
        }
        
        return result
    }



    
}
