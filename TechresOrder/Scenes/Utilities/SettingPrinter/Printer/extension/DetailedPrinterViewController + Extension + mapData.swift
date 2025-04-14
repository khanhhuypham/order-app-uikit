//
//  DetailedPrinterViewController + Extension + mapData.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 30/11/2023.
//

import UIKit

//MARK: setup and map data
extension DetailedPrinterViewController{
    
    func firstSetup(){
        btn_show_printing_queue.isHidden = true
    

        _ = textfield_print_ipaddress.rx.text.map{[self] str in
            var printer = viewModel.printer.value
            printer.printer_ip_address = str ?? ""
            return printer
        }.bind(to:viewModel.printer).disposed(by: rxbag)
        
        _ = textfield_print_port.rx.text.map{[self] str in
            var printer = viewModel.printer.value
            printer.printer_port = str ?? ""
            return printer
        }.bind(to:viewModel.printer).disposed(by: rxbag)
    }
    
   
    
    
    func mapData(printer:Printer){

        textfield_of_BLE_device_name.text = printer.name
        textfield_print_ipaddress.text = printer.printer_ip_address
        textfield_print_port.text = printer.printer_port
        textfield_print_number.text = String(printer.print_number)
        printerSwitch.isOn = printer.is_have_printer == ACTIVE ? true : false
        
        textfield_print_port.isUserInteractionEnabled = true
        if printer.type == .cashier || printer.type == .cashier_of_food_app{
            setupInterfaceForBillPrinter()
        }else if printer.type == .stamp || printer.type == .stamp_of_food_app{
            textfield_print_port.isUserInteractionEnabled = true
            setupInterfaceForStampPrinter(printer: printer)
        }else if printer.type == .chef || printer.type == .bar{
            setupInterfaceForChefBarPrinter(printer: printer)
        }
        
        
       
        switch printer.connection_type{
            case .wifi:
                view_of_ip_address.isHidden = false
                view_of_port.isHidden = false
                view_of_device_name.isHidden = true
                break
            

            default:
                view_of_ip_address.isHidden = true
                view_of_port.isHidden = true
                view_of_device_name.isHidden = false
                break
        }
        
        
        
        var options:[UIAction] = []
        
        for type in CONNECTION_TYPE.allCases {
            
            let option = UIAction(
                title: type.name,
                image: nil,
                identifier: nil,
                state:  printer.connection_type == type ? .on : .off,
                handler: { _ in
                    self.btn_choose_connection_type.menu = self.handleSelection(type: type, menu:self.btn_choose_connection_type.menu!)
                }
            )
            
            if printer.connection_type == type {
               
                btn_choose_connection_type.setAttributedTitle(
                    getAttribute(content: String(format: " %@", type.name)),
                    for: .normal
                )
            }
            
            options.append(option)
            
        }
        
        btn_choose_connection_type.menu = UIMenu(title: "", children: options)
     
    }
    
    private func handleSelection(type: CONNECTION_TYPE, menu:UIMenu) -> UIMenu{

        btn_choose_connection_type.setAttributedTitle(
            getAttribute(content: String(format: " %@", type.name)),
            for: .normal
        )
        let printer = viewModel.printer.value
        printer.connection_type = type
        viewModel.printer.accept(printer)
        mapData(printer: printer)
 
        menu.children.enumerated().forEach{(i, action) in
            guard let action = action as? UIAction else {
                return
            }
            action.state = action.title == type.name ? .on : .off
        }
    
        return menu
    }
    

    
    private func setupInterfaceForBillPrinter(){
        lbl_header_options.isHidden = true
        btn_of_option1.isHidden = true
        btn_of_option2.isHidden = true
        view_of_printer_number.isHidden = true
       
    }
    private func setupInterfaceForStampPrinter(printer:Printer){
        btn_of_option1.setTitle("  50x30(mm)", for: .normal)
        btn_of_option2.setTitle("  30x20(mm)", for: .normal)
        btn_of_option1.setImage(UIImage(named: printer.printer_paper_size == 50 ? "icon-radio-checked" : "icon-radio-uncheck"), for: .normal)
        btn_of_option2.setImage(UIImage(named: printer.printer_paper_size == 30 ? "icon-radio-checked" : "icon-radio-uncheck"), for: .normal)
       
    }
    private func setupInterfaceForChefBarPrinter(printer:Printer){
        btn_of_option1.setTitle("  In order trên 1 phiếu", for: .normal)
        btn_of_option2.setTitle("  In riêng từng món", for: .normal)
        btn_of_option1.setImage(UIImage(named: printer.is_print_each_food == DEACTIVE ? "icon-radio-checked" : "icon-radio-uncheck"), for: .normal)
        btn_of_option2.setImage(UIImage(named: printer.is_print_each_food == ACTIVE ? "icon-radio-checked" : "icon-radio-uncheck"), for: .normal)
    }
    
    private func getAttribute(content:String) -> NSAttributedString{
        return NSAttributedString(
                string: content,
                attributes: [
                        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                        NSAttributedString.Key.foregroundColor: ColorUtils.black(),
                ]
        )
    }
}
