//
//  ReceiptPrintFormatViewController + extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 05/04/2024.
//

import UIKit

extension ReceiptPrintFormatViewController {

    func registerCell(){
        
        if permissionUtils.GPBH_1{
            let cell = UINib(nibName: "Bill3TableViewCell", bundle: .main)
            tableView.register(cell, forCellReuseIdentifier: "Bill3TableViewCell")
        }else {
            
            switch Constants.bill_type{
                case .bill1:
                    let cell = UINib(nibName: "Bill1TableViewCell", bundle: .main)
                    tableView.register(cell, forCellReuseIdentifier: "Bill1TableViewCell")
                case .bill2:
                    let cell = UINib(nibName: "Bill2TableViewCell", bundle: .main)
                    tableView.register(cell, forCellReuseIdentifier: "Bill2TableViewCell")
                case .bill3:
                    let cell = UINib(nibName: "Bill3TableViewCell", bundle: .main)
                    tableView.register(cell, forCellReuseIdentifier: "Bill3TableViewCell")
                case .bill4:
                    let cell = UINib(nibName: "Bill4TableViewCell", bundle: .main)
                    tableView.register(cell, forCellReuseIdentifier: "Bill4TableViewCell")
            
            }
        }
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isScrollEnabled = false
        tableView.dataSource = self
//        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if keyPath == "contentSize" {
//            if let newValue = change?[.newKey] as? NSValue {
//                let newSize = newValue.cgSizeValue
//                self.height_of_table.constant = newSize.height
//            }
//        }
//    }
    
    
    	
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return order?.order_details.count ?? 0
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if permissionUtils.GPBH_1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Bill3TableViewCell", for: indexPath) as! Bill3TableViewCell
            cell.data = order?.order_details[indexPath.row]
            PrinterUtils.shared.changeTextColorForPOSPrinter(view: cell.contentView,textColor:textColor,bgColor:.black)
            return cell

        }else{

            switch Constants.bill_type{
                case .bill1:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "Bill1TableViewCell", for: indexPath) as! Bill1TableViewCell
                    cell.data = order?.order_details[indexPath.row]
                    PrinterUtils.shared.changeTextColorForPOSPrinter(view: cell.contentView,textColor:textColor,bgColor:.black)
                    return cell

                case .bill2:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "Bill2TableViewCell", for: indexPath) as! Bill2TableViewCell
                    cell.data = order?.order_details[indexPath.row]
                    PrinterUtils.shared.changeTextColorForPOSPrinter(view: cell.contentView,textColor:textColor,bgColor:.black)
                    return cell

                case .bill3:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "Bill3TableViewCell", for: indexPath) as! Bill3TableViewCell
                    cell.data = order?.order_details[indexPath.row]
                
                    if indexPath.row < ((order?.order_details.count ?? 0) - 1) {
                        createDashedLine(parentView:cell.underlineView, color: .systemGray, strokeLength: 10, gapLength: 2, width: 2)
                    }
                    PrinterUtils.shared.changeTextColorForPOSPrinter(view: cell.contentView,textColor:textColor,bgColor:.black)
                    return cell

                case .bill4:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "Bill4TableViewCell", for: indexPath) as! Bill4TableViewCell
                    cell.data = order?.order_details[indexPath.row]
                
                    if indexPath.row < ((order?.order_details.count ?? 0) - 1) {
                        createDashedLine(parentView:cell.underlineView, color: .systemGray, strokeLength: 10, gapLength: 2, width: 2)
                    }
                    PrinterUtils.shared.changeTextColorForPOSPrinter(view: cell.contentView,textColor:textColor,bgColor:.black)
                    return cell
            }
        }
        
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
    
    func createLine(view: UIView,color: UIColor, width: CGFloat) {

        let point1 = CGPoint(x: 0, y: view.bounds.height)
        let point2 = CGPoint(x: view.bounds.width, y: view.bounds.height)
        
        let shapeLayer = CAShapeLayer()
        let path = CGMutablePath()
        
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = width
        shapeLayer.lineDashPattern = nil // No dash, just solid line
        
        path.addLines(between: [point1, point2])
        shapeLayer.path = path
        view.layer.addSublayer(shapeLayer)
    }
    
}

