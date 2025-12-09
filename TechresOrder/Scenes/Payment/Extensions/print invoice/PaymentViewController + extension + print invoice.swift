//
//  PaymentRebuildViewController + Extension + print.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 24/10/2023.
//

import UIKit
import JonAlert
import ObjectMapper

extension PaymentRebuildViewController {
    
    
    //MARK: Print receipt
    func printInvoice(orderDetail:OrderDetail, bankAccount:BankAccount) {
        var order = orderDetail
        let completeHandler = {
            self.navigationController?.viewControllers.removeAll(where: { (vc) -> Bool in
                return vc.isKind(of: OrderDetailViewController.self) ? true : false
            })
            self.viewModel.makePopViewController()
        }
        
        if var buffet = order.buffet, buffet.id > 0{
          
            if let position =  order.order_details.firstIndex(where: {$0.id == buffet.id}){
                order.order_details.remove(at: position)
            }
            
            if buffet.ticketChildren.count > 0{
                
                for ticket in buffet.ticketChildren{
                    
                    order.order_details.append(OrderItem(
                          name: String(format:"%@ (%@)",buffet.buffet_ticket_name,ticket.name),
                          price:ticket.price,
                          quantity: Float(ticket.quantity),
                          total_price: Float(ticket.total_amount),
                          discount_percent: ticket.discountPercent,
                          discount_amount: ticket.discountAmount,
                          discount_price: ticket.discountPrice
                    ))
                }
                
            }else{
                
                order.order_details.append(OrderItem(
                    name: buffet.buffet_ticket_name,
                    price:buffet.adult_price,
                    quantity: Float(buffet.adult_quantity),
                    total_price: Float(buffet.total_adult_amount),
                    discount_percent: buffet.adult_discount_percent,
                    discount_amount: buffet.adult_discount_amount,
                    discount_price: buffet.adult_discount_price
                ))
                
            }
        }
        
        PrinterUtils.shared.PrintInvoice(
            presenter: self,
            order: order,
            bankAccount: bankAccount,
            printer: Constants.printers.filter{$0.type == .cashier}.first ?? Printer(),
            printMode: .printForeground,
            completetHandler: {
                
                if self.orderHistoryScreen{
                    self.updateReprintNumber()
                }else{
                    completeHandler()
                }
                
            }
        )
    }

}






extension PaymentRebuildViewController {
    
    
    
    
    func updateReprintNumber() {
        //CALL API COMPLETED ORDER
        viewModel.updateReprintNumber().subscribe(onNext: { [self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                
                var order = viewModel.order.value
                order.number_of_reprint += 1
                viewModel.order.accept(order)
            }
            
        }).disposed(by: rxbag)
    }
    
    
    
}




