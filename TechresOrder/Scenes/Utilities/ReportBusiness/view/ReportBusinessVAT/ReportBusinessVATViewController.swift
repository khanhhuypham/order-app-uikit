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
class ReportBusinessVATViewController: BaseViewController {

    @IBOutlet weak var view_no_data: UIView!
    @IBOutlet weak var tableView: UITableView!
    var lineChartItems = [ChartDataEntry]()
    @IBOutlet weak var line_chart_view: LineChartView!
    @IBOutlet weak var total_amount: UILabel!

    @IBOutlet weak var reportFilter: ReportFilter!
    var datePicker: DatePickerUtils = DatePickerUtils()
    override func viewDidLoad() {
        super.viewDidLoad()
        view_no_data.isHidden = true // Thêm view no data trong viewDidload()

        registerCell()
        bindTableViewData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getReportVAT()
    }
    

 

    var viewModel: ReportBusinessViewModel?
 
}

//MARK: -- CALL API
extension ReportBusinessVATViewController{
  
    
    private func getReportVAT(){
        guard let viewModel = self.viewModel else {return}
        viewModel.getReportVAT().subscribe(onNext: {[self] (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if var report = Mapper<VATReport>().map(JSONObject: response.data) {
                    //lưu lại reportType và dateString
                    report.reportType = viewModel.vatReport.value.reportType
                    report.dateString = viewModel.vatReport.value.dateString
                    report.fromDate = viewModel.vatReport.value.fromDate
                    report.toDate = viewModel.vatReport.value.toDate
                    viewModel.vatReport.accept(report)
                }
            }else{
                dLog(response.message ?? "")
            }
        }).disposed(by: rxbag)
    }
}

extension ReportBusinessVATViewController:UITableViewDelegate{
   
    private func registerCell(){
        let reportBusinessVATTableViewCell = UINib(nibName: "ReportBusinessVATTableViewCell", bundle: .main)
        tableView.register(reportBusinessVATTableViewCell, forCellReuseIdentifier: "ReportBusinessVATTableViewCell")
        tableView.rx.setDelegate(self).disposed(by: rxbag)
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
                self.getReportVAT()
            }else{
                viewModel.view?.showWarningMessage(content: "Ngày bắt đầu không được lớn hơn ngày kết thúc")
            }
          
        }else if tag == -1{
            
            if TimeUtils.isDateValid(fromDateStr: report.fromDate,toDateStr: dateString){
                self.reportFilter.setToDateTitle(dateString)
                report.toDate = dateString
                report.reportType = 13
                viewModel.vatReport.accept(report)
                self.getReportVAT()
                
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
               self?.getReportVAT()
               
           }
           
       }
        

        viewModel.vatReport.subscribe(onNext: { [self] report in
            total_amount.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: report.vat_amount)
            if report.vatReportData.count > 0{setupLineChart(data: report.vatReportData,reportType: report.reportType)}
            view_no_data.isHidden = report.vatReportData.count > 0 ? true : false
        }).disposed(by: rxbag)
        
        
        viewModel.vatReport.map{$0.vatReportData}.bind(to: tableView.rx.items(cellIdentifier: "ReportBusinessVATTableViewCell", cellType: ReportBusinessVATTableViewCell.self))
        { [self](row, vat, cell) in
            cell.lbl_name.text = ChartUtils.getXLabel(dateTime: vat.report_time, reportType: viewModel.vatReport.value.reportType, dataPointnth: row)
            cell.data = vat
        }.disposed(by: rxbag)
        

    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    

    func setupLineChart(data:[VATReportData],reportType:Int) {

        lineChartItems.removeAll()
        lineChartItems = data.enumerated().map{(i,value) in ChartDataEntry(x: Double(i), y: Double(value.vat_amount))}

        var x_label:[String] = data.enumerated().map{(i,value) in ChartUtils.getXLabel(dateTime: value.report_time, reportType: reportType, dataPointnth:i)}
        
        ChartUtils.customLineChart(
            chartView: line_chart_view,
            entries: lineChartItems,
            x_label: x_label,
            labelCount: ChartUtils.setLabelCountForChart(reportType: reportType, totalDataPoint: data.count),
            horizontalScroll: reportType == REPORT_TYPE_OPTION_DAY ? true : false
        )

        // MARK: Handle click show tooltip
        // Set the extraTopOffset property to add padding
        line_chart_view.extraTopOffset = 30.0 // Adjust the value as per your requirement

    }
    

}


