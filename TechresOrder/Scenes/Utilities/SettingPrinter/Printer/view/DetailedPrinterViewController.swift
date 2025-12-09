//
//  StampPrinterViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 20/09/2023.
//

import UIKit
import RxSwift
import ExternalAccessory
class DetailedPrinterViewController: BaseViewController {

    var viewModel = DetailedPrinterViewModel()
    var router = DetailedPrinterRouter()
    var printer = Printer.init()

        
    @IBOutlet weak var btn_choose_connection_type: UIButton!
  
    
    @IBOutlet weak var view_of_ip_address: UIView!
    @IBOutlet weak var view_of_port: UIView!
    
    @IBOutlet weak var textfield_print_ipaddress: UITextField!
    @IBOutlet weak var textfield_print_port: UITextField!
    
    @IBOutlet weak var view_of_device_name: UIView!
    @IBOutlet weak var textfield_of_BLE_device_name: UITextField!
    
    
    @IBOutlet weak var lbl_header_options: UILabel!
    
    @IBOutlet weak var btn_of_60_x_40: UIButton!
    @IBOutlet weak var btn_of_50_x_30: UIButton!
    @IBOutlet weak var btn_of_40_x_30: UIButton!
    @IBOutlet weak var btn_of_30_x_20: UIButton!
    
    @IBOutlet weak var btn_of_print_many_foods: UIButton!
    @IBOutlet weak var btn_of_print_each_food: UIButton!
    
    @IBOutlet weak var stackview_of_stamp_direction: UIStackView!
    @IBOutlet weak var btn_of_0_degree: UIButton!
    @IBOutlet weak var btn_of_180_degree: UIButton!
            
    @IBOutlet weak var view_of_printer_number: UIView!
    @IBOutlet weak var textfield_print_number: UITextField!
    @IBOutlet weak var printerSwitch: UISwitch!
    
    @IBOutlet weak var btn_show_printing_queue: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self, router: router)
        firstSetup()
        viewModel.printer.accept(printer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view_of_device_name.isHidden = true
        mapData(printer: viewModel.printer.value)
        textfield_print_number.addTarget(self, action: #selector(textFieldDidEndEditing), for: UIControl.Event.editingChanged)
    }
    


    @IBAction func actionSearch(_ sender: Any) {
       presentDialogBLEInvestigator()
    }
     
    
    @IBAction func actionChooseOption1(_ sender: UIButton) {
        let printer = viewModel.printer.value
            
        if printer.type == .stamp || printer.type == .stamp_of_food_app {
            printer.printer_paper_size = sender.tag
        }
        
        viewModel.printer.accept(printer)
        mapData(printer: printer)
    }
    
    
    
    @IBAction func actionChooseOption2(_ sender: UIButton) {
        let printer = viewModel.printer.value
            
        if printer.type == .chef || printer.type == .bar{
          
            printer.is_print_each_food = sender.currentTitle == "  In riêng từng món" ? ACTIVE : DEACTIVE
        }
        
        viewModel.printer.accept(printer)
        mapData(printer: printer)
    }
    
    @IBAction func actionChooseStampDirection(_ sender: UIButton) {
        let printer = viewModel.printer.value
            
        if printer.type == .stamp || printer.type == .stamp_of_food_app{
            printer.direction = sender.tag
        }
        
        viewModel.printer.accept(printer)
        mapData(printer: printer)
    }
    
    
    
    @IBAction func actionTurnOnOffPrinter(_ sender: UISwitch) {
        let printer = viewModel.printer.value
        
        printer.is_have_printer = sender.isOn ? ACTIVE : DEACTIVE

        viewModel.printer.accept(printer)
    }
    
    
    
    @IBAction func actionPrintTest(_ sender: Any) {
        let printer = viewModel.printer.value
        
        printer.type == .cashier_of_food_app || printer.type == .stamp_of_food_app
        ? printTestForFoodApp(printer: printer)
        : printTestForTechResOrderApp(printer: printer)
    }
    
    @IBAction func actionUpdate(_ sender: Any) {
        
        let printer = viewModel.printer.value
        var valid = true
        
        
        /* MARK: WARNING
         * do not allow stamp printer(tsc printer) connect to wifi printer(pos printer).
         * if it is, error will occur, as each kind of printer recieves different kind of data
         */
        
        if printer.type == .stamp ||  printer.type == .stamp_of_food_app{
       
            for p in Constants.printers.filter{$0.type == .chef || $0.type == .bar || $0.type == .cashier || $0.type == .cashier_of_food_app}{
                if p.printer_ip_address == printer.printer_ip_address && printer.connection_type == .wifi{
                    valid = false
                    self.showAleartViewwithTitle(
                        "Cảnh bảo",
                        message: String(format:"Địa chỉ IP của máy In %@ không được trùng với những loại máy In wifi %@", printer.name,p.name),
                        withAutoDismiss: true
                    )
                }
            }
        }
        
        if valid{
            updateKitchen()
        }
        
    }
    
    
    @IBAction func btn_show_printing_queue(_ sender: Any) {
        presentPrintingQueueViewController()
        
    }
    

    @IBAction func actionBack(_ sender: Any) {
        
        self.navigationController?.viewControllers.removeAll(where: { (vc) -> Bool in
            return vc.isKind(of: ReceiptPrintFormatViewController.self) ? true : false
        })
      
        viewModel.makePopViewController()
    }
    
    @objc internal func textFieldDidEndEditing(_ textField: UITextField) {
        
        /*
            nếu empty thì tự động trả về một
            chia lấy dự cho 10 để lấy dc số cuối cùng vì value thật chất là luôn > 10
         */
        let printer = viewModel.printer.value
        guard let value = Int(textField.text!) else {
            textField.text = String(1)
            printer.print_number = 1
            viewModel.printer.accept(printer)
            return
        }
        
       
        let remainder = value%10
        textField.text = String(remainder)

        if(remainder > 5){
            textField.text = String(5)
        }else if (remainder < 1){
            textField.text = String(1)
        }
        
        printer.print_number = Int(textField.text!) ?? 1
        viewModel.printer.accept(printer)
    }
    
}
