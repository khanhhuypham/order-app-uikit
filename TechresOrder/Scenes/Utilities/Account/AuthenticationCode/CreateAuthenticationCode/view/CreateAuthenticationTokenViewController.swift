//
//  CreateAuthenticationTokenViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 13/8/25.
//

import UIKit

class CreateAuthenticationTokenViewController: BaseViewController {
    
    
    @IBOutlet weak var lbl_title: UILabel!
    
    @IBOutlet weak var lbl_code: UILabel!

    @IBOutlet weak var btn_copy: UIButton!
    @IBOutlet weak var lbl_expire_at: UILabel!
    @IBOutlet weak var btn_create: UIButton!
    
    internal var countdownTimer: Timer?
    var data = AuthenticationToken()
    override func viewDidLoad() {
        super.viewDidLoad()
        mapData()
        // Do any additional setup after loading the view.
        
        countdownTimer?.invalidate()
        countdownTimer = nil
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else {
                return
            }
            
            self.lbl_title.text = String(
                format:"Mã token sẽ hết hạn sau %ds. Lưu ý không chia sẻ mã token cho người lạ, xin cảm ơn!",
                TimeUtils.getRemainingSeconds(from: self.data.expire_at)
            )
        }
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        countdownTimer?.invalidate()
        countdownTimer = nil
    }
    
    func mapData(){
        lbl_title.text = String(format:"Mã token sẽ hết hạn sau %ds. Lưu ý không chia sẻ mã token cho người lạ, xin cảm ơn!", TimeUtils.getRemainingSeconds(from: data.expire_at))
        lbl_code.text = data.code
        lbl_expire_at.text = String(format:"Thời gian hết hạn: %@", data.expire_at)
        
        let attr:NSAttributedString = Utils.setAttributesForBtn(
            content: "HUỶ MÃ",
            attributes: [
                .font: UIFont.systemFont(ofSize: 18, weight: .bold),
                .foregroundColor: UIColor.white
            ]
        )
        btn_create.setAttributedTitle(attr,for: .normal)
        btn_create.backgroundColor = ColorUtils.red_600()
        
    }

  
    
    private func randomString(length: Int = 6) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).compactMap { _ in characters.randomElement() })
    }

    
    @IBAction func actionBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionCopy(_ sender: Any) {
        // write to clipboard
        UIPasteboard.general.string = data.code
        
        self.showSuccessMessage(content: "Copy thành công")
    }
    
    
    @IBAction func actionChangeStatus(_ sender: Any) {
        changeStatusOfAuthenticationCode(id:data.id)
    }
    
    
}
