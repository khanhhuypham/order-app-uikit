//
//  LoginViewController.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 12/01/2023.
//

import UIKit
import RxSwift
import ObjectMapper
import LocalAuthentication
import JonAlert

class LoginViewController: BaseViewController{
    // MARK: - IBOutlet -
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var childView: UIView!
    @IBOutlet weak var viewDevMode: UIView!
    
    @IBOutlet weak var btn_online_mode: UIButton!
    @IBOutlet weak var btn_offline_mode: UIButton!
    
    
    var viewModel = LoginViewModel()
    var router = LoginRouter()

    override func viewDidLoad() {

        super.viewDidLoad()
        viewModel.bind(view: self, router: router)

        
        registerDeviceUDID()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.someActionDevMode(_:)))
        gesture.numberOfTapsRequired = 12
        viewDevMode.addGestureRecognizer(gesture)
        
        
        //Subscribe to a Notification which will fire before the keyboard will show
        subscribeToNotification(UIResponder.keyboardWillShowNotification, selector: #selector(keyboardWillShowOrHide))

        //Subscribe to a Notification which will fire before the keyboard will hide
        subscribeToNotification(UIResponder.keyboardWillHideNotification, selector: #selector(keyboardWillShowOrHide))
                

        if ManageCacheObject.getEnvironment() == .offline{
            actionChangeEnvironmentMode(btn_offline_mode)
        }else{
            actionChangeEnvironmentMode(btn_online_mode)
        }
    }


    
    @objc private func someActionDevMode(_ sender: UITapGestureRecognizer) {
        presentModalDevMode()
    }
    
    @IBAction func actionChangeEnvironmentMode(_ sender: UIButton) {
        switch sender.tag{
            case 0:
                let vc = LoginOnlineViewController(nibName: "LoginOnlineViewController", bundle: Bundle.main)
                environmentMode = .online
                vc.view.backgroundColor = .clear
                addViewController(parent:self,child: vc)
                btn_online_mode.backgroundColor = ColorUtils.orange_brand_900()
                btn_offline_mode.backgroundColor = .systemGray5
         
                break
                
            case 1:
              
                let vc = LoginOfflineViewController(nibName: "LoginOfflineViewController", bundle: Bundle.main)
                environmentMode = .offline
                vc.view.backgroundColor = .clear
                addViewController(parent:self,child: vc)
                btn_online_mode.backgroundColor = .systemGray5
                btn_offline_mode.backgroundColor = ColorUtils.orange_brand_900()
                break
            
            default:
                let vc = LoginOnlineViewController(nibName: "LoginOnlineViewController", bundle: Bundle.main)
                environmentMode = .online
                vc.view.backgroundColor = .clear
                addViewController(parent:self,child: vc)
                btn_online_mode.backgroundColor = ColorUtils.orange_brand_900()
                btn_offline_mode.backgroundColor = .systemGray5
                break;
        }

    }
    
    
    @IBAction func actionRegisterAccount(_ sender: Any) {
          presentDialogRegisterAccountViewController()
    }
    
    
    private func addViewController(parent:UIViewController,child: UIViewController) {
        
        children.forEach({
          $0.willMove(toParent: nil)
          $0.view.removeFromSuperview()
          $0.removeFromParent()
        })

        parent.addChild(child)

        childView.addSubview(child.view)
        
        child.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            child.view.topAnchor.constraint(equalTo: childView.topAnchor, constant: 0),
            child.view.leadingAnchor.constraint(equalTo: childView.leadingAnchor),
            child.view.trailingAnchor.constraint(equalTo: childView.trailingAnchor),
            child.view.bottomAnchor.constraint(equalTo: childView.bottomAnchor, constant: 0)
        ])
        
        child.didMove(toParent: parent)
    }
   
    
    func registerDeviceUDID(){
        // Get data from Server
        viewModel.registerDeviceUDID().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                dLog("Register Device UDID Success...")
            }
         
        }).disposed(by: rxbag)
    }
    
    

}



extension LoginViewController {

    func initializeHideKeyboard(){
        //Declare a Tap Gesture Recognizer which will trigger our dismissMyKeyboard() function
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))

        //Add this tap gesture recognizer to the parent view
        view.addGestureRecognizer(tap)
    }

    @objc func dismissMyKeyboard(){
        //endEditing causes the view (or one of its embedded text fields) to resign the first responder status.
        //In short- Dismiss the active keyboard.
        view.endEditing(true)
    }
}

extension LoginViewController {

    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }

    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }

    
    @objc func keyboardWillShowOrHide(notification: NSNotification) {
        guard let childView = childView,
              let userInfo = notification.userInfo,
              let endValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let durationValue = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber,
              let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber else {
            return
        }

        let endRect = view.convert(endValue.cgRectValue, from: view.window)
        let keyboardOverlap = max(0, childView.frame.maxY - endRect.origin.y)

        let duration = durationValue.doubleValue
        let options = UIView.AnimationOptions(rawValue: UInt(curveValue.intValue << 16))

        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            self.childView?.transform = CGAffineTransform(translationX: 0, y: -keyboardOverlap)
        }, completion: nil)
    }


}

