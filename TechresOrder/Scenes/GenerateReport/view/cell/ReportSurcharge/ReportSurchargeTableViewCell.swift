//
//  ReportSurchargeTableViewCell.swift
//  Techres-Seemt
//
//  Created by Nguyen Thanh Vinh on 16/05/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import RxSwift
import Charts
import ObjectMapper
class ReportSurchargeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var line_chart_view: LineChartView!
    @IBOutlet weak var lbl_total_amount: UILabel!
    @IBOutlet weak var root_view_empty_data: UIView!

    @IBOutlet weak var reportFilter: ReportFilter!
    var datePicker: DatePickerUtils = DatePickerUtils()
    
    var lineChartItems = [ChartDataEntry]()

    
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
        var report = viewModel.surchargeReport.value
     
        if tag == -2{
            if TimeUtils.isDateValid(fromDateStr: dateString,toDateStr: report.toDate){
                self.reportFilter.setFromDateTitle(dateString)
                report.fromDate = dateString
                report.reportType = 13
                viewModel.surchargeReport.accept(report)
                viewModel.view?.getReportSurcharge()
            }else{
                viewModel.view?.showWarningMessage(content: "Ngày bắt đầu không được lớn hơn ngày kết thúc")
            }
          
        }else if tag == -1{
            if TimeUtils.isDateValid(fromDateStr: report.fromDate,toDateStr: dateString){
                self.reportFilter.setToDateTitle(dateString)
                report.toDate = dateString
                report.reportType = 13
                viewModel.surchargeReport.accept(report)
                viewModel.view?.getReportSurcharge()
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

            reportFilter.defaultReportType = viewModel.surchargeReport.value.reportType
            
            reportFilter.chooseReportType = { [weak self] reportType in
                
                var report = viewModel.surchargeReport.value

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
                    
                    report.surchargeReportData = []
                    report.reportType = reportType
                    report.dateString = Constants.REPORT_TYPE_DICTIONARY[reportType] ?? ""
                    viewModel.surchargeReport.accept(report)
                    viewModel.view?.getReportSurcharge()
                    
                }
              
            }
            
            
            viewModel.surchargeReport.subscribe( onNext: { [self] report in
                lbl_total_amount.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: report.total_amount)
                root_view_empty_data.isHidden =  report.surchargeReportData.count > 0 ? true : false
                if report.surchargeReportData.count > 0{setupLineChart(dataChart: report.surchargeReportData,reportType: report.reportType)}
            }).disposed(by: disposeBag)
            
            
        }
    }
    
}


extension ReportSurchargeTableViewCell {

    func setupLineChart(dataChart:[SurchargeReportData],reportType:Int) {

        lineChartItems.removeAll()

        lineChartItems = dataChart.enumerated().map{(i,value) in ChartDataEntry(x: Double(i), y: Double(value.total_amount))}
    
        var x_label:[String] = dataChart.enumerated().map{(i,value) in ChartUtils.getXLabel(dateTime: value.report_time, reportType: reportType, dataPointnth:i)}
        ChartUtils.customLineChart(
            chartView: line_chart_view,
            entries: lineChartItems,
            x_label: dataChart.enumerated().map{(i,value) in ChartUtils.getXLabel(dateTime: value.report_time, reportType: reportType, dataPointnth:i)},
            labelCount: ChartUtils.setLabelCountForChart(reportType: reportType, totalDataPoint: dataChart.count),
            horizontalScroll: reportType == REPORT_TYPE_OPTION_DAY ? true : false
        )

        // MARK: Handle click show tooltip
        // Set the extraTopOffset property to add padding
        line_chart_view.extraTopOffset = 30.0
    }
}
