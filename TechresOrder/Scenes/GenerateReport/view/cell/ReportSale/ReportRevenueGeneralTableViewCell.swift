//
//  ReportRevenueGeneralTableViewCell.swift
//  Techres-Seemt
//
//  Created by macmini_techres_04 on 13/05/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import RxSwift
import Charts


class ReportRevenueGeneralTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_revenue_total_amount: UILabel!
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var root_view_empty_data: UIView!
    
    @IBOutlet weak var lbl_time: UILabel!

    
    
    @IBOutlet weak var reportFilter: ReportFilter!
    
    var datePicker: DatePickerUtils = DatePickerUtils()
    
    var chartItems = [ChartDataEntry]()
    var btnArray:[UIButton] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private(set) var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
//    @IBAction func actionChooseReportType(_ sender: UIButton) {
//        
//        guard let viewModel = self.viewModel else {return}
//        var saleReport = viewModel.saleReport.value
//        saleReport.saleReportData = []
//        saleReport.reportType = sender.tag
//        saleReport.dateString = Constants.REPORT_TYPE_DICTIONARY[sender.tag] ?? ""
//        viewModel.saleReport.accept(saleReport)
//        viewModel.view?.getSaleReport()
//    }
//    

    @IBAction func actionDetail(_ sender: Any) {
        guard let viewModel = self.viewModel else {return}
        viewModel.makeRevenueDetailViewController()
    }
    
    private func handleChooseDate(date:Date,tag:Int){
        guard let viewModel = self.viewModel else {return}
        let dateString = TimeUtils.convertDateToString(from: date, format: .dd_mm_yyyy)
        var report = viewModel.saleReport.value
     
        if tag == -2{
            
            if TimeUtils.isDateValid(fromDateStr: dateString,toDateStr: report.toDate){
                self.reportFilter.setFromDateTitle(dateString)
                report.fromDate = dateString
                report.reportType = 13
                viewModel.saleReport.accept(report)
                viewModel.view?.getSaleReport()
            }else{
                viewModel.view?.showWarningMessage(content: "Ngày bắt đầu không được lớn hơn ngày kết thúc")
            }
          
        }else if tag == -1{
            
            if TimeUtils.isDateValid(fromDateStr: report.fromDate,toDateStr: dateString){
                self.reportFilter.setToDateTitle(dateString)
                report.toDate = dateString
                report.reportType = 13
                viewModel.saleReport.accept(report)
                viewModel.view?.getSaleReport()
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
            
            reportFilter.defaultReportType = viewModel.saleReport.value.reportType
            reportFilter.chooseReportType = { [weak self] reportType in
               var report = viewModel.saleReport.value
               
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
                
                   report.saleReportData = []
                   report.reportType = reportType
                   report.dateString = Constants.REPORT_TYPE_DICTIONARY[reportType] ?? ""
                   viewModel.saleReport.accept(report)
                   viewModel.view?.getSaleReport()
               }
               
           }

           
           viewModel.saleReport.subscribe(onNext: { [weak self] report in
               
               if report.saleReportData.count > 0{
                   self?.setupBarChart(data: report.saleReportData, reportType: report.reportType)
               }
               self?.lbl_revenue_total_amount.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: report.total_revenue)
               self?.root_view_empty_data.isHidden = report.saleReportData.count > 0 ? true :false
           }).disposed(by: disposeBag)
        }
    }
}

extension ReportRevenueGeneralTableViewCell {
    
    func setupBarChart(data: [SaleReportData], reportType: Int) {
        let x_label:[String] = data.enumerated().map{(i,value) in ChartUtils.getXLabel(dateTime: value.report_time, reportType: reportType, dataPointnth:i)}
        ChartUtils.customBarChart(
            chartView: barChartView,
            barChartItems: data.enumerated().map{(i,value) in BarChartDataEntry(x: Double(i), y: Double(value.total_revenue))},
            xLabel: x_label,
            isDateXLabel: reportType == REPORT_TYPE_OPTION_DAY ? false : true
        )
        barChartView.isUserInteractionEnabled = true
        
        let labelHeight = barChartView.xAxis.labelRotatedHeight // use the rotated label height
        let labelRotationAngle = CGFloat(barChartView.xAxis.labelRotationAngle) * .pi / 180 // convert the rotation angle to radians
        let chartHeight = barChartView.frame.origin.y + (CGFloat(barChartView.xAxis.labelCount) * labelHeight * abs(cos(labelRotationAngle)))
        // resize the height of the chart view
        barChartView.frame.size.height = chartHeight
    }
}



