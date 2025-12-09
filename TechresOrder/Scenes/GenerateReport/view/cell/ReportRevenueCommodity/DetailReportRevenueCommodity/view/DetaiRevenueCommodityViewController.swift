//
//  DetaiRevenueCommodityViewController.swift
//  SEEMT
//
//  Created by Huynh Quang Huy on 08/06/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import RxSwift
import Charts

class DetaiRevenueCommodityViewController: BaseViewController {

    var viewModel = DetailReportRevenueCommodityViewModel()
    var router = DetailReportRevenueCommodityRouter()
    
    @IBOutlet weak var bar_chart: BarChartView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var root_view_empty_data: UIView!
    
    @IBOutlet weak var lbl_total_amount: UILabel!

    @IBOutlet weak var reportFilter: ReportFilter!
    var datePicker: DatePickerUtils = DatePickerUtils()
        


    var detailedReport:FoodReportData = FoodReportData.init()!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        viewModel.bind(view: self, router: router)
        viewModel.report.accept(detailedReport)
        registerCellAndBindTableView()
        
        datePicker.chooseDate = { [weak self] (date,tag) in
            self?.handleChooseDate(date: date, tag: tag)
        }
        
        reportFilter.defaultReportType = viewModel.report.value.reportType
        
        reportFilter.chooseReportType = { [weak self] reportType in
            guard let self = self else { return }
            var report = self.viewModel.report.value
           
            if reportType == -1{
               
               
               self.datePicker.showDatePicker(
                    self,
                    date:TimeUtils.convertStringToDate(from: report.fromDate, format: .dd_mm_yyyy),
                    tag:reportType
               )


            }else if reportType == -2{
               
               self.datePicker.showDatePicker(
                    self,
                    date:TimeUtils.convertStringToDate(from: report.toDate, format: .dd_mm_yyyy),
                    tag:reportType
               )

               
            }else if reportType > 0{

               report.reportType = reportType
               report.dateString = Constants.REPORT_TYPE_DICTIONARY[reportType] ?? ""
               viewModel.report.accept(report)
               getRevenueReportCommodity()
            }
           
       }

        
    
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getRevenueReportCommodity()
    }
    
  
    
    @IBAction func actionBack(_ sender: Any) {
        router.navigatePopViewController()
    }
    

    
    
    private func handleChooseDate(date:Date,tag:Int){
      
        let dateString = TimeUtils.convertDateToString(from: date, format: .dd_mm_yyyy)
        var report = viewModel.report.value
     
        if tag == -2{
            if TimeUtils.isDateValid(fromDateStr: dateString,toDateStr: report.toDate){
                self.reportFilter.setFromDateTitle(dateString)
                report.fromDate = dateString
                report.reportType = 13
                viewModel.report.accept(report)
                getRevenueReportCommodity()
            }else{
                viewModel.view?.showWarningMessage(content: "Ngày bắt đầu không được lớn hơn ngày kết thúc")
            }
          
        }else if tag == -1{
            if TimeUtils.isDateValid(fromDateStr: report.fromDate,toDateStr: dateString){
                self.reportFilter.setToDateTitle(dateString)
                report.toDate = dateString
                report.reportType = 13
                viewModel.report.accept(report)
                getRevenueReportCommodity()
            }else{
                viewModel.view?.showWarningMessage(content: "Ngày bắt đầu không được lớn hơn ngày kết thúc")
            }
        }
        
    }
    
    
}
