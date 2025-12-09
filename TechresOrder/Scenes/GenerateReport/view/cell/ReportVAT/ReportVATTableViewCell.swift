//
//  ReportVATTableViewCell.swift
//  Techres-Seemt
//
//  Created by Huynh Quang Huy on 14/04/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import RxSwift
import Charts
import ObjectMapper
class ReportVATTableViewCell: UITableViewCell {
    
    @IBOutlet weak var line_chart_view: LineChartView!
    @IBOutlet weak var root_view_empty_data: UIView!
    @IBOutlet weak var lbl_total_amount: UILabel!
    
    // MARK: Biến của button filter
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
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    
    private func handleChooseDate(date:Date,tag:Int){
        guard let viewModel = self.viewModel else {return}
        let dateString = TimeUtils.convertDateToString(from: date, format: .dd_mm_yyyy)
        var report = viewModel.vatReport.value
     
        if tag == -2{
            if TimeUtils.isDateValid(fromDateStr: dateString,toDateStr: report.toDate){
                self.reportFilter.setFromDateTitle(dateString)
                report.fromDate = dateString
                report.reportType = 13
                viewModel.vatReport.accept(report)
                viewModel.view?.getVATReport()
            }else{
                viewModel.view?.showWarningMessage(content: "Ngày bắt đầu không được lớn hơn ngày kết thúc")
            }
          
        }else if tag == -1{
            if TimeUtils.isDateValid(fromDateStr: report.fromDate,toDateStr: dateString){
                self.reportFilter.setToDateTitle(dateString)
                report.toDate = dateString
                report.reportType = 13
                viewModel.vatReport.accept(report)
                viewModel.view?.getVATReport()
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

            reportFilter.defaultReportType = viewModel.vatReport.value.reportType
            reportFilter.chooseReportType = { [weak self] reportType in
              var report = viewModel.vatReport.value
              
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
                  report.vatReportData = []
                  report.reportType = reportType
                  report.dateString = Constants.REPORT_TYPE_DICTIONARY[reportType] ?? ""
                  viewModel.vatReport.accept(report)
                  viewModel.view?.getVATReport()
              }
              
            }

            viewModel.vatReport.subscribe(onNext: { [self] report in
                lbl_total_amount.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: report.vat_amount)
                if report.vatReportData.count > 0{
                    setupLineChart(dataChart: report.vatReportData,reportType: report.reportType)
                }
                root_view_empty_data.isHidden = report.vatReportData.count > 0 ? true : false
            }).disposed(by: disposeBag)

        }
    }
   
    @IBAction func actionDetail(_ sender: Any) {
        guard let viewModel = self.viewModel else {return}
        viewModel.makeToDetailReportVATViewController()
    }
    
    
}

extension ReportVATTableViewCell {
    func setupLineChart(dataChart:[VATReportData],reportType:Int) {

        lineChartItems.removeAll()
                
        lineChartItems = dataChart.enumerated().map{(i,value) in ChartDataEntry(x: Double(i), y: Double(value.vat_amount))}

    
        ChartUtils.customLineChart(
            chartView: line_chart_view,
            entries: lineChartItems,
            x_label: dataChart.enumerated().map{(i,value) in ChartUtils.getXLabel(dateTime: value.report_time, reportType: reportType, dataPointnth:i)},
            labelCount: ChartUtils.setLabelCountForChart(reportType: reportType, totalDataPoint: dataChart.count),
            horizontalScroll: reportType == REPORT_TYPE_OPTION_DAY ? true : false
        )
        
        // MARK: Handle click show tooltip
        // Set the extraTopOffset property to add padding
        line_chart_view.extraTopOffset = 30.0 // Adjust the value as per your requirement
    }
}
