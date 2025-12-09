//
//  LoginOnlineViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 12/8/25.
//

import UIKit
import LocalAuthentication
class LoginOnlineViewController: BaseViewController {
    
    
    @IBOutlet weak var root_view: UIStackView!
    @IBOutlet weak var text_field_restaurant: UITextField!
    @IBOutlet weak var lbl_error_restaurant: UILabel!
    
    @IBOutlet weak var view_of_account: UIView!
    @IBOutlet weak var text_field_account: UITextField!
    @IBOutlet weak var lbl_account_error: UILabel!
    
    @IBOutlet weak var view_of_password: UIView!
    @IBOutlet weak var text_field_password: UITextField!
    @IBOutlet weak var lbl_error_pwd: UILabel!
    @IBOutlet weak var btn_hide_password: UIButton!
    
    
    @IBOutlet weak var view_of_code: UIView!
    @IBOutlet weak var text_field_code: UITextField!
    @IBOutlet weak var lbl_error_code: UILabel!
    
    @IBOutlet weak var btn_login_using_code: UIButton!
    @IBOutlet weak var btn_login: UIButton!
    
    
    @IBOutlet weak var image_biometric: UIImageView!
    @IBOutlet weak var btn_forgot_password: UIButton!
    @IBOutlet weak var btn_faceid: UIButton!
    @IBOutlet weak var view_faceid: UIView!
    

    

    // MARK: - Variable - User -
    var context = LAContext()
    var err: NSError?
    
    var viewModel = LoginOnlineViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self)
        firstSetup()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "changedPassword"), object: nil)
    }
    


    @IBAction func actionShowPassword(_ sender: Any) {
        text_field_password.isSecureTextEntry.toggle()
        btn_hide_password.setImage(
            UIImage(named:text_field_password.isSecureTextEntry ? "icon_eye_pass" : "eye"),
            for: .normal
        )

    }
    
    @IBAction func actionLogin(_ sender: Any) {
        self.getSessions()
    }
    
    
    @IBAction func actionLoginUsingCode(_ sender: Any) {
        viewModel.isLoginUsingCode.accept(!viewModel.isLoginUsingCode.value)
       
        text_field_code.text = ""
        text_field_password.text = ""
        viewModel.code.accept("")
        viewModel.password.accept("")
     
        if viewModel.isLoginUsingCode.value{
            btn_login_using_code.setTitle("Đăng nhập bằng tài khoản", for: .normal)
            
            view_of_account.isHidden = true
            view_of_password.isHidden = true
            view_of_code.isHidden = false
        }else{
            btn_login_using_code.setTitle("Đăng nhập bằng mã code", for: .normal)
            
            view_of_account.isHidden = false
            view_of_password.isHidden = false
            view_of_code.isHidden = true
        }
 
    }
    
    @IBAction func actionForgotPassword(_ sender: Any) {
     
        navigationController?.pushViewController(ResetPasswordViewController(), animated: true)
    }
    
   
    
    
    
    @IBAction func actionLoginBiometric(_ sender: Any) {
        
        let localString =  "Biometric Authentication"
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &err){
            if Constants.savedLoginInfor.username == "" || ManageCacheObject.getPassword() == "" {
                let alert = UIAlertController(title: "THÔNG BÁO" , message: "Tính năng chỉ có thể sử dụng lần đăng nhập kế tiếp", preferredStyle:.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: localString){ [self]
                    (success, error) in
                    if success{
                        DispatchQueue.main.async {
                            self.viewModel.isLoginFace.accept(true)
                            getSessions()
                        }
                    }
                }
            }

        }
    }
    
   
    
    

}
