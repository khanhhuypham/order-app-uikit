//
//  ReportCancelFoodTableViewCell.swift
//  Techres-Seemt
//
//  Created by Huynh Quang Huy on 15/05/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import Charts
import RxSwift
import ObjectMapper
class ReportCancelFoodTableViewCell: UITableViewCell {
    

    @IBOutlet weak var bar_chart: BarChartView!
    @IBOutlet weak var root_view_empty_data: UIView!
    
    // MARK: Biến của button filter
    // MARK: Biến của button filter
    @IBOutlet weak var reportFilter: ReportFilter!
    var datePicker: DatePickerUtils = DatePickerUtils()

    @IBOutlet weak var lbl_total_amount: UILabel!
    
    var btnArray:[UIButton] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)

    }
    
    private(set) var disposeBag = DisposeBag()
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    

    
//    @IBAction func actionChooseReportType(_ sender: UIButton) {
//        guard let viewModel = self.viewModel else {return}
//        var cancelFoodReport = viewModel.cancelFoodReport.value
//        cancelFoodReport.foods = []
//        cancelFoodReport.reportType = sender.tag
//        cancelFoodReport.dateString = Constants.REPORT_TYPE_DICTIONARY[sender.tag] ?? ""
//        viewModel.cancelFoodReport.accept(cancelFoodReport)
//        viewModel.view?.getReportFoodCancel()
//    }
    
    private func handleChooseDate(date:Date,tag:Int){
        guard let viewModel = self.viewModel else {return}
        let dateString = TimeUtils.convertDateToString(from: date, format: .dd_mm_yyyy)
        var report = viewModel.cancelFoodReport.value
     
        if tag == -2{
            if TimeUtils.isDateValid(fromDateStr: dateString,toDateStr: report.toDate){
                self.reportFilter.setFromDateTitle(dateString)
                report.fromDate = dateString
                report.reportType = 13
                viewModel.cancelFoodReport.accept(report)
                viewModel.view?.getReportFoodCancel()
            }else{
                viewModel.view?.showWarningMessage(content: "Ngày bắt đầu không được lớn hơn ngày kết thúc")
            }
          
        }else if tag == -1{
            if TimeUtils.isDateValid(fromDateStr: report.fromDate,toDateStr: dateString){
                self.reportFilter.setToDateTitle(dateString)
                report.toDate = dateString
                report.reportType = 13
                viewModel.cancelFoodReport.accept(report)
                viewModel.view?.getReportFoodCancel()
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
               
               reportFilter.defaultReportType = viewModel.cancelFoodReport.value.reportType

               reportFilter.chooseReportType = { [weak self] reportType in
                   var report = viewModel.giftedFoodReport.value
                   
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
                   
                       report.reportType = reportType
                       report.dateString = Constants.REPORT_TYPE_DICTIONARY[reportType] ?? ""
                       viewModel.cancelFoodReport.accept(report)
                       viewModel.view?.getReportFoodCancel()
                   }
                   
               }
               
                viewModel.cancelFoodReport.subscribe(onNext: { [self] report in
                    lbl_total_amount.text = report.total_amount.toString
                    root_view_empty_data.isHidden = report.foods.count != 0 ? true : false
                    setupBarChart(data: report.foods, barChart: bar_chart)
                }).disposed(by: disposeBag)
           }
        
        
    }
    
    @IBAction func actionDetail(_ sender: Any) {
        guard let viewModel = self.viewModel else {return}
        viewModel.makeToDetailReportCancelFoodViewController()
    }
    
}




extension ReportCancelFoodTableViewCell {
    func setupBarChart(data:[FoodReport],barChart:BarChartView){
        
        ChartUtils.customBarChart(
            chartView: bar_chart,
            barChartItems: data.enumerated().map{(i,value) in BarChartDataEntry(x: Double(i), y: Double(value.total_amount))},
            xLabel: data.map{String($0.food_name.count <= 15 ? $0.food_name : $0.food_name.prefix(15) + "...")}
        )
        
        bar_chart.isUserInteractionEnabled = true
        // calculate the required height for the chart based on the number of labels and their rotated height
        let labelHeight = barChart.xAxis.labelRotatedHeight // use the rotated label height
        let labelRotationAngle = CGFloat(barChart.xAxis.labelRotationAngle) * .pi / 180 // convert the rotation angle to radians
        let chartHeight = barChart.frame.origin.y + (CGFloat(barChart.xAxis.labelCount) * labelHeight * abs(cos(labelRotationAngle))) // use the rotated height and the cosine of the rotation angle
        // resize the height of the chart view
        barChart.frame.size.height = chartHeight
    }
 
}
