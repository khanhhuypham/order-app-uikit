//
//  ReportBusinessAreaRevenueViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 28/08/2023.
//

import UIKit
import Charts
import ObjectMapper
import RxSwift
class ReportBusinessAreaRevenueViewController: BaseViewController {

    
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var barChart: BarChartView!
    @IBOutlet weak var view_no_data: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var total_amount: UILabel!
    
    @IBOutlet weak var height_of_table: NSLayoutConstraint!
    
    @IBOutlet weak var height_of_pie_chart: NSLayoutConstraint!
    var colors = [UIColor]()
    
    
    
    @IBOutlet weak var reportFilter: ReportFilter!
    var datePicker: DatePickerUtils = DatePickerUtils()

    override func viewDidLoad() {
        super.viewDidLoad()
        view_no_data.isHidden = true // Thêm view no data trong
     
        registerCell()
        bindTableViewData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getReportAreaRevenue()
    }
    
    
//    @IBAction func actionChooseReportType(_ sender: UIButton) {
//        guard let viewModel = self.viewModel else {return}
//        var report = viewModel.areaRevenueReport.value
//        report.reportType = sender.tag
//        report.dateString = Constants.REPORT_TYPE_DICTIONARY[sender.tag] ?? ""
//        report.areaRevenueReportData = []
//        viewModel.areaRevenueReport.accept(report)
//        getReportAreaRevenue()
//    }
    
  
    var viewModel: ReportBusinessViewModel?
}


//MARK: -- CALL API
extension ReportBusinessAreaRevenueViewController{
  
    private func getReportAreaRevenue(){
        guard let viewModel = viewModel else {return}
        
        viewModel.getReportAreaRevenue().subscribe(onNext: {[self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if var report = Mapper<AreaRevenueReport>().map(JSONObject: response.data) {
                    report.reportType = viewModel.areaRevenueReport.value.reportType
                    report.dateString = viewModel.areaRevenueReport.value.dateString
                    report.fromDate = viewModel.areaRevenueReport.value.fromDate
                    report.toDate = viewModel.areaRevenueReport.value.toDate
                    viewModel.areaRevenueReport.accept(report)
                }
            }else{
                dLog(response.message ?? "")
            }
        }).disposed(by: rxbag)
    }
    
}


extension ReportBusinessAreaRevenueViewController{
   
    private func registerCell(){
        let reportBusinessAreaRevenueTableViewCell = UINib(nibName: "ReportBusinessAreaRevenueTableViewCell", bundle: .main)
        tableView.register(reportBusinessAreaRevenueTableViewCell, forCellReuseIdentifier: "ReportBusinessAreaRevenueTableViewCell")
        tableView.rowHeight = 50
        tableView.isScrollEnabled = false
        
    }
    
    private func handleChooseDate(date:Date,tag:Int){
        guard let viewModel = self.viewModel else {return}
        
        
        let dateString = TimeUtils.convertDateToString(from: date, format: .dd_mm_yyyy)
        var report = viewModel.areaRevenueReport.value
     
        if tag == -2{
            
            if TimeUtils.isDateValid(fromDateStr: dateString,toDateStr: report.toDate){
                self.reportFilter.setFromDateTitle(dateString)
                report.fromDate = dateString
                report.reportType = 13
                viewModel.areaRevenueReport.accept(report)
                self.getReportAreaRevenue()
            }else{
                viewModel.view?.showWarningMessage(content: "Ngày bắt đầu không được lớn hơn ngày kết thúc")
            }
          
        }else if tag == -1{
            
            if TimeUtils.isDateValid(fromDateStr: report.fromDate,toDateStr: dateString){
                self.reportFilter.setToDateTitle(dateString)
                report.toDate = dateString
                report.reportType = 13
                viewModel.areaRevenueReport.accept(report)
                self.getReportAreaRevenue()
                
            }else{
                viewModel.view?.showWarningMessage(content: "Ngày bắt đầu không được lớn hơn ngày kết thúc")
            }
        }
        
    }

    private func bindTableViewData() {
        
        guard let viewModel = viewModel else {return}
        
        datePicker.chooseDate = { [weak self] (date,tag) in
            
            self?.handleChooseDate(date: date, tag: tag)
            
        }
        
        reportFilter.defaultReportType = viewModel.areaRevenueReport.value.reportType
        
        reportFilter.chooseReportType = { [weak self] reportType in
           var report = viewModel.areaRevenueReport.value
           
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
               viewModel.areaRevenueReport.accept(report)
               self?.getReportAreaRevenue()
               
           }
           
       }
        
        

        viewModel.areaRevenueReport.subscribe(onNext: { [self] report in
            
            colors = report.areaRevenueReportData.enumerated().map{_ in ColorUtils.random()}
            
                total_amount.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: report.total_revenue)
                
            
                view_no_data.isHidden = report.areaRevenueReportData.count > 0 ? true : false
            
            
                setupBarChart(data: report.areaRevenueReportData, barChart: barChart)
                setPieChart(piechart:pieChart,report: report)
                height_of_table.constant = CGFloat(report.areaRevenueReportData.count*50)

          }).disposed(by: rxbag)
        
        
        viewModel.areaRevenueReport.map{$0.areaRevenueReportData}.bind(to: tableView.rx.items(cellIdentifier: "ReportBusinessAreaRevenueTableViewCell", cellType: ReportBusinessAreaRevenueTableViewCell.self))
        { [self](row, data, cell) in
            cell.data = data
            cell.lbl_percent.textColor = self.colors[row]
       
            if self.viewModel?.areaRevenueReport.value.total_revenue != 0  && data.revenue != 0 {
                cell.lbl_percent.text = String(format: "%.2f%%", Double(data.revenue)/Double(self.viewModel?.areaRevenueReport.value.total_revenue ?? 1)*100)
            }else {
                cell.lbl_percent.text = String(format: "%.2f%%", 0.0)
            }
            cell.lbl_area_number.backgroundColor = self.colors[row]
            cell.lbl_area_number.text = String(row + 1)
            dLog(self.tableView.contentSize.height)
        }.disposed(by: rxbag)
        
    }
    
    
    private func setupBarChart(data:[AreaRevenueReportData],barChart:BarChartView){
        
        ChartUtils.customBarChart(
            chartView: barChart,
            barChartItems: data.enumerated().map{(i,value) in BarChartDataEntry(x: Double(i), y: Double(value.revenue))},
            xLabel: data.map{$0.area_name},
            color: colors
        )
    }
    


    private func setPieChart(piechart:PieChartView,report: AreaRevenueReport) {
        
        ChartUtils.customPieChart(
            pieChart: pieChart,
            dataEntries: report.areaRevenueReportData.enumerated().map{(i,value) in PieChartDataEntry(value: Double(value.revenue),label: value.area_name)},
            colors: colors,
            holeEnable: true
        )
    }
    

    
}




