//
//  PrinterUtils.swift
//  Techres - Order
//
//  Created by pham khanh huy on 31/03/2022.
//  Copyright © 2022 vn.techres.sale. All rights reserved.
//

import UIKit
import JonAlert
import RealmSwift
import RxSwift
import ObjectMapper
class PrinterUtils:NSObject {

    let rxbag = DisposeBag()
    var POSPrinterUtility = CustomPOSPrinter.shared()
    let TSCPrinterUtility = TSCPrinter.shared()
    var BLEPrinterUtility = BLEPrinter.shared()
    
    
    
    let backGroundQueue = DispatchQueue.global(qos: .userInteractive)
    
    var workItems:[WIFIWorkItem] = []
    var tscWorkItem:TSCWorkItem? = nil
    
    
    var printTimer: Timer?
    var deleteTimer: Timer?
    
    
    static let shared: PrinterUtils = {
        let printerUtils = PrinterUtils()
        return printerUtils
    }()

    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self,selector:#selector(connectPrinterSuccessfully(_:)),name: NSNotification.Name(PRINTER_NOTIFI.BACKGROUND_CONNECT_SUCCESS),object: nil)
        NotificationCenter.default.addObserver(self,selector:#selector(connectPrinterFail(_:)),name: NSNotification.Name(PRINTER_NOTIFI.BACKGROUND_CONNECT_FAIL),object: nil)
        NotificationCenter.default.addObserver(self,selector:#selector(printSuccessFully(_:)),name: NSNotification.Name(PRINTER_NOTIFI.BACKGROUND_PRINT_SUCCESS),object: nil)
        NotificationCenter.default.addObserver(self,selector:#selector(printFail(_:)),name: NSNotification.Name(PRINTER_NOTIFI.BACKGROUND_PRINT_FAIL),object: nil)
        
        BLEPrinterUtility?.bleManager.delegate = self
    }
    
    deinit{
        printTimer?.invalidate()
        printTimer = nil
        
        deleteTimer?.invalidate()
        deleteTimer = nil
    }
    
  
    @objc func printSuccessFully(_ notification: Notification){
  
        let object = notification.object as! [String:Any]
        
        if !object.isEmpty{

            guard
                let printMethod = PRINTER_METHOD.init(rawValue: object[PRINTER_NOTIFI.PRINTER_METHOD_KEY] as? Int ?? 0),
                let _ = object["isLastItem"]as? Bool
            else{
                dLog("phạm khánh huy")
                return
            }
    
            
            do {
                
                let id = try ObjectId.init(string: object["id"] as? String ?? "")
                
                switch printMethod {
                    case .POSPrinter:
                        canncelWorkItem(id: id, isErrorOccur: false)
                    case .TSCPrinter:
                        canncelTSCWorkItem(id: id, isErrorOccur: false)
                    case .BLEPrinter:
                        break
                }
                
            }catch{}
            
        }
  
    }
    
    
    @objc func printFail(_ notification: Notification){
        canncelAllWorkItem()
    }
    
    
    @objc func connectPrinterFail(_ notification: Notification){
        
        let object = notification.object as! [String:Any]
       

        if let error = object["error"] as? NSError,let printMethod = PRINTER_METHOD.init(rawValue: object[PRINTER_NOTIFI.PRINTER_METHOD_KEY] as? Int ?? 0){
            
            do {
                
                let id = try ObjectId.init(string: object["id"] as? String ?? "")
                
                switch printMethod {
                    case .POSPrinter:
                        canncelWorkItem(id: id, isErrorOccur: true)
                    case .TSCPrinter:
                        canncelTSCWorkItem(id: id, isErrorOccur: true)
                    case .BLEPrinter:
                        break
                }
                
            }catch{}
            
        }
        
    }
     
    
    @objc func connectPrinterSuccessfully(_ notification: Notification){
        
        backGroundQueue.async(execute: {
            
            let object = notification.object as! [String:Any]
            
            if let printMethod = PRINTER_METHOD.init(rawValue: object[PRINTER_NOTIFI.PRINTER_METHOD_KEY] as? Int ?? 0){

                switch printMethod {

                    case .POSPrinter:
                    
                         do{
                             let queueId = try ObjectId.init(string: object["id"] as? String ?? "")
                             if let position = self.workItems.firstIndex(where: {$0.objectId == queueId}){
                                 self.workItems[position].printWork.perform()
                             }
                         }catch{
                             
                         }


                    case .TSCPrinter:
                        if let tscWorkItem = self.tscWorkItem{
                            tscWorkItem.printWork.perform()
                        }


                    case .BLEPrinter:
                        break
                }

            }
           
        })
    }
        
    
}


extension PrinterUtils{


    func PrintReceipt(presenter:UIViewController,order:OrderDetail,bankAccount:BankAccount,printer:Printer,completetHandler:(()->Void)? = nil){
        let vc = ReceiptPrintFormatViewController()
        vc.printer = printer
        vc.order = order
        vc.bankAccount = bankAccount
        vc.completeHandler = completetHandler
        vc.view.backgroundColor = .clear
        vc.modalPresentationStyle = .overCurrentContext
        presenter.present(vc, animated: false, completion: nil)
    }
    

    func PrintItems(presenter:UIViewController,order:OrderDetail,printItem:[Food], printers:[Printer],printType:Constants.printType,completetHandler:(()->Void)? = nil){
        
        if LocalDataBaseUtils.isOrderPerformingPrintProcess(orderId: order.id){
            presenter.showAlertWithMessage("Hệ thống đang xử lý quy trình in của đơn hàng này, vui lòng chờ trong giây lát", with: nil)
        }else{
    
            let vc = OrderItemPrintFormatViewController()
            vc.printers = printers
            vc.order = order
            vc.printItem = printItem
            vc.printType = printType
            vc.completeHandler = completetHandler
            vc.view.backgroundColor = .clear
            vc.modalPresentationStyle = .overCurrentContext
            presenter.present(vc, animated: false, completion: nil)
        }
    }
    
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
    
    
    
}


//MARK: print for food app
extension PrinterUtils{
    


    func PrintFoodAppItems(presenter:UIViewController,isCustomerOrder:Bool = false,printers:[Printer],orders:[FoodAppOrder],completetHandler:(()->Void)? = nil){
        let printerArray = printers.filter{$0.is_have_printer == ACTIVE}
        
        if printerArray.isEmpty{
            presenter.showAleartViewwithTitle("Cảnh báo", message:"Không tìm thấy máy in đang hoạt động cho chức năng in stamp của Food App",withAutoDismiss: true)
            (completetHandler ?? {})()
        }else if (orders.isEmpty){
            presenter.showAleartViewwithTitle("Cảnh báo", message:"Đơn hàng rỗng nên không thể in",withAutoDismiss: true)
            (completetHandler ?? {})()
        }else{
            let vc = FoodAppPrintFormatViewController()
            vc.isCustomerOrder = isCustomerOrder
            vc.printers = printerArray
            vc.orders = orders
            vc.completeHandler = completetHandler
            vc.printType = .new_item
            vc.view.backgroundColor = .clear
            vc.modalPresentationStyle = .formSheet
            presenter.present(vc, animated: false, completion: nil)
        }
    
    }
    
    
    func getDummyData() -> [FoodAppOrder]{
     
        var jsonString = """
            [
                {
                    "id": 142,
                    "phone": "",
                    "address": "",
                    "channel_order_id": "1481907-C6UXPFUXLGN3TX",
                    "channel_order_food_id": 2,
                    "channel_branch_id": "mkt.tieuanh@gmail.com",
                    "total_amount": 0,
                    "order_amount": 0,
                    "driver_name": "Nguyễn Thanh Phú",
                    "driver_avatar": "https://s3-ap-southeast-1.amazonaws.com/myteksi/grab-id/profile_pic/1/-1/6gPU5qFRq4nTWgQlDUinsFuTcjM=_2024/04/23_.jpg",
                    "channel_order_food_name": "Grabfood",
                    "channel_order_food_code": "GRF",
                    "order_channel_details": [
                        {
                            "id": 296,
                            "channel_order_id": 142,
                            "order_id": "1481907-C6UXPFUXLGN3TX",
                            "food_id": "VNITE2024072203375688599",
                            "food_name": "bắp xào phô mai",
                            "quantity": 1,
                            "price": 69000,
                            "restaurant_food_id": 0,
                            "note":"asdsadsadasadsadasaadasadsaadasdasdsadasadsadsadsadasdasadasaadasadsadasdasdasdasdasdasdasdasdasdasdsadsadasdasdsadsadasdasdasdasdasdas",
                            "food_options": [
                                {
                                    "name": "Phạm khanh huy test1",
                                    "quantity": 2,
                                    "price": 100000
                                },
                                {
                                    "name": "Phạm khanh huy test2",
                                    "quantity": 2,
                                    "price": 100000
                                },
                                {
                                    "name": "Phạm khanh huy test3",
                                    "quantity": 2,
                                    "price": 100000
                                },
                                {
                                    "name": "Phạm khanh huy test4",
                                    "quantity": 2,
                                    "price": 100000
                                },
                                {
                                    "name": "Phạm khanh huy test5",
                                    "quantity": 2,
                                    "price": 100000
                                },
                                {
                                    "name": "Phạm khanh huy test6",
                                    "quantity": 2,
                                    "price": 100000
                                },
                                {
                                    "name": "Phạm khanh huy test7",
                                    "quantity": 2,
                                    "price": 100000
                                },
                                {
                                    "name": "Phạm khanh huy test8",
                                    "quantity": 2,
                                    "price": 100000
                                },
                                {
                                    "name": "Phạm khanh huy test9",
                                    "quantity": 2,
                                    "price": 100000
                                },
                                {
                                    "name": "Phạm khanh huy test10",
                                    "quantity": 2,
                                    "price": 100000
                                }
                            ],
                            "total_price_addition": 0
                        }
                    ],
                    "display_id": "GF-052",
                    "driver_phone": "",
                    "customer_name": "",
                    "shipping_fee": "0",
                    "discount_amount": 0,
                    "customer_order_amount": 0,
                    "customer_discount_amount": 0,
                    "created_at": "12/08/2024 13:34"
                }
             
            ]
            
        """
        
        return Mapper<FoodAppOrder>().mapArray(JSONString: jsonString) ?? []
     
    }
    

}


