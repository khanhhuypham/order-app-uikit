//
//  FoodAppPrintUtils + extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 29/8/25.
//

import UIKit

extension FoodAppPrintUtils {
    
    static func presentErrorMessage(content:String,viewController: UIViewController) {
        let lbl_message = UILabel()
        lbl_message.textColor = .white
        lbl_message.numberOfLines = 0
        lbl_message.textAlignment = .center
        lbl_message.backgroundColor = .darkGray
        lbl_message.layer.cornerRadius = 8
        lbl_message.clipsToBounds = true
        lbl_message.attributedText = Utils.setAttributesForLabel(
            label: lbl_message,
            attributes:[
                (str:"Tài khoản merchant: ",properties:[.font: UIFont.systemFont(ofSize: 16, weight: .regular)]),
                (str:content, properties:[.font: UIFont.systemFont(ofSize: 18, weight: .bold)]),
                (str:" đã hết hiệu lực\n",properties:[.font: UIFont.systemFont(ofSize: 16, weight: .regular)]),
                (str:"Vui lòng kết nối lại để nhận đủ đơn hàng hoặc huỷ kết nối để ẩn thông báo này.",properties:[.font: UIFont.systemFont(ofSize: 16, weight: .regular)])
            ]
        )
        // Size the label (width = parent width - 40, height = dynamic)
        let maxWidth = viewController.view.bounds.width - 40
        let size = lbl_message.sizeThatFits(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude))
        lbl_message.frame = CGRect(x: 20, y: 0, width: maxWidth, height: size.height + 20)
        
        showViewFromBottom(lbl_message, in: viewController.view)
    }
    
    static func showViewFromBottom(_ view: UIView, in parentView: UIView) {
        let screenWidth = parentView.bounds.width
        let screenHeight = parentView.bounds.height
        
        // Final position: at the bottom (with some padding)
        let targetY = screenHeight - view.bounds.height/2 - 20 // 20 = bottom padding
        
        // Start position: off-screen (below bottom)
        view.center = CGPoint(x: screenWidth / 2,y: screenHeight + view.bounds.height/2)
        
        parentView.addSubview(view)
        
        // Animate to bottom
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseOut,
                       animations: {
            view.center = CGPoint(x: screenWidth / 2, y: targetY)
        }, completion: { _ in
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
                UIView.animate(withDuration: 0.3, animations: {
                    view.alpha = 0
                }, completion: { _ in
                    view.removeFromSuperview()
                })
            }
        })
    }


}
