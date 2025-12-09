//
//  StampPrinterViewController + Extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 20/09/2023.
//

import UIKit
import RxSwift
import JonAlert
extension DetailedPrinterViewController{
    func updateKitchen(){
        viewModel.updateStampPrinter().subscribe(onNext: { [self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Update Kitchen Success...")
                self.viewModel.makePopViewController()
            }else{
                JonAlert.showError(message: response.message ?? "", duration: 2)
            }
        }).disposed(by: rxbag)
    }
    
}


//MARK: print test data for Techres order app
extension DetailedPrinterViewController{
    func printTestForTechResOrderApp(printer:Printer){
       
        if printer.type == .cashier{
            printTestReceipt(printer: printer)
        }else if printer.type == .stamp{
            printTestLabel(printer: printer)
        }else if printer.type == .chef || printer.type == .bar{
            printTestChefBar(printer: printer)
        }
        
    }
    
    private func printTestReceipt(printer:Printer){
        
        var printItems:[OrderItem] = []
        printItems.append(OrderItem.init(name: "Đậu phộng rang", price: 10000, quantity: 3, total_price: 30000))
        printItems.append(OrderItem.init(name: "Mì xào hải sản", price: 50000, quantity: 2, total_price: 100000))
      
        var item = OrderItem.init(name: "Lẩu thái", price: 290000, quantity: 2, total_price: 580000)
        item.order_detail_additions.append(OrderDetailAddition.init(id: 1, name: "Rau", quantity: 1, price: 10000, total_price: 10000))
        item.order_detail_additions.append(OrderDetailAddition.init(id: 2, name: "Mì gói", quantity: 2, price: 5000, total_price: 10000))
        item.order_detail_additions.append(OrderDetailAddition.init(id: 3, name: "Tôm", quantity: 3, price: 15000, total_price: 45000))
        item.total_price_include_addition_foods = item.total_price + item.order_detail_additions.map{Float($0.total_price)}.reduce(0,+)
        printItems.append(item)
     
        var order = OrderDetail()
        order.created_at = TimeUtils.getCurrentDateTime().dateTimeNow
        order.id = 34567
        order.table_name = "BÀN A1"
        order.table_id = 100
        order.employee_name = "Phục vụ 001"
        order.branch_phone = "0123456789"
        order.total_amount = 1000000
        order.total_amount_discount_amount = 20000
        order.vat_amount = 10000
        order.vat_percent = 35
        order.total_final_amount = 970000
        order.branch_address = ManageCacheObject.getCurrentBranch().address
        order.order_details = printItems
        order.transfer_amount = Int(order.total_amount)
        
        let bankAccount = BankAccount.init(
            bank_number: "012345678910",
            bank_name: "Ngân hàng TMCP Ngoại Thương Việt Nam - Vietcombank",
            bank_account_name: "Huy Chicken NO.1",
            qr_code: String(format: "%@:%d:%d:%d",
                            "REGISTER_MEMBERSHIP_CARD",
                            ManageCacheObject.getCurrentUser().restaurant_id,
                            ManageCacheObject.getCurrentBrand().id,
                            ManageCacheObject.getCurrentUser().id)
        )
        
        PrinterUtils.shared.PrintInvoice(
            presenter: self,
            order: order,
            bankAccount:bankAccount,
            printer: printer,
            printMode:.printForeground
        )
       
    }
    
    private func printTestLabel(printer:Printer){
        var order = OrderDetail()
        order.created_at = TimeUtils.getCurrentDateTime().dateTimeNow
        order.id = 34567
        
        let printItems = (1...2).map{(i) in
            var childrenItems:[OrderDetailAddition] = []
            var item = Food(id: i + 100, name: "Trà sữa trân châu \(i)", quantity: 1, price: 30000 + i*1000, note: "nhiều sữa ít đường",restaurant_kitchen_place_id:0)

            if i%2 == 1{
                item.note = ""
            }
            
            item.is_allow_print_stamp = ACTIVE
            for i in (1...3){
                var childrenItem = OrderDetailAddition.init()
                childrenItem.name = String(format: "Thạch trái cây %d", i)
                childrenItem.price = 1000
                childrenItem.quantity = Float(i)
                childrenItems.append(childrenItem)
            }
            item.restaurant_kitchen_place_id = printer.id
            item.TSCPrinter_id = printer.id
            item.order_detail_additions = i%2 == 1 ? childrenItems : []

            return item
        }
        
        PrinterUtils.shared.PrintItems(
            presenter:self,
            order:order,
            printItem:printItems,
            printers:[printer],
            printMode: .printForeground
        )
    }

    private func printTestChefBar(printer:Printer){
        var order = OrderDetail()
        order.created_at = TimeUtils.getCurrentDateTime().dateTimeNow
        order.id = 34567
        order.table_name = "A1"
        order.employee_name = "Phục vụ 001"

        let printItems = Food.getDummyData().map{data in
            var food = data
            food.restaurant_kitchen_place_id = printer.id
            return food
        }
             
        PrinterUtils.shared.PrintItems(
            presenter:self,
            order:order,
            printItem:printItems,
            printers:[printer],
            printMode: .printForeground
        )
    }
}



//MARK: print test data for app food
extension DetailedPrinterViewController{
    
    func printTestForFoodApp(printer:Printer){
   
        if printer.type == .cashier_of_food_app{
            printTestInvoiceForFoodApp(printers: [printer] + Constants.printers.filter{$0.type == .chef || $0.type == .bar})
        }else if printer.type == .stamp_of_food_app{
            printTestLabelForFoodApp(printers: [printer])
        }
        
    }

    private func printTestInvoiceForFoodApp(printers:[Printer]){
        let order = FoodAppOrder.getDummyData()

        PrinterUtils.shared.PrintFoodAppItems(
            presenter:self,
            printers:printers,
            orders:order,
            printMode: .printForeground
        )
              
    }
    
    
    private func printTestLabelForFoodApp(printers:[Printer]){
        let order = FoodAppOrder.getDummyData()
        PrinterUtils.shared.PrintFoodAppItems(presenter: self, printers:printers,orders: order, printMode: .printForeground)
    }
    
    

}






