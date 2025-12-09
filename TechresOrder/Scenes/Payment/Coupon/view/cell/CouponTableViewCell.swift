//
//  CouponTableViewCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 24/10/25.
//

import UIKit

class CouponTableViewCell: UITableViewCell {
    
    @IBOutlet weak var stack_view: UIStackView!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_minimum_amount: UILabel!
    @IBOutlet weak var lbl_start_date: UILabel!
    @IBOutlet weak var lbl_end_date: UILabel!
    @IBOutlet weak var lbl_description: UILabel!
    @IBOutlet weak var lbl_quantity: UILabel!
    
    @IBOutlet weak var lbl_discount_amount: UILabel!
    
    @IBOutlet weak var btn_select: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    weak var viewModel:CouponViewModel? = nil
    
    var data:Coupon? = nil{
        didSet{
            guard let viewModel = self.viewModel,let data = self.data else {return}
            lbl_name.text = data.name
            lbl_minimum_amount.text = String(format: "Đơn tối thiểu: %@", data.min_order_amount.toString)
            lbl_start_date.text = String(format:"Ngày bắt đầu: %@", data.start_date)
            lbl_end_date.text = String(format: "Ngày hết hạn: %@", data.end_date)
            lbl_description.text = data.note
            lbl_quantity.text = String(format: "Số coupon còn lại: %d", data.quantity)
            
            if data.discount_amount > 0 {
                lbl_discount_amount.text = data.discount_amount.toString
            }else if data.discount_percent > 0{
                lbl_discount_amount.text = String(format:"%d%%", data.discount_percent)
            }
            
            if data.start_date.isEmpty && data.end_date.isEmpty{
                lbl_start_date.isHidden = true
                lbl_end_date.text = "Thời gian: Vô thời hạn"
            }else{
                lbl_start_date.isHidden = false
            }
            lbl_description.isHidden = data.note.isEmpty
            btn_select.setImage(UIImage(named: data.select ? "icon-radio-checked" : "icon-radio-uncheck"), for: .normal)
            
            self.stack_view.setDisabledLayer(viewModel.order.value.amount < data.min_order_amount)
        }
    }
    
    @IBAction func actionSelect(_ sender: Any) {
        guard let viewModel = self.viewModel, let data = self.data else{return}
        var list = viewModel.list.value
        
        for (i,element) in list.enumerated(){
            list[i].select = data.id == element.id && viewModel.order.value.amount >= element.min_order_amount
        }
        
        viewModel.list.accept(list)
        viewModel.view?.tableView.reloadData()
    }
    
    
}
