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
                    items[i].quantity = 1
                    
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
            ).toString
            
        }).disposed(by: rxbag)
        
        
        textfield_quantity.text = item.quantity.toString
        tableView.reloadData()
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

