//
//  ClosedSessionHistoryTableViewCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 17/06/2025.
//

import UIKit

class ClosedSessionHistoryTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lbl_content: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    public var data: WorkingSessionValue? = nil{
        didSet{
            
            if let data = self.data{
                
                lbl_content.text = String(
                    format: "Mã: #%d\nNV mở ca: %@\nNV đóng ca: %@\nThời gian mở ca: %@\nThời gian đóng ca: %@",
                    data.id,
                    data.open_employee_name,
                    data.close_employee_name,
                    data.open_time,
                    data.close_time
                )
                
                
            }
        }
    }
    
}
