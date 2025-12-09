//
//  PrinterUtils + extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 05/07/2024.
//

import UIKit
import RxSwift
import ObjectMapper

extension PrinterUtils{
    
    func checkValidPrinters(presenter:UIViewController) -> Bool{
        var valid = true
        let wifiPrinters = Constants.printers.filter{$0.type == .chef || $0.type == .bar || $0.type == .cashier || $0.type == .cashier_of_food_app}
        let tscPrinters = Constants.printers.filter{$0.type == .stamp || $0.type == .stamp_of_food_app}.filter{$0.is_have_printer == ACTIVE}
        
        for wifi in wifiPrinters{
            for tsc in tscPrinters{
                if wifi.printer_ip_address == tsc.printer_ip_address{
                    valid = false
                    presenter.showAleartViewwithTitle(
                       "Cảnh bảo",
                       message: String(format:"Địa chỉ IP của máy In %@ không được trùng với những loại máy In wifi %@", tsc.name,wifi.name),
                       withAutoDismiss: true
                   )
                }
            }
        }

        return valid
    }
    
    
    func insertViewControllerBeneathCurrent(_ newVC: UIViewController, under parentVC: UIViewController) {
        
        if let tabBarController = parentVC.tabBarController {
            tabBarController.addChild(newVC)
            tabBarController.view.insertSubview(newVC.view, belowSubview: tabBarController.tabBar)
            newVC.beginAppearanceTransition(true, animated: false)
            newVC.endAppearanceTransition()
            newVC.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                newVC.view.topAnchor.constraint(equalTo: tabBarController.view.topAnchor),
                newVC.view.leadingAnchor.constraint(equalTo: tabBarController.view.leadingAnchor),
                newVC.view.trailingAnchor.constraint(equalTo: tabBarController.view.trailingAnchor),
                newVC.view.bottomAnchor.constraint(equalTo: tabBarController.view.bottomAnchor)
            ])
            
            newVC.didMove(toParent: tabBarController)

        }else{
            parentVC.addChild(newVC)
            parentVC.view.insertSubview(newVC.view, at: 0)
            newVC.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                newVC.view.topAnchor.constraint(equalTo: parentVC.view.topAnchor),
                newVC.view.leadingAnchor.constraint(equalTo: parentVC.view.leadingAnchor),
                newVC.view.trailingAnchor.constraint(equalTo: parentVC.view.trailingAnchor),
                newVC.view.bottomAnchor.constraint(equalTo: parentVC.view.bottomAnchor)
            ])
            newVC.didMove(toParent: parentVC)
        }

    }
    
    
}

//MARK: print for orders that are at restaurant
extension PrinterUtils{
    
    func PrintInvoice(
        presenter:UIViewController,
        order:OrderDetail,
        bankAccount:BankAccount,
        printer:Printer,
        printMode:PRINT_MODE,
        completetHandler:(()->Void)? = nil
    ){
        
        let vc = ReceiptPrintFormatViewController()
        vc.printer = printer
        vc.order = order
        vc.bankAccount = bankAccount
        vc.printMode = printMode
        vc.view.backgroundColor = .clear
        if printMode == .printForeground{
            
            vc.completeHandler = {
                let printForegroundVC = ForegroundPrintProcessViewController()
                printForegroundVC.view.backgroundColor = .clear
                printForegroundVC.modalPresentationStyle = .overFullScreen
                printForegroundVC.completeHandler = completetHandler
                presenter.present(printForegroundVC, animated: true, completion: nil)
            }
            
        }else{
            vc.completeHandler = completetHandler
        }
        
        insertViewControllerBeneathCurrent(vc,under: presenter)
    }
    

    func PrintItems(presenter:UIViewController,order:OrderDetail,printItem:[Food], printers:[Printer],printMode:PRINT_MODE,completetHandler:(()->Void)? = nil){
        let vc = OrderItemPrintFormatViewController()
        vc.printers = printers
        vc.order = order
        vc.printItem = printItem
        vc.printMode = printMode
        if printMode == .printForeground{
            
            vc.completeHandler = {
                let printForegroundVC = ForegroundPrintProcessViewController()
                printForegroundVC.view.backgroundColor = .clear
                printForegroundVC.modalPresentationStyle = .overFullScreen
                printForegroundVC.completeHandler = completetHandler
                presenter.present(printForegroundVC, animated: true, completion: nil)
            }
            
        }else{
            vc.completeHandler = completetHandler
        }
        insertViewControllerBeneathCurrent(vc,under: presenter)
    }
    
}


//MARK: print for food app
extension PrinterUtils{
    
