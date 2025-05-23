//
//  ReportBusinessCancelFoodTableViewCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 23/09/2023.
//

import UIKit

class ReportBusinessCancelFoodTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lbl_amount: UILabel!
    
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_quantity: UILabel!
    @IBOutlet weak var lbl_number: UILabel!
    
    @IBOutlet weak var avatar: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)

    }
    
    
    // MARK: - Variable -
    public var data:FoodReport? = nil {
        didSet {
            lbl_name.text = data?.food_name
            lbl_quantity.text = MathUtils.isInteger(number: data?.quantity ?? 0.0)
            ? String(format:  "Số lượng: %d", Int(data?.quantity ?? 0.0))
            : String(format:  "Số lượng: %.2f", data?.quantity ?? "0")
            lbl_amount.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: data?.total_amount ?? 0)
            avatar.kf.setImage(with: URL(string: Utils.getFullMediaLink(string: (data!.food_avatar))), placeholder:  UIImage(named: "image_defauft_medium"))
        }
    }
    
}
