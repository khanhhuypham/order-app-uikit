//
//  ChooseOptionViewController + extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 27/02/2025.
//

import UIKit
import RxDataSources
import TagListView
// MARK: - UITableViewDataSource and UITableViewDelegate
extension ChooseOptionViewController:UITextViewDelegate,TagListViewDelegate {

    
    
    func firstSetup(_ food:Food) {
      
        var item = food
        
        
        if item.quantity == 0{
            item.quantity = item.is_sell_by_weight == ACTIVE ? 0.01 : 1
        }
   
        
        let imageUrl = URL(string: Utils.getFullMediaLink(string: item.avatar))
        food_image.kf.setImage(with: imageUrl, placeholder: UIImage(named: "image_defauft_medium"))
        lbl_name.text = item.name
        lbl_price.text = (Float(item.price_with_temporary) * item.quantity).rounded(.up).toString
        

        textfield_quantity.text = item.quantity.toString
        textfield_quantity.keyboardType = item.is_sell_by_weight == ACTIVE ? .decimalPad : .numberPad
        textfield_quantity.addTarget(self, action: #selector(textFieldEditingDidEnd(_:)), for: .editingChanged)
        textfield_quantity.setMaxValue(maxValue: 999)
        text_view.text = item.note
 
        text_view.withDoneButton()
        text_view.delegate = self // Set the delegate
        tagListView.delegate = self
        
        var sections:[SectionModel<FoodOptional,FoodAddition>] = []
    
        for option in item.food_options{

            var items = option.addition_foods
            
            if option.max_items_allowed > 1 {
                
                for (i,item) in items.enumerated(){
                    if item.is_selected == ACTIVE{
                        items[i].is_selected = ACTIVE
                    }
                }
        
            }else{
                if let i = option.addition_foods.firstIndex(where: {$0.is_selected == ACTIVE}){
                    items[i].is_selected = ACTIVE
                }
            }
            sections.append(SectionModel(model: option, items: items))
        }
        
        
        for (i,section) in sections.enumerated(){
            let option = section.model
            var items = section.items
            
            
            if option.min_items_allowed > items.filter{$0.is_selected == ACTIVE}.count{
                
                for (j,item) in items.filter{$0.is_selected == DEACTIVE}.enumerated(){
               
                    
                    if items.filter{$0.is_selected == ACTIVE}.count == option.min_items_allowed{
                        continue
                    }else if items.filter{$0.is_selected == ACTIVE}.count > option.max_items_allowed{
                        items[j].is_selected = DEACTIVE
                        items[j].quantity = 0
                    }else{
                        items[j].is_selected = ACTIVE
                        items[j].quantity = 1
                    }
        
                }
                
            }
            sections[i].items = items
        }
        
        
        
        viewModel.item.accept(item)
        viewModel.sectionArray.accept(sections)
        tableView.reloadData()

        permissionUtils.GPBH_1 ? notes() : notesByFood()
    }
    
    
    @objc func textFieldEditingDidEnd(_ textField: UITextField) {
        
        if var text = textField.text {
            // Normalize all commas to dots first
            text = text.replacingOccurrences(of: ",", with: ".")

            // If there's a dot, keep only the first one
            if let firstDotIndex = text.firstIndex(of: ".") {
                let prefix = text[..<text.index(after: firstDotIndex)]
                let suffix = text[text.index(after: firstDotIndex)...].replacingOccurrences(of: ".", with: "").prefix(2).description
                text = prefix + suffix
            }

            // Update your model
            var item = viewModel.item.value
            item.setQuantity(quantity: Float(text) ?? 0)
            viewModel.item.accept(item)
            textfield_quantity.text = text
            lbl_price.text = (Float(item.price_with_temporary) * item.quantity).rounded(.up).toString
        }
        

    }
    
    // UITextViewDelegate method
    func textViewDidChange(_ textView: UITextView) {
        var item = viewModel.item.value
        item.note = textView.text
        viewModel.item.accept(item)
    }
    
    
    // MARK: TagListViewDelegate
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")

        var item = viewModel.item.value
 
    
        if(item.note.count>0){
            item.note.append(contentsOf: String(format: ", %@", title))
        }else{
            item.note.append(contentsOf: title)
        }
                
        viewModel.item.accept(item)
        text_view.text = item.note
        
    }


}

