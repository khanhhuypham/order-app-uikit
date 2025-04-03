//
//  DiscountViewController + extension + Validate.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 14/11/2023.
//

import UIKit
import RxSwift
extension DiscountViewController {
    
    func mapDataAndValidate(){
        mappData()
        isDiscountValid()
        
        var p = viewModel.APIParameter.value
        p.note = self.listName[0]
        p.discountType = .percent
        p.order_id = order.id
        
        btnShowDiscountType.setAttributedTitle(getAttribute(content:discountType[0]), for: .normal)
        btnShowDiscountReason.setAttributedTitle(getAttribute(content:listName[0]), for: .normal)
        
        viewModel.APIParameter.accept(p)
    }
    

    private func mappData(){
        _ = textfield_discount_percent_of_food.rx.text.map{[self] str in
            
            var discount = Int(str?.replacingOccurrences(of: ",", with: "") ?? "0") ?? 0
            
            var p = viewModel.APIParameter.value
 
            switch viewModel.APIParameter.value.discountType{
                case .number:

                    if (discount + p.drink_discount_amount) >= Int(order.total_final_amount){
                        showWarningMessage(content: "Số tiền giảm giá món ăn không được vượt quá số tiền tổng thanh toán")
                        discount = Int(order.total_final_amount) - p.drink_discount_amount
                    }
                
//                    if textfield_discount_percent_of_food.isEditing{
//                        textfield_discount_percent_of_food.text = discount.toString
//                    }
                   
                    p.food_discount_amount = discount
                
                case .percent:
                    if discount > 100{
                        showWarningMessage(content: "Phần trăm giảm giá món ăn không được quá 100%")
                        discount = 100
//                        textfield_discount_percent_of_food.text = String(discount)
                    }
                    p.food_discount_percent = discount
            }
            
            if textfield_discount_percent_of_food.isEditing{
                textfield_discount_percent_of_food.text = discount.toString
            }
           
            return p
        }.bind(to: viewModel.APIParameter).disposed(by: rxbag)
        
        _ = textfield_discount_percent_of_drink.rx.text.map{[self] str in
            var discount = Int(str?.replacingOccurrences(of: ",", with: "") ?? "0") ?? 0
            var p = viewModel.APIParameter.value
            
            switch viewModel.APIParameter.value.discountType{
                case .number:
                    
                    if (discount + p.food_discount_amount) >= Int(order.total_final_amount){
                        showWarningMessage(content: "Số tiền giảm giá thức uống không được vượt quá số tiền tổng thanh toán")
                        discount = Int(order.total_final_amount) - p.food_discount_amount
                    }
                
//                    if textfield_discount_percent_of_drink.isEditing{
//                        textfield_discount_percent_of_drink.text = discount.toString
//                    }
                    
                    p.drink_discount_amount = discount
                
                    
                case .percent:
                    
                    if discount > 100{
                        showWarningMessage(content: "Phần trăm giảm giá thức uống không được quá 100%")
                        discount = 100
//                        textfield_discount_percent_of_drink.text = String(discount)
                    }
                    p.drink_discount_percent = discount
                                    
            }
            
            if textfield_discount_percent_of_drink.isEditing{
                textfield_discount_percent_of_drink.text = discount.toString
            }
            
            return p
        }.bind(to: viewModel.APIParameter).disposed(by: rxbag)
        
        
        _ = textfield_discount_percent_on_bill.rx.text.map{[self] str in
            var discount = Int(str?.replacingOccurrences(of: ",", with: "") ?? "0") ?? 0
            
            var p = viewModel.APIParameter.value
            
            switch viewModel.APIParameter.value.discountType{
                
                case .number:
                
                    if discount >= Int(order.total_final_amount){
                        showWarningMessage(content: "Số tiền giảm giá không được vượt quá số tiền tổng thanh toán")
                        discount = Int(order.total_final_amount)
                    }
                
//                    if textfield_discount_percent_on_bill.isEditing{
//                        textfield_discount_percent_on_bill.text = discount.toString
//                    }
                
                    p.total_bill_discount_amount = discount
                    
                
                case .percent:
                    
                    if discount > 100{
                        showWarningMessage(content: "Phần trăm giảm giá trên tổng bill không được quá 100%")
                        discount = 100
//                        textfield_discount_percent_on_bill.text = String(discount)
                    }
                    p.total_bill_discount_percent = discount
            }
            
            if textfield_discount_percent_on_bill.isEditing{
                textfield_discount_percent_on_bill.text = discount.toString
            }
            
            
            
            return p
        }.bind(to: viewModel.APIParameter).disposed(by: rxbag)
        
    }
        
    private func isDiscountValid(){
        Observable.combineLatest(isDiscountByFoodValid,isDiscountByDrinkValid,isDiscountOnBillValid).map{ (a,b,c) in
            return (a || b) && c
        }.subscribe(onNext: {(valid) in
            self.btnDiscount.backgroundColor = valid ? ColorUtils.orange_brand_900() : .systemGray2
            self.btnDiscount.isEnabled = valid ? true : false
        }).disposed(by: rxbag)
    }
    
    private var isDiscountByFoodValid: Observable<Bool>{
        return viewModel.APIParameter.asObservable().map(){[self](p) in
            if btnDiscountByCategory.isSelected {
                
                if btnDiscountFood.isSelected{
                    switch p.discountType{
                        case .number:
                            return p.food_discount_amount > 0 &&
                            (p.drink_discount_amount + p.food_discount_amount) <= Int(order.total_final_amount)
                        
                        case .percent:
                            return p.food_discount_percent > 0 && p.food_discount_percent <= 100
                    
                    }
                    
                }else{
                    return false
                }
            }else {
                return true
            }
        }
    }
    
    private var isDiscountByDrinkValid: Observable<Bool>{
        return viewModel.APIParameter.asObservable().map(){[self](p) in
            if btnDiscountByCategory.isSelected{
                if btnDiscountDrink.isSelected{
                    switch p.discountType{
                        case .number:
                            return p.drink_discount_amount > 0 &&
                            (p.drink_discount_amount + p.food_discount_amount) <= Int(order.total_final_amount)
                        
                        case .percent:
                            return p.drink_discount_percent > 0 && p.drink_discount_percent <= 100
                    
                    }
                }else{
                    return false
                }
            }else {
                return true
            }
        }
    }
    
   
    private var isDiscountOnBillValid: Observable<Bool>{
        return viewModel.APIParameter.asObservable().map(){[self](p) in
            
            if btnDiscountTotalBill.isSelected{
                switch p.discountType{
                    case .number:
                        return p.total_bill_discount_amount > 0 && p.total_bill_discount_amount <= Int(order.total_final_amount)
                    
                    case .percent:
                        return p.total_bill_discount_percent > 0 && p.total_bill_discount_percent <= 100
                
                               
                }
            }else {
                return true
            }
        }
        
        
    }
    
    
   
}
