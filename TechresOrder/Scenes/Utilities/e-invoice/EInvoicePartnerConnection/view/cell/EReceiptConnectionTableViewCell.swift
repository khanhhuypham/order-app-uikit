//
//  EReceiptConnectionTableViewCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 05/06/2025.
//

import UIKit

class EReceiptConnectionTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var btn_create_connection: UIButton!
    @IBOutlet weak var stackView_of_btn_group: UIStackView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func acitonEditConnection(_ sender: Any) {
        guard let viewModel = self.viewModel, let data = self.data
        else {
            return
        }
        
        viewModel.view?.presentEditEReceiptConnectionViewController(invoice: data)
    }
    
    
    @IBAction func actionChangeStatus(_ sender: Any) {
        guard let viewModel = self.viewModel, let data = self.data
        else {
            return
        }
        
        viewModel.view?.changeStatus(id: data.id)
    }
    

    var viewModel: EReceiptConnectionViewModel?
    
    public var data: EInvoicePartner? = nil{
        didSet{
            
            if let data = self.data{
                lbl_name.text = String(format: data.is_connected == ACTIVE ? "%@ (đã kết nối)" :"%@ (chưa kết nối)" , data.name)
                lbl_name.textColor = data.is_connected == ACTIVE ? ColorUtils.green_600(): ColorUtils.red_600()
                stackView_of_btn_group.isHidden = data.is_connected == ACTIVE ? false : true
                btn_create_connection.isHidden = data.is_connected == ACTIVE ? true : false
            }
            
            
        }
        
    }
    
}
