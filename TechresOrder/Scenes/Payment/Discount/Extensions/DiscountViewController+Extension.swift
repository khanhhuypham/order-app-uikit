//
//  DiscountViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 20/01/2023.
//

import UIKit
import JonAlert
//MARK: CALL API GET DATA FROM SERVER

enum Direction : String {
    
    case north, east, south, west,wests,westss,westsss
    
    static var allValues = [Direction.north, .east, .south, .west, .wests, .westss, .westsss]
    
}

extension DiscountViewController {
    private func showPopup(_ controller: UIViewController, sourceView: UIView) {
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = sourceView
        presentationController.sourceRect = sourceView.bounds
        presentationController.permittedArrowDirections = [.down, .up]
        self.present(controller, animated: true)
    }
    
    func showList(btn:UIButton,list:[String]){
         let controller = ArrayChooseUnitViewController(Direction.allValues)
         controller.listString = list
         controller.delegate = self
         controller.preferredContentSize = CGSize(width: btn.frame.width, height: 200)
         showPopup(controller, sourceView: btn)
     }
    

}
extension DiscountViewController: ArrayChooseUnitViewControllerDelegate{
    func selectUnitAt(pos: Int) {
        
        var p = viewModel.APIParameter.value
        
        if viewModel.seletecBtn.value == btnShowDiscountType{
      
            switch pos {
                case 0:
                    textfield_discount_percent_of_food.placeholder = "Nhập phần trăm giảm giá"
                    textfield_discount_percent_of_drink.placeholder = "Nhập phần trăm giảm giá"
                    textfield_discount_percent_on_bill.placeholder = "Nhập phần trăm giảm giá"
                    p.food_discount_amount = 0
                    p.drink_discount_amount = 0
                    p.total_bill_discount_amount = 0
                    p.discountType = .percent
                    
                    
                default:
                    textfield_discount_percent_of_food.placeholder = "Nhập số tiền giảm giá"
                    textfield_discount_percent_of_drink.placeholder = "Nhập số tiền giảm giá"
                    textfield_discount_percent_on_bill.placeholder = "Nhập số tiền giảm giá"
                    p.food_discount_percent = 0
                    p.drink_discount_percent = 0
                    p.total_bill_discount_percent = 0
                    p.discountType = .number
                
            }
            btnShowDiscountType.setAttributedTitle(getAttribute(content:discountType[pos]), for: .normal)
            viewModel.APIParameter.accept(p)
            textfield_discount_percent_of_food.text = ""
            textfield_discount_percent_of_drink.text = ""
            textfield_discount_percent_on_bill.text = ""
         }else{
             btnShowDiscountReason.setAttributedTitle(getAttribute(content:listName[pos]), for: .normal)
             p.note = listName[pos]
             viewModel.APIParameter.accept(p)
         }
        
       
    }
    
}
extension DiscountViewController{
    func applyDiscount(){
        viewModel.discount().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){

                
                self.dismiss(animated: true,completion: {
                    self.completion()
                })
               
            }else{
                dLog(response.message ?? "")
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.", duration: 2.0)
            }
         
        }).disposed(by: rxbag)
    }
    
}
