//
//  DiscountViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 20/01/2023.
//

import UIKit
import Alamofire
import JonAlert
import RxSwift
class DiscountViewController: BaseViewController {
    var viewModel = DiscountViewModel()
    var completion:(() -> Void) = {}
    let discountType = ["Theo phần trăm","Theo giá tiền"]
    let listName = ["Khách quen của quán","Khách vip của quán","Chương trình khuyến mãi", "Khác"]

    @IBOutlet weak var root_view: UIView!
    @IBOutlet weak var btnDiscountTotalBill: UIButton!
    @IBOutlet weak var btnDiscountByCategory: UIButton!
    @IBOutlet weak var btnShowDiscountType: UIButton!
    
    @IBOutlet weak var view_of_discount_by_category: UIView!
    @IBOutlet weak var btnDiscountFood: UIButton!
    @IBOutlet weak var btnDiscountDrink: UIButton!

    @IBOutlet weak var textfield_discount_percent_of_food: UITextField!
    @IBOutlet weak var textfield_discount_percent_of_drink: UITextField!
    @IBOutlet weak var btnDiscount: UIButton!
    
    
    @IBOutlet weak var view_of_discount_on_total_bill: UIView!
    @IBOutlet weak var textfield_discount_percent_on_bill: UITextField!

    @IBOutlet weak var btnShowDiscountReason: UIButton!

    var order:OrderDetail = OrderDetail()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel.bind(view: self)
     

        checkDiscountTotalBill("")
        mapDataAndValidate()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillChangeFrameNotification , object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification , object:nil)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOutSide(_:)))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
        
        
        
    }
    
    func getAttribute(content:String) -> NSAttributedString{
        return NSAttributedString(string: content, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)])
    }
    
    
    @objc func handleTapOutSide(_ gesture:UIGestureRecognizer){
        let tapLocation = gesture.location(in: root_view)
        if !root_view.bounds.contains(tapLocation){
           dismiss(animated: true)
        }
    }
    

    @IBAction func actionChooseDiscountType(_ sender: UIButton) {
        showList(btn:sender,list: discountType)
        viewModel.seletecBtn.accept(sender)
    }
    
    
    @IBAction func actionChooseReason(_ sender: UIButton) {
        showList(btn:sender,list: listName)
        viewModel.seletecBtn.accept(sender)

    }
    
    @IBAction func actionDiscount(_ sender: Any) {
  

        self.applyDiscount()
        
    }
    
    @IBAction func actionBack(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    private func refreshTextfield(){
        [textfield_discount_percent_on_bill, textfield_discount_percent_of_food, textfield_discount_percent_of_drink].forEach {
            $0.text = ""
            $0.insertText("")
        }
    }
    
    @IBAction func checkDiscountTotalBill(_ sender: Any) {
        btnDiscountTotalBill.isSelected = true
        view_of_discount_by_category.isHidden = true
        view_of_discount_on_total_bill.isHidden = false
        btnDiscountByCategory.isSelected = false
        btnDiscountFood.isSelected = false
        btnDiscountDrink.isSelected = false
        textfield_discount_percent_on_bill.isUserInteractionEnabled = btnDiscountTotalBill.isSelected ? true : false
        /*sử dụng hàm insertText để chạy lại hàm validate*/
        refreshTextfield()
        
    
    }
    
    @IBAction func checkDiscountByCategory(_ sender: Any) {
        btnDiscountTotalBill.isSelected = false
        btnDiscountByCategory.isSelected = true
        view_of_discount_by_category.isHidden = false
        view_of_discount_on_total_bill.isHidden = true
        /*sử dụng hàm insertText để chạy lại hàm validate*/
        refreshTextfield()
    }
    
    @IBAction func checkDiscountByFood(_ sender: Any) {
        btnDiscountFood.isSelected = !btnDiscountFood.isSelected
        textfield_discount_percent_of_food.isUserInteractionEnabled = btnDiscountFood.isSelected ? true : false
        textfield_discount_percent_of_food.text = ""
        textfield_discount_percent_of_food.insertText("")
    }
    
    @IBAction func checkDiscountByDrink(_ sender: Any) {
        btnDiscountDrink.isSelected = !btnDiscountDrink.isSelected
        textfield_discount_percent_of_drink.isUserInteractionEnabled = btnDiscountDrink.isSelected ? true : false
        textfield_discount_percent_of_drink.text = ""
        textfield_discount_percent_of_drink.insertText("")
    }
    
    @objc private func keyboardWillShow(notification: NSNotification ) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            if textfield_discount_percent_of_food.isFirstResponder || textfield_discount_percent_of_drink.isFirstResponder || textfield_discount_percent_on_bill.isFirstResponder{
                root_view.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height/2.1)
            }
        }
    }
        
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        if textfield_discount_percent_of_food.isFirstResponder || textfield_discount_percent_of_drink.isFirstResponder || textfield_discount_percent_on_bill.isFirstResponder{
            root_view.transform = .identity
        }
    }
    
}
    
