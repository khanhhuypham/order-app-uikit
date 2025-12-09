//
//  FoodAppPrintFormatViewController + extension + renderView.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 21/08/2024.
//

import UIKit


extension FoodAppPrintFormatViewController {
    
    func renderInvoice(printer:Printer,order:FoodAppOrder) -> UIImage{
        view_of_invoice.isHidden = false
        view_of_kitchen_ticket.isHidden = true
        view_of_double_stamp.isHidden = true
        view_of_single_stamp.isHidden = true
        drawInvoice(order: order)
        return MediaUtils.captureViewScreenshot(viewToCapture: generalView) ?? UIImage()
    }
    
    func renderKitchenTicket(order:FoodAppOrder) -> UIImage{
        view_of_invoice.isHidden = true
        view_of_kitchen_ticket.isHidden = false
        view_of_double_stamp.isHidden = true
        view_of_single_stamp.isHidden = true
        drawKitchenTicket(order: order)
        return MediaUtils.captureViewScreenshot(viewToCapture: generalView) ?? UIImage()
    }

  
    func renderSingleStamp(printer:Printer,order:FoodAppOrder,item:OrderItemOfFoodApp,stampOrder:String) -> [UIImage]{
        view_of_invoice.isHidden = true
        view_of_kitchen_ticket.isHidden = true
        view_of_double_stamp.isHidden = true
        view_of_single_stamp.isHidden = false
        return drawSingleStamp(printer:printer,order:order,item: item,stampOrder:stampOrder)
    }
    

    func renderDoubleStamp(printer:Printer,printItems:[OrderItemOfFoodApp] = [],infor:(total:Int,nth:Int) = (0,0)) -> UIImage{
        view_of_invoice.isHidden = true
        view_of_kitchen_ticket.isHidden = true
        view_of_double_stamp.isHidden = false
        view_of_single_stamp.isHidden = true
        drawDoubleStamp(printer:printer,printItems:printItems,infor:infor)
        return MediaUtils.captureViewScreenshot(viewToCapture: generalView) ?? UIImage()
    }
    
    
}




    

