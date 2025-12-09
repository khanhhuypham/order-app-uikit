//
//  EInvoiceManagementTableViewCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 07/06/2025.
//

import UIKit

class EInvoiceManagementTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbl_invoice_status: UILabel!
        
    @IBOutlet weak var lbl_name: UILabel!
    
    @IBOutlet weak var lbl_total_amount: UILabel!
    
    @IBOutlet weak var lbl_invoice_partner_name: UILabel!
    

    @IBOutlet weak var lbl_invoice_date: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var viewModel: EInvoiceManagementViewModel?
    
    public var data: EInvoice? = nil{
        didSet{
            
            if let data = self.data,let viewModel = self.viewModel{
                lbl_name.text = data.is_app_food == ACTIVE ? "AppFood" : "Tại bàn"
                lbl_invoice_partner_name.text = data.partner_type.name
                lbl_total_amount.text = data.total_amount.toString
                lbl_invoice_date.text = viewModel.tabType.value == 1 ? data.payment_date : data.exported_time
                
                
                
                switch viewModel.tabType.value{
                    case 1:
                        lbl_invoice_status.text = "CHỜ XUẤT"
                        lbl_invoice_date.text = data.payment_date
                    case 2:
                        lbl_invoice_status.text = "CHỜ DUYỆT"
                        lbl_invoice_date.text = data.exported_time
                    case 3:
                        lbl_invoice_status.text = "ĐÃ DUYỆT"
                        lbl_invoice_date.text = data.exported_time
                    
                    default:
                        break
                }
            }
        }
    }
    
    
    
}
