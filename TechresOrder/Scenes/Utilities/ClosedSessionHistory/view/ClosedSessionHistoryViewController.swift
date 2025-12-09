//
//  ClosedSessionHistoryViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 16/06/2025.
//

import UIKit

class ClosedSessionHistoryViewController: BaseViewController {
   
  
    
    @IBOutlet weak var text_field_search: UITextField!
    
    @IBOutlet weak var lbl_from_date: UILabel!
    @IBOutlet weak var lbl_to_date: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var view_nodata: UIView!
    
    let refreshControl = UIRefreshControl()
    
    var viewModel = ClosedSessionHistoryViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self)
        setup()
        getClosedSessionHistory()
    }
    
    
    @IBAction func actionChooseFromDate(_ sender: UIButton) {
        
        let date = TimeUtils.convertStringToDate(from: viewModel.APIParameter.value.from_date, format: .dd_mm_yyyy)
        DatePickerUtils.shared.showDatePicker(self,date: date)
        viewModel.dateType.accept(1)
    }
    
    @IBAction func actionChooseToDate(_ sender: UIButton) {
        
        let date = TimeUtils.convertStringToDate(from: viewModel.APIParameter.value.to_date, format: .dd_mm_yyyy)
        DatePickerUtils.shared.showDatePicker(self,date: date)
        viewModel.dateType.accept(2)
    }
    
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    

}
