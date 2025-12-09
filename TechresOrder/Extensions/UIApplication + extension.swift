//
//  UIApplication + extension.swift
//  TechresOrder
//
//  Created by Pham Khanh Huy on 21/11/25.
//

import UIKit

extension UIApplication {
    
    static func topViewController(
        _ controller: UIViewController? = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?.rootViewController
    ) -> UIViewController? {
        
        if let nav = controller as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        
        if let tab = controller as? UITabBarController {
            return topViewController(tab.selectedViewController)
        }
        
        if let presented = controller?.presentedViewController {
            return topViewController(presented)
        }
        
        return controller
    }
}
