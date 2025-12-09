//
//  ReportBusinessTableRevenueViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 28/08/2023.
//

import UIKit
import Charts
import ObjectMapper
import RxSwift
import RxRelay
class ReportBusinessTableRevenueViewController: BaseViewController {
    
    
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var barChart: BarChartView!
    @IBOutlet weak var view_no_data: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var total_amount: UILabel!
    
    @IBOutlet weak var height_of_pie_chart: NSLayoutConstraint!
    @IBOutlet weak var height_of_table: NSLayoutConstraint!
    var colors = [UIColor]()
    
    @IBOutlet weak var reportFilter: ReportFilter!
    var datePicker: DatePickerUtils = DatePickerUtils()

    override func viewDidLoad() {
        super.viewDidLoad()

        registerCell()
        bindTableViewData()

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getReportTableRevenue()
    }
    
//   
    
    var viewModel: ReportBusinessViewModel?
}


//MARK: -- CALL API
extension ReportBusinessTableRevenueViewController{
  
    private func getReportTableRevenue(){
        guard let viewModel = self.viewModel else {return}
        viewModel.getReportTableRevenue().subscribe(onNext: {[self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if var report = Mapper<TableRevenueReport>().map(JSONObject: response.data) {
                    report.reportType = viewModel.tableRevenueReport.value.reportType
                    report.dateString = viewModel.tableRevenueReport.value.dateString
                    report.fromDate = viewModel.tableRevenueReport.value.fromDate
                    report.toDate = viewModel.tableRevenueReport.value.toDate
                    viewModel.tableRevenueReport.accept(report)
                }
            }else{
                dLog(response.message ?? "")
            }
        }).disposed(by: rxbag)
    }
    
}


extension ReportBusinessTableRevenueViewController{
   
    private func registerCell(){
        let reportBusinessTableRevenueTableViewCell = UINib(nibName: "ReportBusinessTableRevenueTableViewCell", bundle: .main)
        tableView.register(reportBusinessTableRevenueTableViewCell, forCellReuseIdentifier: "ReportBusinessTableRevenueTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isScrollEnabled = false
        
    }
    
    private func handleChooseDate(date:Date,tag:Int){
        guard let viewModel = self.viewModel else {return}
        
        
        let dateString = TimeUtils.convertDateToString(from: date, format: .dd_mm_yyyy)
        var report = viewModel.tableRevenueReport.value
     
        if tag == -2{
            
            if TimeUtils.isDateValid(fromDateStr: dateString,toDateStr: report.toDate){
                self.reportFilter.setFromDateTitle(dateString)
                report.fromDate = dateString
                report.reportType = 13
                viewModel.tableRevenueReport.accept(report)
                self.getReportTableRevenue()
            }else{
                viewModel.view?.showWarningMessage(content: "Ngày bắt đầu không được lớn hơn ngày kết thúc")
            }
          
        }else if tag == -1{
            
            if TimeUtils.isDateValid(fromDateStr: report.fromDate,toDateStr: dateString){
                self.reportFilter.setToDateTitle(dateString)
                report.toDate = dateString
                report.reportType = 13
                viewModel.tableRevenueReport.accept(report)
                self.getReportTableRevenue()
                
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
        
        reportFilter.defaultReportType = viewModel.tableRevenueReport.value.reportType
        reportFilter.chooseReportType = { [weak self] reportType in
           var report = viewModel.tableRevenueReport.value
           
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
               viewModel.tableRevenueReport.accept(report)
               self?.getReportTableRevenue()
               
           }
           
       }
        
        

        viewModel.tableRevenueReport.subscribe(onNext: { [self] report in
            
            colors = report.tableRevenueReportData.enumerated().map{_ in ColorUtils.random()}
            
            setPieChart(piechart:pieChart,report: report)
            setupBarChart(barChart:barChart,data: report.tableRevenueReportData)

            total_amount.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: report.total_revenue)
            view_no_data.isHidden = report.tableRevenueReportData.count > 0 ? true : false


          }).disposed(by: rxbag)
        
        
        viewModel.tableRevenueReport.map{$0.tableRevenueReportData}.bind(to: tableView.rx.items(cellIdentifier: "ReportBusinessTableRevenueTableViewCell", cellType: ReportBusinessTableRevenueTableViewCell.self))
        {(row, data, cell) in
            cell.data = data
            cell.lbl_percent.textColor = self.colors[row]
            if self.viewModel?.tableRevenueReport.value.total_revenue != 0 && data.revenue != 0 {
                cell.lbl_percent.text = String(format: "%.2f%%", Double(data.revenue)/Double(self.viewModel?.tableRevenueReport.value.total_revenue ?? 1)*100)
            }else {
                cell.lbl_percent.text = String(format: "%.2f", 0.0)
            }
            cell.lbl_number.backgroundColor = self.colors[row]
            cell.lbl_number.text = String(row + 1)
            self.height_of_table.constant = self.tableView.contentSize.height
        }.disposed(by: rxbag)
        
    }
    

    private func setupBarChart(barChart:BarChartView,data:[TableRevenueReportData]){
        
        ChartUtils.customBarChart(
            chartView: barChart,
            barChartItems: data.enumerated().map{(i,value) in BarChartDataEntry(x: Double(i), y: Double(value.revenue))},
            xLabel: data.enumerated().map{(i,_) in String(i+1)},
            color: colors
        )
 

    }
    
    
    
    private func setPieChart(piechart:PieChartView,report: TableRevenueReport) {

        ChartUtils.customPieChart(
            pieChart: pieChart,
            dataEntries: report.tableRevenueReportData.enumerated().map{(i,value) in PieChartDataEntry(value: Double(value.revenue),label: String(i+1))},
            colors: colors,
            holeEnable: true
        )
        

    }
    

    
}


