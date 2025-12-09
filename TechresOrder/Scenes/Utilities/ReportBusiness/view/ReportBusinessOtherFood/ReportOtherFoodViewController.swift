//
//  ReportOtherFoodViewController.swift
//  Techres-Seemt
//
//  Created by Nguyen Thanh Vinh on 09/05/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import Charts
import RxRelay
import ObjectMapper
class ReportOtherFoodViewController: BaseViewController {

    
    @IBOutlet weak var bar_chart: BarChartView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var root_view_empty_data: UIView!
    
    @IBOutlet weak var lbl_total_amout: UILabel!

    @IBOutlet weak var lbl_title_report: UILabel!

    
    // MARK: Biến của button filter
    @IBOutlet weak var reportFilter: ReportFilter!
    var datePicker: DatePickerUtils = DatePickerUtils()
    var viewModel: ReportBusinessViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCellAndBindTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getReportFoodOther()
    }


}
 
//MARK: REGISTER CELL TABLE VIEW
extension ReportOtherFoodViewController {
    func registerCellAndBindTableView(){
        registerCell()
        bindTableView()
    }
    
    private func registerCell() {
        let foodItemReportOtherFoodTableViewCell = UINib(nibName: "FoodItemReportOtherFoodTableViewCell", bundle: .main)
        tableView.register(foodItemReportOtherFoodTableViewCell, forCellReuseIdentifier: "FoodItemReportOtherFoodTableViewCell")

        self.tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        tableView.rx.setDelegate(self).disposed(by: rxbag)
    }
    
    private func handleChooseDate(date:Date,tag:Int){
        guard let viewModel = self.viewModel else {return}
        
        
        let dateString = TimeUtils.convertDateToString(from: date, format: .dd_mm_yyyy)
        
        var report = viewModel.otherFoodReport.value
     
        if tag == -2{
            
            if TimeUtils.isDateValid(fromDateStr: dateString,toDateStr: report.toDate){
                self.reportFilter.setFromDateTitle(dateString)
                report.fromDate = dateString
                report.reportType = 13
                viewModel.otherFoodReport.accept(report)
                self.getReportFoodOther()
            }else{
                viewModel.view?.showWarningMessage(content: "Ngày bắt đầu không được lớn hơn ngày kết thúc")
            }
          
        }else if tag == -1{
            
            if TimeUtils.isDateValid(fromDateStr: report.fromDate,toDateStr: dateString){
                self.reportFilter.setToDateTitle(dateString)
                report.toDate = dateString
                report.reportType = 13
                viewModel.otherFoodReport.accept(report)
                self.getReportFoodOther()
                
            }else{
                viewModel.view?.showWarningMessage(content: "Ngày bắt đầu không được lớn hơn ngày kết thúc")
            }
        }
        
    }

    
    private func bindTableView() {
        guard let viewModel = self.viewModel else {return}
        
        
        datePicker.chooseDate = { [weak self] (date,tag) in
            
            self?.handleChooseDate(date: date, tag: tag)
            
        }
        
        reportFilter.defaultReportType = viewModel.otherFoodReport.value.reportType
        
        reportFilter.chooseReportType = { [weak self] reportType in
           var report = viewModel.otherFoodReport.value
           
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
               viewModel.otherFoodReport.accept(report)
               self?.getReportFoodOther()
               
           }
           
       }
        
        
        viewModel.otherFoodReport.map{$0.foods}.bind(to: tableView.rx.items(cellIdentifier: "FoodItemReportOtherFoodTableViewCell", cellType: FoodItemReportOtherFoodTableViewCell.self))
           {  (row, data, cell) in
               cell.index = row + 1
               cell.data = data
           }.disposed(by: rxbag)
    }
}

extension ReportOtherFoodViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}


extension ReportOtherFoodViewController {
    func getReportFoodOther(){
        guard let viewModel = self.viewModel else {return}
        
        viewModel.getReportFoodOther().subscribe(onNext: { [self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if var report = Mapper<FoodReportData>().map(JSONObject: response.data) {
                    
                    report.reportType = viewModel.otherFoodReport.value.reportType
                    report.dateString = viewModel.otherFoodReport.value.dateString
                    report.fromDate = viewModel.otherFoodReport.value.fromDate
                    report.toDate = viewModel.otherFoodReport.value.toDate
                    setupBarChart(data: report.foods, barChart: bar_chart)
                    viewModel.otherFoodReport.accept(report)
                    
                    lbl_total_amout.text = report.total_amount.toString
                    root_view_empty_data.isHidden = report.total_amount > 0 ? true : false
                }
            }else{
                dLog(response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.")
            }
        }).disposed(by: rxbag)
    }
}

//MARK: CHART HANDLER....
extension ReportOtherFoodViewController {
    func setupBarChart(data:[FoodReport],barChart:BarChartView){
        ChartUtils.customBarChart(
            chartView: barChart,
            barChartItems: data.enumerated().map{(i,value) in BarChartDataEntry(x: Double(i), y: Double(value.total_amount))},
            xLabel: data.enumerated().map{(i,value) in String(i + 1)}
        )

        barChart.isUserInteractionEnabled = true
        // calculate the required height for the chart based on the number of labels and their rotated height
        let labelHeight = barChart.xAxis.labelRotatedHeight // use the rotated label height
        let labelRotationAngle = CGFloat(barChart.xAxis.labelRotationAngle) * .pi / 180 // convert the rotation angle to radians
        let chartHeight = barChart.frame.origin.y + (CGFloat(barChart.xAxis.labelCount) * labelHeight * abs(cos(labelRotationAngle))) // use the rotated height and the cosine of the rotation angle
        // resize the height of the chart view
        barChart.frame.size.height = chartHeight
    }
}
