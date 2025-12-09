//
//  CodeAuthenticationTableViewCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 13/8/25.
//

import UIKit

class CodeAuthenticationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbl_token: UILabel!
    @IBOutlet weak var lbl_expire_at: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var viewModel: CodeAuthenticationViewModel?
    
    
    public var data: AuthenticationToken? = nil{
        didSet{
            
            if let data = self.data{
                lbl_token.text = data.code
                lbl_expire_at.text = data.expire_at

            }
        }
    }
    
    @IBAction func actionCopy(_ sender: Any) {
        guard let viewModel = self.viewModel,let data = self.data else {
            return
        }
        UIPasteboard.general.string = data.code
        
        viewModel.view?.showSuccessMessage(content: "Copy thành công")
    }
    
    
    
    @IBAction func actionChangeStatus(_ sender: Any) {
        guard let viewModel = self.viewModel,let data = self.data else {
            return
        }
        
        viewModel.view?.changeStatusOfAuthenticationCode(id: data.id)
        
    }
    
    
    
}
