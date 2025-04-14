//
//  DialogChooseToppingTableViewCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 22/02/2025.
//

import UIKit
import RxDataSources


class ChooseOptionTableViewCell: UITableViewCell {
    @IBOutlet weak var icon_check: UIImageView!
    @IBOutlet weak var lbl_name: UILabel!
    
    @IBOutlet weak var textfield_quantity: UITextField!
    
    
    @IBOutlet weak var view_of_quanity_adjustment: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var viewModel:ChooseOptionViewModel? = nil
    var indexPath:IndexPath? = nil
    
    
    
    var data: FoodAddition?{
        didSet {
            
            guard 
                let data = self.data,
                let indexPath = self.indexPath,
                let viewModel = self.viewModel else {
                return
            }
            let section = viewModel.sectionArray.value[indexPath.section].model
                
            if section.max_items_allowed > 1{
                view_of_quanity_adjustment.isHidden = data.is_selected == ACTIVE ? false : true
                icon_check.image = data.is_selected == ACTIVE ? UIImage(named: "check_2") : UIImage(named: "un_check_2")
                textfield_quantity.text = data.quantity.toString
            }else{
                view_of_quanity_adjustment.isHidden = true
                icon_check.image = data.is_selected == ACTIVE ? UIImage(named: "icon-radio-checked") : UIImage(named: "icon-radio-uncheck")
              
            }
            
            lbl_name.text = String(format: " %@",data.name)
                
        }
    }
    
    
    @IBAction func actionCalculateQuantity(_ sender: UIButton) {
        guard let indexPath = self.indexPath,
              let viewModel = self.viewModel else {
            return
        }
        
        let section = viewModel.sectionArray.value[indexPath.section]
        var items = section.items
        
        
        switch sender.titleLabel?.text{
            
            case "+":
                items[indexPath.row].quantity += 1
                break
            
            case "-":
                items[indexPath.row].quantity -= 1
                break
            
            default:
                break
        }
        
        
        if items[indexPath.row].quantity <= 0 {
            items[indexPath.row].quantity = 0
            items[indexPath.row].is_selected = DEACTIVE
        }
        
       
        viewModel.setSection(
            section:SectionModel(model: section.model, items: items),
            indexPath: indexPath
        )
        
    }
    
    
    @IBAction func actionSelectItem(_ sender: Any) {
        guard let indexPath = self.indexPath,
              let viewModel = self.viewModel else {
            return
        }
        
        let section = viewModel.sectionArray.value[indexPath.section].model
        var items = viewModel.sectionArray.value[indexPath.section].items

        if section.max_items_allowed > 1{

            for (index, option) in items.enumerated() {

                if index == indexPath.row{
                    items[index].is_selected = items[index].is_selected == ACTIVE ? DEACTIVE : ACTIVE
                    items[index].quantity =  items[index].is_selected == DEACTIVE ? 0 : 1
                    
                }

                // if total items of a section > max_items_allowed, we will deselect that item
                if items.filter{$0.is_selected == ACTIVE}.count > section.max_items_allowed{
                    items[index].is_selected = DEACTIVE
                    viewModel.view?.showWarningMessage(content: String(format: "Số lượng %@ tối đa là %d", section.name,section.max_items_allowed))
                }
                
                
                
            }
            
        }else{
            for (index, option) in items.enumerated() {
                items[index].is_selected = (index == indexPath.row) ? ACTIVE : DEACTIVE
                items[index].quantity = items[index].is_selected == ACTIVE ? 1 : 0

            }
            
        }
        
       
        viewModel.setSection(
            section:SectionModel(model: section, items: items),
            indexPath: indexPath
        )
            
    }
    
}
