//
//  OpenWorkingSessionViewController+Extension.swift
//  TechresOrder
//
//  Created by Kelvin on 26/01/2023.
//

import UIKit
import RxSwift
import ObjectMapper
import JonAlert
//MARK: -- CALL API 
extension OpenWorkingSessionViewController {

    func openSession(){
        viewModel.openSession().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){

                JonAlert.showSuccess(message: "Mở ca thành công...",duration: 2.0)
//                self.viewModel.makePopViewController()
                self.dismiss(animated: true)
            }else{
                dLog(response.message ?? "")
                JonAlert.showError(message: response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.", duration: 2.0)
            }
         
        }).disposed(by: rxbag)
    }
    

    
}
extension OpenWorkingSessionViewController:CalculatorMoneyDelegate {
    func presentModalCaculatorInputMoneyViewController() {
            let caculatorInputMoneyViewController = CaculatorInputMoneyViewController()
            caculatorInputMoneyViewController.checkMoneyFee = 1000
            caculatorInputMoneyViewController.limitMoneyFee = 99999999
            caculatorInputMoneyViewController.total_amount = self.viewModel.before_cash.value
            caculatorInputMoneyViewController.view.backgroundColor = ColorUtils.blackTransparent()
            let nav = UINavigationController(rootViewController: caculatorInputMoneyViewController)
            // 1
            nav.modalPresentationStyle = .overCurrentContext

            
            // 2
            if #available(iOS 15.0, *) {
                if let sheet = nav.sheetPresentationController {
                    
                    // 3
                    sheet.detents = [.large()]
                    
                }
            } else {
                // Fallback on earlier versions
            }
            // 4
            caculatorInputMoneyViewController.delegate = self
            present(nav, animated: true, completion: nil)
    }
    
    func callBackCalculatorMoney(amount: Int, position: Int) {
   
        viewModel.before_cash.accept(amount)
        
        let attr:NSAttributedString = Utils.setAttributesForBtn(
            content: Utils.stringVietnameseMoneyFormatWithNumber(amount: Float( String(format: "%d", amount))!),
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular),
                NSAttributedString.Key.foregroundColor: ColorUtils.black()
            ]
        )
        
        btnInputMoney.setAttributedTitle(attr,for: .normal)

    }
}


extension OpenWorkingSessionViewController{
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
    
    
}


extension OpenWorkingSessionViewController:BrandDelegate, BranchDelegate {
    func callBackChooseBrand(brand: Brand) {
        self.presentModalChooseBranch(brand: brand)
    }
    
    func callBackChooseBranch(branch: Branch) {
        SettingUtils.getBranchSetting(branchId: branch.id, completion:{
            // map thông tin chi nhanh
            self.avatar_branch.kf.setImage(with: URL(string: Utils.getFullMediaLink(string: branch.image_logo)), placeholder: UIImage(named: "image_defauft_medium"))
            self.lbl_branch_name.text = Constants.branch.name
            self.lbl_branch_address.text =  Constants.branch.address
        })
    }
}
