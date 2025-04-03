//
//  EditFoodOptionTableViewCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 26/02/2025.
//

import UIKit

class EditFoodOptionTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var icon_check: UIImageView!
    
    @IBOutlet weak var lbl_name: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    var isMultiple:Bool = false
    
    
    
    var data: OptionItem?{
        didSet {
            
            if let data = self.data{
                
                if isMultiple{
                    
                    icon_check.image = data.status == ACTIVE ? UIImage(named: "check_2") : UIImage(named: "un_check_2")
                    
                }else{
                    
                    icon_check.image = data.status == ACTIVE ? UIImage(named: "icon-radio-checked") : UIImage(named: "icon-radio-uncheck")
                   
                }
                
                lbl_name.text = String(format: " %@",data.food_name)
                
            }
            
        }
    }
    
    
    
    
}
