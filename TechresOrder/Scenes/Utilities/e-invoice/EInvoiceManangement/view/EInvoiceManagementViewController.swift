//
//  EInvoiceManagementViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 07/06/2025.
//

import UIKit

class EInvoiceManagementViewController: BaseViewController {
    

    @IBOutlet weak var btn_waiting_to_export: UIButton!
    @IBOutlet weak var btn_waiting_to_approve: UIButton!
    @IBOutlet weak var btn_approved: UIButton!
    @IBOutlet weak var underline_of_waiting_to_export: UIView!
    @IBOutlet weak var underline_of_waiting_to_approve: UIView!
    @IBOutlet weak var underline_of_approved: UIView!
    
    @IBOutlet weak var text_field_search: UITextField!
    @IBOutlet weak var btn_today: UIButton!
    @IBOutlet weak var btn_yesterday: UIButton!
    @IBOutlet weak var btn_this_week: UIButton!
    @IBOutlet weak var btn_this_month: UIButton!
    @IBOutlet weak var btn_last_month: UIButton!
    @IBOutlet weak var btn_last_three_month: UIButton!
    @IBOutlet weak var btn_this_year: UIButton!
    @IBOutlet weak var btn_last_year: UIButton!
    @IBOutlet weak var btn_last_three_year: UIButton!
    @IBOutlet weak var btn_all_year: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var view_nodata: UIView!
    
    var viewModel = EInvoiceManagementViewModel()
    var router = EInvoiceManagementRouter()
    var btnShowMore = UIButton()
    var btnArray:[UIButton] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        viewModel.bind(view: self,router: router)
        setup()
        
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func actionChooseTabType(_ sender: UIButton) {
        var apiParameter = viewModel.APIParameter.value
        
        
        switch sender.tag{
            case 1:
                changeBtnBackground(btn: sender, underlineView: underline_of_waiting_to_export)
                apiParameter.cct_duyet = 0
                apiParameter.invoice_status = 0
            
            case 2:
                changeBtnBackground(btn: sender, underlineView: underline_of_waiting_to_approve)
                apiParameter.cct_duyet = 0
                apiParameter.invoice_status = 1
            
            case 3:
                changeBtnBackground(btn: sender, underlineView: underline_of_approved)
                apiParameter.cct_duyet = 1
                apiParameter.invoice_status = 1
            
            default:
                break
        }
        viewModel.tabType.accept(sender.tag)
        viewModel.APIParameter.accept(apiParameter)
        viewModel.clearDataAndCallAPI()
        
    }
    
    @IBAction func actionChooseReportType(_ sender: UIButton) {
        let reportType = REPORT_TYPE(rawValue: sender.tag) ?? .today
        var apiParameter = viewModel.APIParameter.value
        apiParameter.from_date = reportType.from_date
        apiParameter.to_date = reportType.to_date
        viewModel.APIParameter.accept(apiParameter)
        viewModel.clearDataAndCallAPI()
    }
    
    
    private func changeBtnBackground(btn:UIButton,underlineView:UIView){
        btn_waiting_to_export.titleLabel?.textColor = ColorUtils.green_200()
        btn_waiting_to_approve.titleLabel?.textColor = ColorUtils.green_200()
        btn_approved.titleLabel?.textColor = ColorUtils.green_200()

        underline_of_waiting_to_export.isHidden = true
        underline_of_waiting_to_approve.isHidden = true
        underline_of_approved.isHidden = true
        
        btn.titleLabel?.textColor = ColorUtils.green_600()
        underlineView.isHidden = false
    }
    

}
