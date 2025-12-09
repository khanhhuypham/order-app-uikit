//
//  FoodAppKitchenTicketTableViewCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 8/8/25.
//

import UIKit

class FoodAppKitchenTicketTableViewCell: UITableViewCell {
    @IBOutlet weak var container_view: UIView!
    @IBOutlet weak var lbl_item_name: UILabel!
    @IBOutlet weak var lbl_unit: UILabel!
    @IBOutlet weak var lbl_quantity: UILabel!
    @IBOutlet weak var lbl_item_addition: UILabel!
    
    @IBOutlet weak var lbl_note: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var isCancel: Bool? = nil
    
    var data: OrderItemOfFoodApp?{
        didSet {
            lbl_item_name.attributedText = nil
            lbl_quantity.attributedText = nil
            lbl_unit.attributedText = nil
            lbl_item_addition.attributedText = nil
            lbl_note.attributedText = nil
            if let isCancel = self.isCancel, isCancel{
                mapCancelData(data: data!)
            }else{
                mapData(data: data!)
            }
            
        }
    }
    
    
    
    private func mapData(data: OrderItemOfFoodApp){
        lbl_item_name.text = data.food_name
        lbl_unit.text = "Phần"
        lbl_quantity.text = String(format:"%.0f", data.quantity)
    
        var text = ""

        data.food_options.enumerated().forEach{(i,value) in
            
            text += String(format: " + %@ x %d\n",  value.name, value.quantity)
        }
        
     
        // Check if the last item contains a newline and remove it
        if text.hasSuffix("\n") {
            text.removeLast()
        }
        lbl_item_addition.text = text
        lbl_note.text = String(format: "(%@)", data.note)
        lbl_note.isHidden = data.note.isEmpty
        container_view.addBorder(toEdges: [.top], color: .systemGray4, thickness: 1)
    }
    
    private func mapCancelData(data: OrderItemOfFoodApp){

        lbl_item_name.attributedText = Utils.setAttributesForLabel(
          label: lbl_item_name,
          attributes: [
              (str:data.food_name,properties:[crossLineKey:crossLineValue]),
        ])
        
        lbl_quantity.attributedText = Utils.setAttributesForLabel(
          label: lbl_quantity,
          attributes: [
              (str:String(format:"%.0f", data.quantity),properties:[crossLineKey:crossLineValue]),
        ])
        
        lbl_unit.attributedText = Utils.setAttributesForLabel(
          label: lbl_unit,
          attributes: [
              (str:"Phần",properties:[crossLineKey:crossLineValue]),
        ])

        var text = ""

        data.food_options.enumerated().forEach{(i,value) in
            
            text += String(format: " + %@ x %.0f\n",  value.name, value.quantity)
        }
        
            
        // Check if the last item contains a newline and remove it
        if text.hasSuffix("\n") {
            text.removeLast()
        }
        
        lbl_item_addition.attributedText = Utils.setAttributesForLabel(
          label: lbl_item_addition,
          attributes: [
              (str:text,properties:[crossLineKey:crossLineValue]),
        ])
        
        lbl_note.attributedText = Utils.setAttributesForLabel(
          label: lbl_note,
          attributes: [
              (str:String(format: "(%@)", data.note),properties:[crossLineKey:crossLineValue]),
        ])

        lbl_note.isHidden = data.note.isEmpty
        container_view.addBorder(toEdges: [.top], color: .systemGray4, thickness: 1)
    }
    
}