    func PrintFoodAppItems(
        presenter:UIViewController,
        isCustomerOrder:Bool = false,
        onlyPrintKitchenTicket:Bool = false,
        printers:[Printer],
        orders:[FoodAppOrder],
        printMode:PRINT_MODE,
        completetHandler:(()->Void)? = nil
    ){
        let printerArray = printers.filter{$0.is_have_printer == ACTIVE}
        
        if printerArray.isEmpty{
            presenter.showConfirmationDialog("Cảnh báo",message: "Không tìm thấy máy in đang hoạt động cho chức năng in stamp của Food App")
            (completetHandler ?? {})()
        }else if (orders.isEmpty){
            presenter.showAleartViewwithTitle("Cảnh báo", message:"Đơn hàng rỗng nên không thể in",withAutoDismiss: true)
            (completetHandler ?? {})()
        }else{
            
            let vc = FoodAppPrintFormatViewController()
            vc.isCustomerOrder = isCustomerOrder
            vc.onlyPrintKitchenTicket = onlyPrintKitchenTicket
            vc.printers = printerArray
            vc.orders = orders
            vc.printMode = printMode
            vc.view.backgroundColor = .clear
     
            if printMode == .printForeground && !printerArray.isEmpty{
                
                vc.completeHandler = {
                    let printForegroundVC = ForegroundPrintProcessViewController()
                    printForegroundVC.view.backgroundColor = .clear
                    printForegroundVC.modalPresentationStyle = .overFullScreen
                    printForegroundVC.completeHandler = completetHandler
                    presenter.present(printForegroundVC, animated: true, completion: nil)
                }
                
            }else{
                vc.completeHandler = completetHandler
            }
            
            insertViewControllerBeneathCurrent(vc,under: presenter)
        }
    }
    
    
    func getDummyData() -> [FoodAppOrder]{
     
        var jsonString = """
            [
                {
                       "customer_name": "Lê Thanh Thảo",
                       "phone": "0379050084",
                       "address": "Saigon Trade Center - Cổng Nguyễn Du, 37 Tôn Đức Thắng, P.Bến Nghé, Q.1, Hồ Chí Minh",
                       "note": "",
                       "details": [
                           {
                               "food_options": [
                                   {
                                       "id": 5456816,
                                       "name": "Mặc định Không Bún",
                                       "price": 0,
                                       "quantity": 1
                                   }
                               ],
                               "id": 66388,
                               "food_id": "6692243",
                               "food_name": "MUA 1 TẶNG 1 COMBO NEM NƯỚNG",
                               "quantity": 1,
                               "price": 85000,
                               "note": "",
                               "total_price_addition": 85000,
                               "is_allow_print_stamp": 0,
                               "restaurant_kitchen_place_id": 0
                           },
                           {
                               "food_options": [
                                   {
                                       "id": 5456816,
                                       "name": "Mặc định Không Bún",
                                       "price": 0,
                                       "quantity": 1
                                   }
                               ],
                               "id": 66389,
                               "food_id": "8983095",
                               "food_name": "Phần Đặc Biệt - Gấp Đôi Nem Nướng",
                               "quantity": 1,
                               "price": 99000,
                               "note": "",
                               "total_price_addition": 99000,
                               "is_allow_print_stamp": 0,
                               "restaurant_kitchen_place_id": 0
                           },
                           {
                               "food_options": [
                                   {
                                       "id": 5456816,
                                       "name": "Mặc định Không Bún",
                                       "price": 0,
                                       "quantity": 1
                                   }
                               ],
                               "id": 66390,
                               "food_id": "501442",
                               "food_name": "Phần 1 Người - Nem Nướng D'ran - Healthy & Fresh",
                               "quantity": 1,
                               "price": 89000,
                               "note": "",
                               "total_price_addition": 89000,
                               "is_allow_print_stamp": 0,
                               "restaurant_kitchen_place_id": 0
                           }
                       ],
                       "cancel_comment": "",
                       "channel_branch_id": "14731",
                       "driver_name": "Lê Văn Dương Linh",
                       "driver_avatar": "",
                       "driver_phone": "0931407162",
                       "channel_order_food_name": "Befood",
                       "channel_order_food_code": "BEF",
                       "channel_order_id": "54193126",
                       "channel_order_code": "",
                       "is_app_food": 1,
                       "display_id": "126",
                       "order_amount": 273000,
                       "discount_amount": 30450,
                       "customer_order_amount": 169000,
                       "customer_discount_amount": 70000,
                       "channel_branch_name": "NEM NƯỚNG D'RAN - Since 1968 - Trương Quyền",
                       "channel_branch_address": "38 Trương Quyền, Võ Thị Sáu, Quận 3, Hồ Chí Minh",
                       "channel_branch_phone": "019008225",
                       "item_discount_amount": 70000,
                       "deliver_time": "30/07/2025 11:49",
                       "is_scheduled_order": 0,
                       "is_printed": 0,
                       "is_cancel_printed": 0,
                       "is_cancel_order": 0,
                       "id": 179215,
                       "order_id": 0,
                       "total_amount": 172550,
                       "created_at": "30/07/2025 10:50",
                       "shipping_fee": 0,
                       "channel_order_food_id": 4,
                       "tracking_url": "",
                       "restaurant_third_party_delivery_id": 0
                   },
             
            ]
            
        """
        
        return Mapper<FoodAppOrder>().mapArray(JSONString: jsonString) ?? []
     
    }
    

}




