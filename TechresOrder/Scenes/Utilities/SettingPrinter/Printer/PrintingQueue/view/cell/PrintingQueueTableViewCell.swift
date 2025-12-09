//
//  PrintingQueueTableViewCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 25/06/2024.
//

import UIKit

class PrintingQueueTableViewCell: UITableViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbl_printer: UILabel!
    @IBOutlet weak var lbl_orderId: UILabel!
    @IBOutlet weak var lbl_itemList: UILabel!
//    @IBOutlet weak var lbl_lastItem: UILabel!
    @IBOutlet weak var lbl_retried_number: UILabel!
    @IBOutlet weak var lbl_print_type: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func actionPrint(_ sender: Any) {
        guard let data = self.data else {
            return
        }
        
        switch data.type {
            case .wifi:
                if let item = data.item as? WIFIQueuedItemObject{
                    PrinterUtils.shared.print(wifiQueuedItem: WIFIQueuedItem(wifiQueuedItem: item))
                }
               
            default:
                if let item = data.item as? TSCQueuedItemObject{
                    PrinterUtils.shared.print(tscQueuedItem: TSCQueuedItem(tscQueuedItem: item))
                }
        }
                
    }
    
    @IBAction func actionDelete(_ sender: Any) {
        
        guard let data = self.data else {
            return
        }
        
        switch data.type {
            case .wifi:
                if let item = data.item as? WIFIQueuedItemObject{
                    LocalDataBaseUtils.shared.UpdateWifiQueuedItemToFinish(id: item.id)
                }
               
            default:
                if let item = data.item as? TSCQueuedItemObject{
                    LocalDataBaseUtils.shared.UpdateTSCQueuedItemToFinish(id: item.id)
                }
        }

    }
    
    var data:(type:itemType,item:Any)?{
        didSet{
            if let data = self.data{
                switch data.type {
                    case .wifi:
                        if let item = data.item as? WIFIQueuedItemObject{
                            mapWifiItem(item:item)
                        }
                       
                    default:
                        if let item = data.item as? TSCQueuedItemObject{
                            mapTSCItem(item:item)
                        }

                }
            }
        }
    }

        
    private func mapTSCItem(item:TSCQueuedItemObject){
        
        var image:UIImage = UIImage()
        
        for data in item.data{
            image = MediaUtils.combineScreenshots(image, UIImage(data: data)) ?? UIImage()
        }
        
        img.image = image
        lbl_printer.text = item.printer?.printer_name ?? ""
        lbl_orderId.text = String(format: "#%d", item.orderId)
        var itemNames = ""
        
        lbl_itemList.text = itemNames
        lbl_retried_number.text = String(format: "RetriedNumber: %d/10 \n(%@)", item.retryNumber, item.isFinished ? "finished" : "unfinish")
        lbl_retried_number.isHidden = item.printMode != .printBackgroundWithRetry
        
        
        lbl_print_type.text = item.printMode == .printForeground ? "Print Foreground" : "Print Background"
    }
    

    private func mapWifiItem(item:WIFIQueuedItemObject){
             
        img.image = UIImage(data: item.data)

        lbl_printer.text = item.printer?.printer_name ?? ""
        lbl_orderId.text = String(format: "#%d", item.orderId)
        var itemNames = ""
        
        for (i,data) in item.items.enumerated(){
            itemNames += i == item.items.count-1 ? data.name : (data.name + " \n")
        }
        
        lbl_itemList.text = itemNames
        lbl_retried_number.text = String(format: "RetriedNumber: %d/10 \n(%@)", item.retryNumber, item.isFinished ? "finished" : "unfinish")
        lbl_retried_number.isHidden = item.printMode != .printBackgroundWithRetry
        lbl_print_type.text = item.printMode == .printForeground ? "Print Foreground" : "Print Background"
    }
    
}
