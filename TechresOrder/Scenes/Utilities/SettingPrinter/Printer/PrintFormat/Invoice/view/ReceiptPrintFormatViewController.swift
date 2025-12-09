//
//  ReceiptPrintFormatViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 21/12/2023.
// https://download4.epson.biz/sec_pubs/pos/reference_en/index.html

import UIKit
import JonAlert

class ReceiptPrintFormatViewController: UIViewController,UITableViewDataSource {
  
    @IBOutlet weak var scrollView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    
    @IBOutlet weak var lbl_name_of_food_app_partner: UILabel!
    
    @IBOutlet weak var lbl_restaurant_name: UILabel!
    
    @IBOutlet weak var lbl_title: UILabel!
    
    @IBOutlet weak var lbl_table_type: UILabel!
    
    @IBOutlet weak var lbl_address: UILabel!
    
    @IBOutlet weak var lbl_hotline: UILabel!
    
    @IBOutlet weak var view_of_table_name: UIStackView!
    @IBOutlet weak var lbl_reprint_number: UILabel!
    @IBOutlet weak var lbl_table_name: UILabel!
    
    @IBOutlet weak var view_of_employee_name: UIView!
    @IBOutlet weak var lbl_employee_name: UILabel!
    
    @IBOutlet weak var view_of_customer_name: UIView!
    @IBOutlet weak var lbl_customer_name: UILabel!
    
    @IBOutlet weak var view_of_customer_phone: UIView!
    @IBOutlet weak var lbl_customer_phone: UILabel!
    
    @IBOutlet weak var view_of_customer_address: UIView!
    @IBOutlet weak var lbl_customer_address: UILabel!

    
    @IBOutlet weak var view_of_saler: UIView!
    @IBOutlet weak var lbl_saler: UILabel!
    
    @IBOutlet weak var view_of_accumulative_point: UIView!
    @IBOutlet weak var lbl_accumulative_point: UILabel!
    
    
    @IBOutlet weak var view_of_date: UIView!
    @IBOutlet weak var lbl_date: UILabel!
    //===================title==================
    @IBOutlet weak var topline_of_title: UIView!
    @IBOutlet weak var lbl_title_SL: UILabel!
    @IBOutlet weak var lbl_title_DG: UILabel!
    
    
    @IBOutlet weak var view_of_tableView: UIView!
    
    @IBOutlet weak var topLine_of_tableView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var underLine_of_tableView: UIView!
    @IBOutlet weak var height_of_table: NSLayoutConstraint!

    //===================tặng==================
    @IBOutlet weak var view_of_gift: UIView!
    @IBOutlet weak var lbl_total_gifted: UILabel!
    
    //===================Tổng hoá đơn==================
    @IBOutlet weak var lbl_title_total_payment: UILabel!
    @IBOutlet weak var lbl_total_payment: UILabel!
    
    //=========================Điểm sử dụng==================================
    @IBOutlet weak var view_of_used_point: UIView!
    
    //===================service Charge==================
    @IBOutlet weak var view_of_service_charge: UIView!
    @IBOutlet weak var lbl_total_service_charge: UILabel!
    
    //===================extra Charge==================
    @IBOutlet weak var view_of_extra_charge: UIView!
    @IBOutlet weak var lbl_total_extra_charge: UILabel!
    
    //===================VAT==================
    @IBOutlet weak var stackview_of_vat: UIStackView!

    @IBOutlet weak var lbl_vat_title: UILabel!
    @IBOutlet weak var lbl_total_vat: UILabel!
    
    //===================Discount==================
    
    @IBOutlet weak var stack_view_of_discount: UIStackView!
    @IBOutlet weak var lbl_discount_percent: UILabel!
    @IBOutlet weak var lbl_total_discount: UILabel!
    @IBOutlet weak var view_of_discount_detail: UIView!
    
    @IBOutlet weak var lbl_discount_percent_of_food: UILabel!
    @IBOutlet weak var lbl_discount_percent_of_drink: UILabel!
    
    //=========================coupon==================================
    @IBOutlet weak var lbl_coupon_amount: UILabel!
    @IBOutlet weak var view_of_coupon: UIView!
    

    //=========================tiền đặt cọc==================================
    @IBOutlet weak var deposit_amount: UILabel!
    @IBOutlet weak var view_of_deposit: UIView!
    
    
    //=====================Payment======================================================
    @IBOutlet weak var view_of_net_payment: UIView!
    @IBOutlet weak var net_payment: UILabel!
    @IBOutlet weak var title_net_payment: UILabel!
    
    //=========================tiền khách trả==================================
    @IBOutlet weak var view_of_return_amount: UIView!
    @IBOutlet weak var returned_amount: UILabel!
    
    //=========================tiền khách thừa==================================
    @IBOutlet weak var view_of_change_amount: UIView!
    @IBOutlet weak var change_amount: UILabel!
    
    //=========================QR code==================================
    @IBOutlet weak var container_view_of_qr_code: UIView!
    @IBOutlet weak var topLine_of_qr_code: UIView!
    @IBOutlet weak var qr_code_view: UIView!
    @IBOutlet weak var qr_code_img_view:UIImageView?
    @IBOutlet weak var underLine_of_qr_code: UIView!
    
    @IBOutlet weak var stack_view_of_bank_info: UIStackView!
    @IBOutlet weak var lbl_account_number: UILabel!
    @IBOutlet weak var lbl_bank: UILabel!
    @IBOutlet weak var lbl_account_holder: UILabel!
    
    //=========================greeting==================================

    @IBOutlet weak var topline_of_greeting: UIView!
    @IBOutlet weak var view_of_greeting: UIView!
    @IBOutlet weak var view_of_vat_content: UIView!
    @IBOutlet weak var vat_content: UILabel!
    @IBOutlet weak var greeting_content: UILabel!
    @IBOutlet weak var top_contraint_of_greeting_content: NSLayoutConstraint!
    
    //=========================greeting==================================
    @IBOutlet weak var view_of_copy_right: UIView!
    

    
    
    var viewModel = ReceiptPrintFormatViewModel()
    var printer = Printer()
    //MARK: order from techres order app
    var order:OrderDetail? = nil
    var bankAccount:BankAccount?
    var completeHandler:(()->Void)? = nil
    var printMode:PRINT_MODE = .printForeground
    let textColor:UIColor = .systemGray4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self)
        registerCell()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)

        if let order = self.order{
            
            if let bankAccount = self.bankAccount {

                
                if bankAccount.payment_type == .payos{
                    
                    setupBill(order:order,bankAccount: bankAccount)
                    performWorkItem(printer:printer)
                    finishAndRemoveViewController()
                }else{
                    
                    fetchQRCodeImage(from: bankAccount.qr_code) { [weak self] image in
                        guard let self = self else { return }
                        
                        if let image = image {
                            self.qr_code_img_view?.image = MediaUtils.invertQRCodeColors(image: image)
                        }
                        
                        self.setupBill(order:order,bankAccount: bankAccount)
                        self.performWorkItem(printer:self.printer)
                        finishAndRemoveViewController()
                    }
                }
                
            }else{
                
                self.dismiss(animated: true, completion: {
                    JonAlert.showError(message: "Chưa có thông tin tài khoản ngân hàng để thanh toán")
                })

            }
        }else{
            dLog("asdjkhsajkdhsa")
        }
        
//        tableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    private func finishAndRemoveViewController(){
        DispatchQueue.main.async {
            self.completeHandler?()
            self.willMove(toParent: nil)
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }
    
    
 
    
}







