//
//  LoginOnlineViewController + extension + popup.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 12/8/25.
//

import UIKit


extension LoginOnlineViewController {
    func presentDialogRegisterAccountViewController() {
        let vc = DialogRegisterAccountViewController()
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    func presentModalDialogConfirmViewController() {
        let vc = DialogFoodCourtViewController()
        vc.view.backgroundColor = ColorUtils.blackTransparent()
        vc.completion = clearCache
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    func presentDialogRequiredSetPassword(currentPassword: String){
        let vc = DialogRequiredSetPasswordViewController()
        vc.oldPassword = currentPassword
        vc.view.backgroundColor = ColorUtils.blackTransparent()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
    
}
