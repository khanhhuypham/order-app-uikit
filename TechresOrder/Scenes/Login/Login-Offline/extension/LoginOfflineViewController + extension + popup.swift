//
//  LoginOnlineViewController + extension + popup.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 12/8/25.
//

import UIKit


extension LoginOfflineViewController {

    
    func presentDialogRequiredSetPassword(currentPassword: String){
        let vc = DialogRequiredSetPasswordViewController()
        vc.oldPassword = currentPassword
        vc.view.backgroundColor = ColorUtils.blackTransparent()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
    
}
