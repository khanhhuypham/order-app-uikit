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
class ReportBusinessDiscountViewController: BaseViewController {
    
    @IBOutlet weak var reportFilter: ReportFilter!
    var datePicker: DatePickerUtils = DatePickerUtils()
    @IBOutlet weak var line_chart_view: LineChartView!
    
    @IBOutlet weak var view_no_data: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var total_amount: UILabel!
    
    var lineChartItems = [ChartDataEntry]()
    var btnArray:[UIButton] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        view_no_data.isHidden = true
        // Do any additional setup after loading the view.
        registerCell()
        bindTableViewData()
        

    
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getReportDiscountedFood()
    }
 
    var viewModel: ReportBusinessViewModel?
}

//MARK: -- CALL API
extension ReportBusinessDiscountViewController{
   
    private func getReportDiscountedFood(){
        guard let viewModel = self.viewModel else {return}
        viewModel.getReportDiscountedFood().subscribe(onNext: {[self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if var report = Mapper<DiscountReport>().map(JSONObject: response.data) {
                    report.reportType = viewModel.discountReport.value.reportType
                    report.dateString = viewModel.discountReport.value.dateString
                    report.fromDate = viewModel.discountReport.value.fromDate
                    report.toDate = viewModel.discountReport.value.toDate
                    viewModel.discountReport.accept(report)
                }
            }else{
                dLog(response.message ?? "")
            }
        }).disposed(by: rxbag)
    }
    
    
}



extension ReportBusinessDiscountViewController:UITableViewDelegate{
   
    private func registerCell(){
        let reportBusinessDiscountTableViewCell = UINib(nibName: "ReportBusinessDiscountTableViewCell", bundle: .main)
        tableView.register(reportBusinessDiscountTableViewCell, forCellReuseIdentifier: "ReportBusinessDiscountTableViewCell")
        tableView.rx.setDelegate(self).disposed(by: rxbag)
    }
    
    
    private func handleChooseDate(date:Date,tag:Int){
        guard let viewModel = self.viewModel else {return}
        
        
        let dateString = TimeUtils.convertDateToString(from: date, format: .dd_mm_yyyy)
        var report = viewModel.discountReport.value
     
        if tag == -2{
            
            if TimeUtils.isDateValid(fromDateStr: dateString,toDateStr: report.toDate){
                self.reportFilter.setFromDateTitle(dateString)
                report.fromDate = dateString
                report.reportType = 13
                viewModel.discountReport.accept(report)
                self.getReportDiscountedFood()
            }else{
                viewModel.view?.showWarningMessage(content: "Ngày bắt đầu không được lớn hơn ngày kết thúc")
            }
          
        }else if tag == -1{
            
            if TimeUtils.isDateValid(fromDateStr: report.fromDate,toDateStr: dateString){
                self.reportFilter.setToDateTitle(dateString)
                report.toDate = dateString
                report.reportType = 13
                viewModel.discountReport.accept(report)
                self.getReportDiscountedFood()
                
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
        
        reportFilter.defaultReportType = viewModel.discountReport.value.reportType
        reportFilter.chooseReportType = { [weak self] reportType in
           var report = viewModel.discountReport.value
           
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
               report.discountReportData = []
               report.reportType = reportType
               report.dateString = Constants.REPORT_TYPE_DICTIONARY[reportType] ?? ""
               viewModel.discountReport.accept(report)
               self?.getReportDiscountedFood()
               
           }
           
       }
        
        viewModel.discountReport.subscribe(onNext: { [self] report in
            total_amount.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: report.total_amount)
            if report.discountReportData.count > 0{setupLineChart(data: report.discountReportData,reportType: report.reportType)}
            view_no_data.isHidden = report.discountReportData.count > 0 ? true : false
            
        }).disposed(by: rxbag)
        
        viewModel.discountReport.map{$0.discountReportData}.bind(to: tableView.rx.items(cellIdentifier: "ReportBusinessDiscountTableViewCell", cellType: ReportBusinessDiscountTableViewCell.self))
        { [self](row, discount, cell) in
            cell.lbl_name.text = ChartUtils.getXLabel(dateTime: discount.report_time, reportType: viewModel.discountReport.value.reportType, dataPointnth: row)
            cell.data = discount
        }.disposed(by: rxbag)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    private func setupLineChart(data:[DiscountReportData],reportType:Int){
        
        lineChartItems.removeAll()
        lineChartItems = data.enumerated().map{(i,value) in ChartDataEntry(x: Double(i), y: Double(value.total_amount))}
    
        let x_label:[String] = data.enumerated().map{(i,value) in ChartUtils.getXLabel(dateTime: value.report_time, reportType: reportType, dataPointnth:i)}
        ChartUtils.customLineChart(
            chartView: line_chart_view,
            entries: lineChartItems,
            x_label: x_label,
            labelCount: ChartUtils.setLabelCountForChart(reportType: reportType, totalDataPoint: data.count),
            horizontalScroll: reportType == REPORT_TYPE_OPTION_DAY ? true : false
        )

    }
    

}

