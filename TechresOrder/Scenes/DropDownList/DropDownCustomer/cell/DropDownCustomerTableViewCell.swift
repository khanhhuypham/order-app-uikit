//
//  ItemCustomerSearchTableViewCell.swift
//  TECHRES-SEEMT
//
//  Created by Nguyen Thanh Vinh on 15/3/24.
//  Copyright © 2024 OVERATE-VNTECH. All rights reserved.
//

import UIKit

class DropDownCustomerTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_customer_name: UILabel!
    @IBOutlet weak var lbl_customer_phone: UILabel!
    @IBOutlet weak var image_avatar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    var data: Customer?{
        didSet {
            guard let customer = self.data else {
                return
            }
            
            
            self.lbl_customer_name.text = customer.name
            self.lbl_customer_phone.text = customer.phone
            self.image_avatar.kf.setImage(with: URL(string: Utils.getFullMediaLink(string: customer.avatar)),placeholder: UIImage(named: "image_default_user"))
        }
    }
    
    
}
