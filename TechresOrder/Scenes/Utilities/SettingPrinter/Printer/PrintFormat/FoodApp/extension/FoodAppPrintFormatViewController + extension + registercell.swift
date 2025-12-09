//
//  FoodAppPrintFormatViewController + extension + registercell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 21/08/2024.
//

import UIKit

extension FoodAppPrintFormatViewController {


    func bindTableViewAndRegisterCell(){
        registerCell()
        bindDataForTableOfInvoice()
        bindDataForTableOfKitchenTicket()
    }
    
    private func registerCell() {
        let invoiceCell = UINib(nibName: "FoodAppInvoiceTableViewCell", bundle: .main)
        tableView_of_invoice.register(invoiceCell, forCellReuseIdentifier: "FoodAppInvoiceTableViewCell")
        tableView_of_invoice.rowHeight = UITableView.automaticDimension
        tableView_of_invoice.isScrollEnabled = false
        
        
        let kitchenTicketCell = UINib(nibName: "FoodAppKitchenTicketTableViewCell", bundle: .main)
        tableView_of_kitchen_ticket.register(kitchenTicketCell, forCellReuseIdentifier: "FoodAppKitchenTicketTableViewCell")
        tableView_of_kitchen_ticket.rowHeight = UITableView.automaticDimension
        tableView_of_kitchen_ticket.isScrollEnabled = false
    
    }
    
    private func bindDataForTableOfInvoice() {
        viewModel.currentOrder.map{$0.details}.bind(to: tableView_of_invoice.rx.items(cellIdentifier: "FoodAppInvoiceTableViewCell", cellType: FoodAppInvoiceTableViewCell.self)){(row, item, cell) in

            cell.isCancel = self.viewModel.currentOrder.value.is_cancel_order == ACTIVE
            cell.data = item
            
            if row < (self.viewModel.currentOrder.value.details.count - 1){
                self.createDashedLine(parentView:cell.underlineView, color: .systemGray, strokeLength: 10, gapLength: 2, width: 2)
            }
            PrinterUtils.shared.changeTextColorForPOSPrinter(view: cell.contentView,textColor:self.textColor,bgColor:.black)
        }.disposed(by: rxbag)
    }
    
    private func bindDataForTableOfKitchenTicket() {
        viewModel.currentOrder.map{$0.details}.bind(to: tableView_of_kitchen_ticket.rx.items(cellIdentifier: "FoodAppKitchenTicketTableViewCell", cellType: FoodAppKitchenTicketTableViewCell.self)){(row, item, cell) in
            
            cell.isCancel = self.viewModel.currentOrder.value.is_cancel_order == ACTIVE
            cell.data = item
            PrinterUtils.shared.changeTextColorForPOSPrinter(view: cell.contentView,textColor:self.textColor,bgColor:.black)
        }.disposed(by: rxbag)
    }
    
    

    func createDashedLine(parentView:UIView, color: UIColor, strokeLength: NSNumber, gapLength: NSNumber, width: CGFloat) {
        let shapeLayer = CAShapeLayer()
        let path = CGMutablePath()
        
        let point1 = CGPoint(x: 0, y: parentView.bounds.height)
        let point2 = CGPoint(x: parentView.bounds.width, y: parentView.bounds.height)
        
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = width
        shapeLayer.lineDashPattern = [strokeLength, gapLength]
        
        path.addLines(between: [point1, point2])
        shapeLayer.path = path
        parentView.layer.addSublayer(shapeLayer)

    }
    
}
