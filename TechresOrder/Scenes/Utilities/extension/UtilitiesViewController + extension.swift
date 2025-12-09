//
//  Utilities_rebuildViewController + extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 01/11/2023.


import UIKit
import ObjectMapper
extension UtilitiesViewController {

    func presentModalChooseBrand() {
        let vc = BrandViewController()
        vc.delegate = self
        vc.modalPresentationStyle = .formSheet
        if #available(iOS 15.0, *) {
            if let sheet = vc.sheetPresentationController {
                // 3
                sheet.detents = [.medium()]
                
            }

        }
        present(vc, animated: true, completion: nil)
    }
    
    
    func presentModalChooseBranch(brand:Brand) {
        let vc = BranchViewController()
        vc.delegate = self
        vc.brand = brand
        vc.modalPresentationStyle = .pageSheet
        // 2
        if #available(iOS 15.0, *) {
            if let sheet = vc.sheetPresentationController {
                // 3
                sheet.detents = [.medium()]
            }
        } else {
            // Fallback on earlier versions
        }

        present(vc, animated: true, completion: nil)
    }
    
    func presentDialogFoodCourtViewController() {
        let vc = DialogFoodCourtViewController()
        vc.view.backgroundColor = ColorUtils.blackTransparent()
        vc.modalPresentationStyle = .overCurrentContext
        vc.completion = self.logout
        present(vc, animated: true, completion: nil)
    }
    
}
extension UtilitiesViewController:BrandDelegate, BranchDelegate {
    func callBackChooseBrand(brand: Brand) {
        self.presentModalChooseBranch(brand: brand)
    }
    
    func callBackChooseBranch(branch: Branch) {

        SettingUtils.getBranchSetting(
            branchId: branch.id,
            completion: {
                self.mapData()
            },
            incompletion: {
                self.presentDialogFoodCourtViewController()
            }
        )
    }
}
