//
//  ReportBusinessCancelFoodViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 23/09/2023.
//

import UIKit
import Charts
import ObjectMapper
class ReportBusinessCancelFoodViewController: BaseViewController {

    
    // MARK: Biến của button filter
    @IBOutlet weak var reportFilter: ReportFilter!
    var datePicker: DatePickerUtils = DatePickerUtils()
    
    
    @IBOutlet weak var barChart: BarChartView!

    @IBOutlet weak var view_no_data: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var total_amount: UILabel!
    var btnArray:[UIButton] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        bindTableViewData()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getReportCancelFood()
    }

    var viewModel: ReportBusinessViewModel?
    

    private func getReportCancelFood(){
        guard let viewModel = self.viewModel else {return}
        viewModel.getReportCancelFood().subscribe(onNext: {[self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if var report = Mapper<FoodReportData>().map(JSONObject: response.data) {
                    //lưu lại reportType và dateString
                    report.reportType = viewModel.cancelFoodReport.value.reportType
                    report.dateString = viewModel.cancelFoodReport.value.dateString
                    report.fromDate = viewModel.cancelFoodReport.value.fromDate
                    report.toDate = viewModel.cancelFoodReport.value.toDate
                    report.foods.sort{$0.total_amount > $1.total_amount}
                    viewModel.cancelFoodReport.accept(report)
                }
            }else{
                dLog(response.message ?? "")
            }
        }).disposed(by: rxbag)
    }
    
    private func registerCell(){
        let tableViewCell = UINib(nibName: "ReportBusinessCancelFoodTableViewCell", bundle: .main)
        tableView.register(tableViewCell, forCellReuseIdentifier: "ReportBusinessCancelFoodTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
    }
    
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
                self.getReportCancelFood()
            }else{
                viewModel.view?.showWarningMessage(content: "Ngày bắt đầu không được lớn hơn ngày kết thúc")
            }
          
        }else if tag == -1{
            
            if TimeUtils.isDateValid(fromDateStr: report.fromDate,toDateStr: dateString){
                self.reportFilter.setToDateTitle(dateString)
                report.toDate = dateString
                report.reportType = 13
                viewModel.cancelFoodReport.accept(report)
                self.getReportCancelFood()
                
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
               self?.getReportCancelFood()
               
           }
           
       }
    
         viewModel.cancelFoodReport.subscribe(onNext: { [self] report in
             view_no_data.isHidden = report.foods.count > 0 ? true : false
             setupBarChart(data: report.foods, barChart: barChart)
             total_amount.text = report.total_amount.toString
         }).disposed(by: rxbag)

        viewModel.cancelFoodReport.map{$0.foods}.bind(to: tableView.rx.items(cellIdentifier: "ReportBusinessCancelFoodTableViewCell", cellType: ReportBusinessCancelFoodTableViewCell.self))
        {(row, food, cell) in
            cell.data = food
            cell.lbl_number.text = String(row + 1)
        }.disposed(by: rxbag)
        
    }
    private func setupBarChart(data:[FoodReport],barChart:BarChartView){
        ChartUtils.customBarChart(
            chartView: barChart,
            barChartItems: data.enumerated().map{(i,value) in BarChartDataEntry(x: Double(i), y: Double(value.total_amount))},
            xLabel: data.map{$0.food_name}
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







