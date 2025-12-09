//
//  FoodAppInvoiceTableViewCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 8/8/25.
//

import UIKit

class FoodAppInvoiceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbl_food_name: UILabel!
    @IBOutlet weak var lbl_quantity: UILabel!
    @IBOutlet weak var lbl_addition_food: UILabel!
    
    @IBOutlet weak var lbl_amount: UILabel!


    @IBOutlet weak var lbl_note: UILabel!
    

    
    @IBOutlet weak var underlineView: UIView!

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
            
            lbl_food_name.attributedText = nil
            lbl_quantity.attributedText = nil
            lbl_note.attributedText = nil
            lbl_amount.attributedText = nil
            lbl_addition_food.attributedText = nil
            
            if let isCancel = self.isCancel, isCancel{
                mapCancelData(data: data!)
            }else{
                mapData(data: data!)
            }
            
           
        }
    }
    

    private func mapData(data: OrderItemOfFoodApp){

    
        lbl_food_name.text = data.food_name
        lbl_note.text = String(format:"(%@)",data.note)
        lbl_quantity.text = String(format:"%.0f x %@", data.quantity,data.price.toString)
        lbl_amount.text = data.total_price_addition.toString
        var text = ""

        data.food_options.enumerated().forEach{(i,value) in
            
            let totalPrice = value.quantity*value.price
            text += String(format: " + %@ x %d = %@\n",value.name,value.quantity,totalPrice.toString)
        }
        
        
        // Check if the last item contains a newline and remove it
        if text.hasSuffix("\n") {
            text.removeLast()
        }
        
        lbl_addition_food.text = text
        lbl_addition_food.text = text
        
        lbl_note.isHidden = data.note.isEmpty
        lbl_addition_food.isHidden = data.food_options.isEmpty
        

    }
    
    private func mapCancelData(data: OrderItemOfFoodApp){
        
        let color = NSAttributedString.Key.foregroundColor
        let crossLine = NSAttributedString.Key.strikethroughStyle
        let value = NSNumber(value: NSUnderlineStyle.single.rawValue)
        
      
        lbl_food_name.attributedText = Utils.setAttributesForLabel(
          label: lbl_food_name,
          attributes: [
              (str:data.food_name,properties:[color:ColorUtils.red_600(),crossLine:value]),
        ])
        
        
        lbl_quantity.attributedText = Utils.setAttributesForLabel(
          label: lbl_quantity,
          attributes: [
              (str:String(format:"%.0f x %@", data.quantity,data.price.toString),properties:[color:ColorUtils.red_600(),crossLine:value]),
        ])
        
        lbl_note.attributedText = Utils.setAttributesForLabel(
          label: lbl_note,
          attributes: [
            (str:String(format:"(%@)",data.note),properties:[color:ColorUtils.red_600(),crossLine:value]),
        ])
        
        lbl_amount.attributedText = Utils.setAttributesForLabel(
          label: lbl_amount,
          attributes: [
              (str:data.total_price_addition.toString,properties:[color:ColorUtils.red_600(),crossLine:value]),
        ])
        
        

        var text = ""

        data.food_options.enumerated().forEach{(i,value) in
            let totalPrice = value.quantity*value.price
            text += String(format: " + %@ x %d = %@\n",value.name,value.quantity,totalPrice.toString)
        }
        
        
        // Check if the last item contains a newline and remove it
        if text.hasSuffix("\n") {
            text.removeLast()
        }
        
        lbl_addition_food.attributedText = Utils.setAttributesForLabel(
          label: lbl_addition_food,
          attributes: [
              (str:text,properties:[color:ColorUtils.red_600(),crossLine:value]),
        ])
        lbl_note.isHidden = data.note.isEmpty
        lbl_addition_food.isHidden = data.food_options.isEmpty

    }
}
