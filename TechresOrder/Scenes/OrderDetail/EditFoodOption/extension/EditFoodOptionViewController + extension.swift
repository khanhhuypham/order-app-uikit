//
//  EditFoodOptionViewController + extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 26/02/2025.
//

import UIKit
import JonAlert
import RxDataSources
extension EditFoodOptionViewController{
    
    
    func updateFoodsToOrder(updateFood: [FoodUpdate]){
        viewModel.updateFoods(updateFood: updateFood).subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                self.actionCancel("")
            }else {
                JonAlert.showError(message: response.message ?? "", duration: 3.0)
            }
        }).disposed(by: rxbag)
        
    }
}



// MARK: - UITableViewDataSource and UITableViewDelegate
extension EditFoodOptionViewController: UITextViewDelegate {
    
    func firstSetup(item:OrderItem) {

        var sections:[SectionModel<OptionOfDetailItem,OptionItem>] = []
        
        for option in item.order_detail_options{
            
            var items = option.food_option_foods
            
            if option.max_items_allowed > 1 {
                
                for (i,item) in items.enumerated(){
                    
                    if item.status == ACTIVE{
                        
                        items[i].status = ACTIVE
                        
                    }
                }
                
            }else{
                
                if let i = option.food_option_foods.firstIndex(where: {$0.status == ACTIVE}){
                    
                    items[i].status = ACTIVE

                }else{
                    
                    if (option.min_items_allowed > 0){
                        items[0].status = ACTIVE
                        items[0].quantity = 1
                    }
                    
                }
                
            }
            
            
            sections.append(SectionModel(model: option, items: items))
        }
        viewModel.orderId.accept(self.orderId)
        viewModel.orderItem.accept(item)
        viewModel.sectionArray.accept(sections)
        
        
        lbl_name.text = item.name
        text_view.text = item.note
        text_view.delegate = self // Set the delegate
        
        _ = viewModel.sectionArray.asObservable().subscribe(onNext: {(item) in
            
            self.lbl_price.text = self.calculateTotalAmount(
                item:self.viewModel.orderItem.value,
                list: item.flatMap{$0.items}
            ).rounded(.up).toString
            
        }).disposed(by: rxbag)
        
        
        textfield_quantity.text = item.quantity.toString
        textfield_quantity.keyboardType = item.is_sell_by_weight == ACTIVE ? .decimalPad : .numberPad
        textfield_quantity.setMaxValue(maxValue: 999)
        textfield_quantity.addTarget(self, action: #selector(textFieldEditingDidEnd(_:)), for: .editingChanged)
        tableView.reloadData()
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
            var item = viewModel.orderItem.value
            item.setQuantity(quantity: Float(text) ?? 0)
            viewModel.orderItem.accept(item)
            textfield_quantity.text = text
        }
        

    }
    
    
    
    // UITextViewDelegate method
    func textViewDidChange(_ textView: UITextView) {
        var item = viewModel.orderItem.value
        item.note = textView.text
        viewModel.orderItem.accept(item)
    }
    
    
    func calculateTotalAmount(item:OrderItem,list:[OptionItem]) -> Float {
        
        let initialAmount = Float(item.price) * item.quantity
        
        let amount: Float = list.reduce(initialAmount) { result, item in
            
            let itemTotal = Float(item.price) * item.quantity
           
            return result + itemTotal
        }
        
        return amount
    }
    



}

