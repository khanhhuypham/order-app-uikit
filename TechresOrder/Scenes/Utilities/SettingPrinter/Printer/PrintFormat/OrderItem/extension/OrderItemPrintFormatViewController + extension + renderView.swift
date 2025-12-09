//
//  OrderItemPrintFormatViewController + extension + render + print.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 23/12/2023.
//

import UIKit
import RealmSwift

extension OrderItemPrintFormatViewController {
    
    func renderKitchenTicket(printer:Printer,order:OrderDetail,printItems:[Food]) -> UIImage{
        view_of_print_food.isHidden = false
        view_of_single_stamp.isHidden = true
        view_of_double_stamp.isHidden = true
        drawKitchenTicket(printer:printer,order:order,printItems:printItems)
        return MediaUtils.captureViewScreenshot(viewToCapture: generalView) ?? UIImage()
    }
    
    func renderDoubleStamp(printer:Printer,order:OrderDetail,printItems:[Food]) -> UIImage{
        view_of_print_food.isHidden = true
        view_of_double_stamp.isHidden = false
        view_of_single_stamp.isHidden = true
        drawDoubleStamp(printer:printer,order:order,printItems:printItems)
        return MediaUtils.captureViewScreenshot(viewToCapture: generalView) ?? UIImage()
    }
    
    func renderSingleStamp(printer:Printer,item:Food,order:String) -> [UIImage]{
        view_of_print_food.isHidden = true
        view_of_double_stamp.isHidden = true
        view_of_single_stamp.isHidden = false
        return drawSingleStamp(printer:printer,item: item,order:order)
    }
    
    
}

