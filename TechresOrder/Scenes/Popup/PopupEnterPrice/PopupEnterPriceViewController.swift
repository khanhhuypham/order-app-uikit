//
//  PopupEnterPriceViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 21/06/2025.
//

import UIKit

class PopupEnterPriceViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var root_view: UIView!
    @IBOutlet weak var textFieldEnterPrice: UITextField!
    var delegate:PopupEnterPriceViewControllerDelegate? = nil
    var id:Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldEnterPrice.delegate = self
        textFieldEnterPrice.keyboardType = .numberPad
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOutSide(_:)))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func handleTapOutSide(_ gesture:UIGestureRecognizer){
        let tapLocation = gesture.location(in: root_view)
        if !root_view.bounds.contains(tapLocation){
           dismiss(animated: true)
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text as NSString? else { return true }

        // Get only digits from the updated string
        let updatedText = currentText.replacingCharacters(in: range, with: string)
            .components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()

        // Convert to formatted string
        if let number = Int(updatedText) {
            textField.text = number.toString
        } else {
            textField.text = ""
        }

        return false // We already updated the text
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func actionConfirm(_ sender: Any) {
        
        dismiss(animated: true,completion: {
            
            guard let rawText = self.textFieldEnterPrice.text else { return }
                 
            let numericText = rawText.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()

            if let number = Int(numericText) {
       
        
                self.delegate?.callbackToAdjustedPrice(id:self.id,price:number)
                
             // You can now use `number` safely
            } else {
                dLog("Invalid or empty number")
            }
                
        })
        
    }

}
