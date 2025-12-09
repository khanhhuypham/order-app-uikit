//
//  ReportBusinessFoodViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 07/03/2023.
//

import UIKit
import ObjectMapper
import RxSwift
import Charts
import RxRelay
import RxCocoa
class ReportBusinessFoodViewController: BaseViewController {
    

    
    @IBOutlet weak var reportFilter: ReportFilter!
    var datePicker: DatePickerUtils = DatePickerUtils()
    @IBOutlet weak var barChart: BarChartView!
    @IBOutlet weak var view_no_data: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var total_amount: UILabel!
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        view_no_data.isHidden = true // Thêm view no data trong viewDidload()
        // Do any additional setup after loading the view.
        registerCell()
        bindTableViewData()
        

        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getReportFood()
    }
    
    @IBAction func actionChooseReportType(_ sender: UIButton) {
        guard let viewModel = self.viewModel else {return}
        var report = viewModel.foodReport.value
        report.reportType = sender.tag
        report.dateString = Constants.REPORT_TYPE_DICTIONARY[sender.tag] ?? ""
        viewModel.foodReport.accept(report)
        getReportFood()
    }
    
 
    var viewModel: ReportBusinessViewModel?
 
}
extension ReportBusinessFoodViewController{
    
    private func getReportFood(){
        guard let viewModel = self.viewModel else {return}
        viewModel.getReportFood().subscribe(onNext: {[self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if var report = Mapper<FoodReportData>().map(JSONObject: response.data) {
                    report.reportType = viewModel.foodReport.value.reportType
                    report.dateString = viewModel.foodReport.value.dateString
                    report.fromDate = viewModel.foodReport.value.fromDate
                    report.toDate = viewModel.foodReport.value.toDate
                    report.foods.sort{$0.total_amount > $1.total_amount}
                    viewModel.foodReport.accept(report)
                }
            }else{
                dLog(response.message ?? "Có lỗi xảy ra trong quá trình kết nối tới máy chủ.")
            }
        }).disposed(by: rxbag)
    }
    
    private func registerCell(){
        let foodReportRevenueTableViewCell = UINib(nibName: "FoodReportRevenueTableViewCell", bundle: .main)
        tableView.register(foodReportRevenueTableViewCell, forCellReuseIdentifier: "FoodReportRevenueTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    
    private func handleChooseDate(date:Date,tag:Int){
        guard let viewModel = self.viewModel else {return}
        
        
        let dateString = TimeUtils.convertDateToString(from: date, format: .dd_mm_yyyy)
        var report = viewModel.foodReport.value
     
        if tag == -2{
            
            if TimeUtils.isDateValid(fromDateStr: dateString,toDateStr: report.toDate){
                self.reportFilter.setFromDateTitle(dateString)
                report.fromDate = dateString
                report.reportType = 13
                viewModel.foodReport.accept(report)
                self.getReportFood()
            }else{
                viewModel.view?.showWarningMessage(content: "Ngày bắt đầu không được lớn hơn ngày kết thúc")
            }
          
        }else if tag == -1{
            
            if TimeUtils.isDateValid(fromDateStr: report.fromDate,toDateStr: dateString){
                self.reportFilter.setToDateTitle(dateString)
                report.toDate = dateString
                report.reportType = 13
                viewModel.foodReport.accept(report)
                self.getReportFood()
                
            }else{
                viewModel.view?.showWarningMessage(content: "Ngày bắt đầu không được lớn hơn ngày kết thúc")
            }
        }
        
    }
    
    
    private func bindTableViewData() {
        guard let viewModel = self.viewModel else {return}
        
        
        datePicker.chooseDate = { [weak self] (date,tag) in
            
            self?.handleChooseDate(date: date, tag: tag)
            
        }
        
        reportFilter.defaultReportType = viewModel.categoryReport.value.reportType
        reportFilter.chooseReportType = { [weak self] reportType in
           var report = viewModel.foodReport.value
           
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
               viewModel.foodReport.accept(report)
               self?.getReportFood()
               
           }
           
       }
        
        
        
        viewModel.foodReport.subscribe(onNext: { [self] report in
            if report.foods.count > 0{
                setupBarChart(data: report.foods, barChart: barChart)
            }
            view_no_data.isHidden = report.foods.count > 0 ? true : false
            total_amount.text = report.total_amount.toString
        }).disposed(by: rxbag)
        
        viewModel.foodReport.map{$0.foods}.bind(to: tableView.rx.items(cellIdentifier: "FoodReportRevenueTableViewCell", cellType: FoodReportRevenueTableViewCell.self))
        {(row, food, cell) in
            cell.data = food
            cell.lbl_number.text = String(row + 1)
        }.disposed(by: rxbag)
        
    }
    
    
    private func setupBarChart(data:[FoodReport],barChart:BarChartView){
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
