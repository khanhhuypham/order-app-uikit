//
//  ReportRevenueEmployeeTableViewCell.swift
//  Techres-Seemt
//
//  Created by Huynh Quang Huy on 13/07/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import RxSwift
import Charts

class ReportRevenueEmployeeTableViewCell: UITableViewCell {

    @IBOutlet weak var bar_chart: BarChartView!
    @IBOutlet weak var lbl_total_amount: UILabel!
    @IBOutlet weak var root_view_empty_data: UIView!
    
    // MARK: Biến của button filter
    // MARK: Biến của button filter
    @IBOutlet weak var reportFilter: ReportFilter!
    var datePicker: DatePickerUtils = DatePickerUtils()

    
    private(set) var disposeBag = DisposeBag()
        override func prepareForReuse() {
            super.prepareForReuse()
            disposeBag = DisposeBag()
        }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)

        // Configure the view for the selected state
    }

    
    private func handleChooseDate(date:Date,tag:Int){
        guard let viewModel = self.viewModel else {return}
        let dateString = TimeUtils.convertDateToString(from: date, format: .dd_mm_yyyy)
        var report = viewModel.employeeRevenueReport.value
     
        if tag == -2{
            if TimeUtils.isDateValid(fromDateStr: dateString,toDateStr: report.toDate){
                self.reportFilter.setFromDateTitle(dateString)
                report.fromDate = dateString
                report.reportType = 13
                viewModel.employeeRevenueReport.accept(report)
                viewModel.view?.getReportRevenueEmployee()
            }else{
                viewModel.view?.showWarningMessage(content: "Ngày bắt đầu không được lớn hơn ngày kết thúc")
            }
          
        }else if tag == -1{
            if TimeUtils.isDateValid(fromDateStr: report.fromDate,toDateStr: dateString){
                self.reportFilter.setToDateTitle(dateString)
                report.toDate = dateString
                report.reportType = 13
                viewModel.employeeRevenueReport.accept(report)
                viewModel.view?.getReportRevenueEmployee()
            }else{
                viewModel.view?.showWarningMessage(content: "Ngày bắt đầu không được lớn hơn ngày kết thúc")
            }
        }
        
    }
    
        
    var viewModel: GenerateReportViewModel? {
           didSet {
               guard let viewModel = self.viewModel else {return}
               

                datePicker.chooseDate = { [weak self] (date,tag) in
                   self?.handleChooseDate(date: date, tag: tag)
                }
                
                reportFilter.defaultReportType = viewModel.employeeRevenueReport.value.reportType

                reportFilter.chooseReportType = { [weak self] reportType in
                  var report = viewModel.employeeRevenueReport.value
                  
                  if reportType == -1{
                      
                      if let view = viewModel.view{
                          
                          self?.datePicker.showDatePicker(
                               view,
                               date:TimeUtils.convertStringToDate(from: report.toDate, format: .dd_mm_yyyy),
                               tag:reportType
                          )
                       
                      }
                   
                  }else if reportType == -2{
                      
                      if let view = viewModel.view{
                          
                          self?.datePicker.showDatePicker(
                               view,
                               date:TimeUtils.convertStringToDate(from: report.fromDate, format: .dd_mm_yyyy),
                               tag:reportType
                          )
                       
                      }
                   
                      
                  }else if reportType > 0{
                      report.reportData = []
                      report.reportType = reportType
                      report.dateString = Constants.REPORT_TYPE_DICTIONARY[reportType] ?? ""
                      viewModel.employeeRevenueReport.accept(report)
                      viewModel.view?.getReportRevenueEmployee()
                  }
                  
                }

               
               viewModel.employeeRevenueReport.subscribe( // Thực hiện subscribe Observable data by food
                   onNext: { [weak self] report in
                       self?.lbl_total_amount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(report.total_revenue))
                       self?.setUpBarChart(dataChart: report.reportData)
                       self?.root_view_empty_data.isHidden = report.reportData.count > 0 ? true : false
                }).disposed(by: disposeBag)

           }
    }
    
    @IBAction func actionDetail(_ sender: Any) {
        guard let viewModel = self.viewModel else {return}
        viewModel.makeToDetailReportRevenueEmployeeViewController()
    }
}


