//
//  OrderRebuildRouter.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 16/01/2024.
//

import UIKit

class OrderRebuildRouter: NSObject {
    
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = OrderViewController(nibName: "OrderViewController", bundle: Bundle.main)
        return view
    }
    
    func setSourceView(_ sourceView:UIViewController?){
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    
    func navigateToOrderDetailViewController(order:OrderDetail){
        let vc = OrderDetailRouter().viewController as! OrderDetailViewController
        vc.order = order
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToPayMentViewController(orderDetail: OrderDetail){
        let vc = PaymentRebuildRouter().viewController as! PaymentRebuildViewController
        vc.order = orderDetail
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToQRCodeCashbackViewController(order_id : Int, table_name:String){
        let vc = QRCodeCashbackBillRouter().viewController as! QRCodeCashbackBillViewController
        vc.order_id = order_id
        vc.table_name = table_name
        vc.delegate = sourceView as! QRCodeCashbackBillDelegate
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
    

    func navigateToAddFoodViewController(order:OrderDetail,is_gift:Int){
        let vc = AddFoodRouter().viewController as! AddFoodViewController
        vc.order = order
        vc.is_gift = is_gift
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func navigateToEmployeeSharePointViewController(order_id : Int, table_name:String){
//        let chooseEmployeeNeedShareViewController = ChooseEmployeeNeedShareRouter().viewController as! ChooseEmployeeNeedShareViewController
//        chooseEmployeeNeedShareViewController.order_id = order_id
//        chooseEmployeeNeedShareViewController.table_name = table_name
//        sourceView?.navigationController?.pushViewController(chooseEmployeeNeedShareViewController, animated: true)
    }
    
    func navigateToGiftDetailViewController(qrcode:String, order_id:Int){
        let vc = DialogGiftDetailRouter().viewController as! DialogGiftDetailViewController
        vc.qrcode = qrcode
        vc.order_id = order_id
        sourceView?.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}
