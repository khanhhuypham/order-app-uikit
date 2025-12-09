//
//  PrinterConnectionWarningViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 28/8/25.
//

import UIKit

class PrinterConnectionWarningViewController: UIViewController {
    
    
    @IBOutlet weak var stack_view: UIStackView!
 
    var printers:[Printer] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

        let stackViewOfLbl = UIStackView()
        stackViewOfLbl.spacing = 5
        stackViewOfLbl.distribution = .fill
        stackViewOfLbl.axis = .vertical
      
        for printer in printers {
            let label1 = UILabel()
            let label2 = UILabel()
            
            label1.attributedText = Utils.setAttributesForLabel(
                label: label1,
                attributes:[
                    (str:String(format:"Máy in %@ ",printer.printer_name),properties:[color:UIColor.black]),
                    (str:String(format:"In qua %@",printer.connection_type.name),properties:[color:ColorUtils.orange_brand_900()])
                ]
            )
            label1.font = .systemFont(ofSize: 14)
            label1.textAlignment = .center
            
            label2.attributedText = Utils.setAttributesForLabel(
                label: label2,
                attributes:[
                    (str:"IP / Tên máy in: ",properties:[color:UIColor.black]),
                    (str:printer.printer_ip_address,properties:[color:ColorUtils.blue_brand_700()])
                ]
            )
            label2.font = .systemFont(ofSize: 14)
            label2.textAlignment = .center
            
            
            stackViewOfLbl.addArrangedSubview(label1)
            stackViewOfLbl.addArrangedSubview(label2)
            
        }
        
        
        stack_view.addArrangedSubview(stackViewOfLbl)
        stack_view.removeConstraints(stack_view.constraints)
    }
    
    
    @IBAction func actionDismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
