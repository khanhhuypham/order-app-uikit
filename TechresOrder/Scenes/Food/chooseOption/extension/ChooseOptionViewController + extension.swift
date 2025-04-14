//
//  ChooseOptionViewController + extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 27/02/2025.
//

import UIKit
import RxDataSources
// MARK: - UITableViewDataSource and UITableViewDelegate
extension ChooseOptionViewController:UITextViewDelegate {

    
    
//    @objc private func keyboardWillShow(notification: NSNotification ) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
//            if text_view.isFirstResponder || textfield_quantity.isFirstResponder{
//                root_view.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height)
//            }
//        }
//    }
//        
//    
//    @objc private func keyboardWillHide(notification: NSNotification) {
//        if text_view.isFirstResponder || textfield_quantity.isFirstResponder {
//            root_view.transform = .identity
//        }
//    }
    
    

    func firstSetup(_ food:Food) {
      
        var item = food
        item.quantity = item.quantity == 0 ? 1 : item.quantity
        
        
        
        let imageUrl = URL(string: Utils.getFullMediaLink(string: item.avatar))
        food_image.kf.setImage(with: imageUrl, placeholder: UIImage(named: "image_defauft_medium"))
        lbl_name.text = item.name
        lbl_price.text = (item.price_with_temporary * Int(item.quantity)).toString
        textfield_quantity.text = item.quantity.toString
        text_view.text = item.note
 
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillChangeFrameNotification , object:nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification , object:nil)
        text_view.withDoneButton()
        text_view.delegate = self // Set the delegate
        
        
        
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
                    items[i].quantity = 1
                    
                }else{
                    
                    if (option.min_items_allowed > 0){
                        items[0].is_selected = ACTIVE
                        items[0].quantity = 1
                    }
                    
                }
                
            }
            
            
            sections.append(SectionModel(model: option, items: items))
            
        }
        viewModel.item.accept(item)
        viewModel.sectionArray.accept(sections)
        
        

        tableView.reloadData()
    
        if item.food_options.count > 0{
            
            height_of_table.constant = 200
            
            for (i,option) in item.food_options.enumerated(){
                height_of_table.constant += tableView.rect(forSection: i).height

            }
        
            height_of_table.constant -= 200
            tableView.layoutIfNeeded()
        }else{
            height_of_table.constant = 0
        }
        
    }
    
    // UITextViewDelegate method
    func textViewDidChange(_ textView: UITextView) {
        var item = viewModel.item.value
        item.note = textView.text
        viewModel.item.accept(item)
    }


}

