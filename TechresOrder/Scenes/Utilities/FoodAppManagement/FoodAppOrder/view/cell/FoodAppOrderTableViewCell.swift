//
//  FoodAppOrderTableViewCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 19/11/25.
//

import UIKit

class FoodAppOrderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var logo: UIImageView!
    
    @IBOutlet weak var lbl_code: UILabel!
    
    @IBOutlet weak var lbl_date: UILabel!
    
    @IBOutlet weak var lbl_total_amount: UILabel!
    
    @IBOutlet weak var lbl_pre_order: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    var data: FoodAppOrder?{
        didSet {
            mapData(data: data!)
        }
    }
    
    private func mapData(data: FoodAppOrder){
        logo.image = data.channel_order_food_code.logo
        lbl_code.text = data.display_id
        lbl_date.text = data.deliver_time
        lbl_total_amount.text = data.total_amount.toString
        lbl_pre_order.isHidden = data.is_scheduled_order == DEACTIVE
    }
    
    
}
