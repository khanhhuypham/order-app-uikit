//
//  ReportBusinessCategoryViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 07/03/2023.
//

import UIKit
import ObjectMapper
import Charts
import RxSwift
import RxRelay
import RxCocoa
class ReportBusinessCategoryViewController: BaseViewController {
    
    
    @IBOutlet weak var pieChartCategory: PieChartView!
    @IBOutlet weak var barChartCategory: BarChartView!

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lbl_branch_name: UILabel!
    
    @IBOutlet weak var lbl_total_revenue: UILabel!
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var No_data_view: UIView!
    
    
    var colors = [UIColor]()
    
    @IBOutlet weak var reportFilter: ReportFilter!
    var datePicker: DatePickerUtils = DatePickerUtils()
    
    
    var totalAmount = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        No_data_view.isHidden = true
        // Do any additional setup after loading the view.

        registerCell()
        bindTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reportRevenueByCategory()
    }
    
    
        
    var viewModel: ReportBusinessViewModel?

    //MARK: Register Cells as you want
    private func registerCell(){
        let itemCategoryTableViewCell = UINib(nibName: "ItemCategoryTableViewCell", bundle: .main)
        tableView.register(itemCategoryTableViewCell, forCellReuseIdentifier: "ItemCategoryTableViewCell")
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isScrollEnabled = false
    }
    
    
    private func handleChooseDate(date:Date,tag:Int){
        guard let viewModel = self.viewModel else {return}
        
        
        let dateString = TimeUtils.convertDateToString(from: date, format: .dd_mm_yyyy)
        var report = viewModel.categoryReport.value
     
        if tag == -2{
            
            if TimeUtils.isDateValid(fromDateStr: dateString,toDateStr: report.toDate){
                self.reportFilter.setFromDateTitle(dateString)
                report.fromDate = dateString
                report.reportType = 13
                viewModel.categoryReport.accept(report)
                self.reportRevenueByCategory()
            }else{
                viewModel.view?.showWarningMessage(content: "Ngày bắt đầu không được lớn hơn ngày kết thúc")
            }
          
        }else if tag == -1{
            
            if TimeUtils.isDateValid(fromDateStr: report.fromDate,toDateStr: dateString){
                self.reportFilter.setToDateTitle(dateString)
                report.toDate = dateString
                report.reportType = 13
                viewModel.categoryReport.accept(report)
                self.reportRevenueByCategory()
                
            }else{
                viewModel.view?.showWarningMessage(content: "Ngày bắt đầu không được lớn hơn ngày kết thúc")
            }
        }
        
    }
    
    
    func bindTableView(){
        
        
        if let viewModel = viewModel{
            
            datePicker.chooseDate = { [weak self] (date,tag) in
                self?.handleChooseDate(date: date, tag: tag)
            }
            
            reportFilter.defaultReportType = viewModel.categoryReport.value.reportType
            
            reportFilter.chooseReportType = { [weak self] reportType in
               var report = viewModel.categoryReport.value
               
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
                   viewModel.categoryReport.accept(report)
                   self?.reportRevenueByCategory()
                   
               }
               
           }
            
            
            
            
            viewModel.categoryReport.subscribe(onNext: { [self] report in
                lbl_total_revenue.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: report.total_amount)
    
                totalAmount = Double(report.total_amount)
                colors = report.revenuesData.enumerated().map{_ in ColorUtils.random()}
                
                setupPieChart(data: report.revenuesData,pieChart: pieChartCategory)
                setupBarChart(data: report.revenuesData,barChart: barChartCategory)
                
 
            }).disposed(by: rxbag)
  
            
            viewModel.categoryReport.map{$0.revenuesData}.bind(to: tableView.rx.items(cellIdentifier: "ItemCategoryTableViewCell", cellType: ItemCategoryTableViewCell.self))
            {(row, category, cell) in
                
                cell.total_revenue = self.totalAmount
                cell.lbl_number.backgroundColor = self.colors[row]
                cell.lbl_number.text = String(format: "%d", row+1)
                cell.lbl_percent.textColor = self.colors[row]
                cell.data = category
                
                dLog(category.category_name)
            }.disposed(by: rxbag)
        }
    }
    
    
    //MARK: Revenue By Category
   private func reportRevenueByCategory(){
        guard let viewModel = self.viewModel else {return}
        viewModel.reportRevenueByCategory().subscribe(onNext: { (response) in
            
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if var report = Mapper<RevenueCategoryReport>().map(JSONObject: response.data) {
                    report.dateString = viewModel.categoryReport.value.dateString
                    report.reportType = viewModel.categoryReport.value.reportType
                    report.fromDate = viewModel.categoryReport.value.fromDate
                    report.toDate = viewModel.categoryReport.value.toDate
                    viewModel.categoryReport.accept(report)
                }
            }else{
                dLog(response.message ?? "")
            }


        }).disposed(by: rxbag)
    }
    
    
}


extension ReportBusinessCategoryViewController{

    func setupPieChart(data:[RevenueCategory],pieChart:PieChartView){
        ChartUtils.customPieChart(
            pieChart: pieChart,
            dataEntries: data.enumerated().map{(i,value) in PieChartDataEntry(value: Double(value.total_amount),label: Utils.doubleToPrecent(value: Double(value.total_amount)/Double(self.totalAmount)))},
            colors: colors,
            holeEnable: true
        )
  
    }
    
    func setupBarChart(data:[RevenueCategory],barChart:BarChartView){
      
        ChartUtils.customBarChart(
            chartView: barChart,
            barChartItems: data.enumerated().map{(i,value) in BarChartDataEntry(x: Double(i), y: Double(value.total_amount))},
            xLabel: data.map{$0.category_name.count <= 15 ? $0.category_name : $0.category_name.prefix(15) + "..."},
            color: colors
        )
        
        
    
        // calculate the required height for the chart based on the number of labels and their rotated height
        let labelHeight = barChart.xAxis.labelRotatedHeight // use the rotated label height
        let labelRotationAngle = CGFloat(barChart.xAxis.labelRotationAngle) * .pi / 180 // convert the rotation angle to radians
        let chartHeight = barChart.frame.origin.y + (CGFloat(barChart.xAxis.labelCount) * labelHeight * abs(cos(labelRotationAngle))) // use the rotated height and the cosine of the rotation angle
        // resize the height of the chart view
        barChart.frame.size.height = chartHeight
   
    }
  
}







