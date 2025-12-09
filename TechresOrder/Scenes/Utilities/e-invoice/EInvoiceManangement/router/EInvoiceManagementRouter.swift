//
//  EInvoiceManagementRouter.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 08/06/2025.
//

import UIKit


class EInvoiceManagementRouter {
    
    
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = EInvoiceManagementViewController(nibName: "EInvoiceManagementViewController", bundle: Bundle.main)
        return view
    }
    
    func setSourceView(_ sourceView:UIViewController?){
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    
    func navigateToPopViewController(){
        sourceView?.navigationController?.popViewController(animated: true)
    }
    
    
    func navigateToPayMentViewController(order: OrderDetail){
        let vc = PaymentRebuildRouter().viewController as! PaymentRebuildViewController
        vc.order = order
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
    
    

}
