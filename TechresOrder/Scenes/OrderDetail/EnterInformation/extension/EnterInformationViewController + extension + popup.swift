//
//  EnterInformationViewController + extension + s.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 31/03/2025.
//

import UIKit

extension EnterInformationViewController:DropDownCustomerViewControllerDelegate{
    
    func showCustomerList(list:[Customer]) {
        let controller = DropDownCustomerViewController(Direction.allValues)
        controller.preferredContentSize = CGSize(width: textfield_phone.frame.width, height: 200)
        controller.list = list
        controller.delegate = self
        showPopupSearchCustormerBooking(controller, sourceView: textfield_phone)
    }
     
     private func showPopupSearchCustormerBooking(_ controller: UIViewController, sourceView: UIView) {
  
         let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
         presentationController.sourceView = sourceView
         presentationController.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0)
         presentationController.sourceRect = CGRectMake(sourceView.bounds.origin.x, sourceView.bounds.origin.y + 130, sourceView.bounds.width, sourceView.bounds.height)
         self.present(controller, animated: true)
   
         
     }
     
    func callbackToGetCustomer(customer: Customer) {
  
        viewModel.customer.accept(customer)
        textfield_name.text = customer.name
        textfield_phone.text = customer.phone
        textview_address.text = customer.address
        
        //after user select infor, we have to block textfield_name and address
        textfield_name.isUserInteractionEnabled = false
        textview_address.isUserInteractionEnabled = false
    }

}
