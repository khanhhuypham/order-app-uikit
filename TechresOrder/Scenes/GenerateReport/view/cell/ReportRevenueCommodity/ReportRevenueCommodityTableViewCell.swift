//
//  ReportRevenueCommodityTableViewCell.swift
//  Techres-Seemt
//
//  Created by Nguyen Thanh Vinh on 16/05/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import RxSwift
import Charts

class ReportRevenueCommodityTableViewCell: UITableViewCell {

    @IBOutlet weak var bar_chart: BarChartView!
    
    @IBOutlet weak var lbl_total_amount: UILabel!
    @IBOutlet weak var root_view_empty_data: UIView!
    
    // MARK: Biến của button filter

    
    var filterType:[String] = ["Giá vốn","Giá bán","Số lượng"]
    @IBOutlet weak var reportFilter: ReportFilter!
    var datePicker: DatePickerUtils = DatePickerUtils()
    
    private(set) var disposeBag = DisposeBag()
        override func prepareForReuse() {
            super.prepareForReuse()
            disposeBag = DisposeBag()
        }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)

        // Configure the view for the selected state
    }
    

    private func handleChooseDate(date:Date,tag:Int){
        guard let viewModel = self.viewModel else {return}
        let dateString = TimeUtils.convertDateToString(from: date, format: .dd_mm_yyyy)
        var report = viewModel.commodityReport.value
     
        if tag == -2{
            if TimeUtils.isDateValid(fromDateStr: dateString,toDateStr: report.toDate){
                self.reportFilter.setFromDateTitle(dateString)
                report.fromDate = dateString
                report.reportType = 13
                viewModel.commodityReport.accept(report)
                viewModel.view?.getRevenueReportCommodity()
            }else{
                viewModel.view?.showWarningMessage(content: "Ngày bắt đầu không được lớn hơn ngày kết thúc")
            }
          
        }else if tag == -1{
            if TimeUtils.isDateValid(fromDateStr: report.fromDate,toDateStr: dateString){
                self.reportFilter.setToDateTitle(dateString)
                report.toDate = dateString
                report.reportType = 13
                viewModel.commodityReport.accept(report)
                viewModel.view?.getRevenueReportCommodity()
            }else{
                viewModel.view?.showWarningMessage(content: "Ngày bắt đầu không được lớn hơn ngày kết thúc")
            }
        }
        
    }
    
    
    var viewModel: GenerateReportViewModel? {
       didSet {
           if let viewModel = viewModel {
               
               datePicker.chooseDate = { [weak self] (date,tag) in
                   self?.handleChooseDate(date: date, tag: tag)
               }
               
               reportFilter.defaultReportType = viewModel.commodityReport.value.reportType
               
               reportFilter.chooseReportType = { [weak self] reportType in
                  var report = viewModel.commodityReport.value
                  
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
                      viewModel.commodityReport.accept(report)
                      viewModel.view?.getRevenueReportCommodity()
                  }
                  
              }

               
                            
               viewModel.commodityReport.subscribe(onNext: { [self] report in
                   lbl_total_amount.text = report.total_amount.toString
                   root_view_empty_data.isHidden = report.foods.count > 0 ? true : false
                    if report.foods.count > 0{
                        setupBarChart(data: report.foods, barChart: bar_chart)
                    }
            
                }).disposed(by: disposeBag)
           }
       }
    }
    
    @IBAction func actionDetail(_ sender: Any) {
        guard let viewModel = self.viewModel else {return}
        viewModel.makeToDetailReportRevenueCommodityViewController()
    }
}


extension ReportRevenueCommodityTableViewCell {

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


