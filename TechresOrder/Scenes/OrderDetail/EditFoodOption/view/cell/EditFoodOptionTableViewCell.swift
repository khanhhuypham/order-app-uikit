//
//  EditFoodOptionTableViewCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 26/02/2025.
//

import UIKit
import RxDataSources
class EditFoodOptionTableViewCell: UITableViewCell {
    
    
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
    
    

    
    var viewModel:EditFoodOptionViewModel? = nil
    var indexPath:IndexPath? = nil
    
    var data: OptionItem?{
        didSet {
            
                guard
                    let data = self.data,
                    let indexPath = self.indexPath,
                    let viewModel = self.viewModel else {
                    return
                }
                let section = viewModel.sectionArray.value[indexPath.section].model
                    
                if section.max_items_allowed > 1{
                    view_of_quanity_adjustment.isHidden = data.status == ACTIVE ? false : true
                    icon_check.image = data.status == ACTIVE ? UIImage(named: "check_2") : UIImage(named: "un_check_2")
                    textfield_quantity.text = data.quantity.toString
                }else{
                    view_of_quanity_adjustment.isHidden = true
                    icon_check.image = data.status == ACTIVE ? UIImage(named: "icon-radio-checked") : UIImage(named: "icon-radio-uncheck")
                  
                }
                
                lbl_name.text = String(format: " %@",data.food_name)
                    
        
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
        
        
        if items[indexPath.row].quantity < 1  {
            items[indexPath.row].quantity = 0
            items[indexPath.row].status = DEACTIVE
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
                    items[index].status = items[index].status == ACTIVE ? DEACTIVE : ACTIVE
                    items[index].quantity =  items[index].status == DEACTIVE ? 0 : 1
                    
                }

                // if total items of a section > max_items_allowed, we will deselect that item
                if items.filter{$0.status == ACTIVE}.count > section.max_items_allowed{
                    items[index].status = DEACTIVE
                    viewModel.view?.showWarningMessage(content: String(format: "Số lượng %@ tối đa là %d", section.name,section.max_items_allowed))
                }
                
                
                
            }
            
        }else{
            for (index, option) in items.enumerated() {
                items[index].status = (index == indexPath.row) ? ACTIVE : DEACTIVE
                items[index].quantity = items[index].status == ACTIVE ? 1 : 0

            }
            
        }
        
       
        viewModel.setSection(
            section:SectionModel(model: section, items: items),
            indexPath: indexPath
        )
            
    }
    
    
    
    
}
