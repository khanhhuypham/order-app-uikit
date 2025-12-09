//
//  ReportRevenueAreaTableViewCell.swift
//  Techres-Seemt
//
//  Created by Nguyen Thanh Vinh on 16/05/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import RxSwift
import Charts

class ReportRevenueAreaTableViewCell: UITableViewCell {

    @IBOutlet weak var pie_chart: PieChartView!
    @IBOutlet weak var bar_chart: BarChartView!
    var pieChartItems = [PieChartDataEntry]()
        
    var colors = ColorUtils.chartColors()
    
    @IBOutlet weak var lbl_total_amount: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewArea: UITableView!
    @IBOutlet weak var root_view_empty_data: UIView!
    @IBOutlet weak var height_table_view: NSLayoutConstraint!
    @IBOutlet weak var height_of_view_wrap: NSLayoutConstraint!
    
    // MARK: Biến của button filter
    @IBOutlet weak var reportFilter: ReportFilter!
    var datePicker: DatePickerUtils = DatePickerUtils()

    private(set) var disposeBag = DisposeBag()
        override func prepareForReuse() {
            super.prepareForReuse()
            disposeBag = DisposeBag()
        }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        let areaItemRevenueTableViewCell = UINib(nibName: "AreaItemRevenueTableViewCell", bundle: .main)
        tableView.register(areaItemRevenueTableViewCell, forCellReuseIdentifier: "AreaItemRevenueTableViewCell")
        
        
        let cellReportRevenueAreaListItem = UINib(nibName: "CellReportRevenueAreaListItem", bundle: .main)
        tableViewArea.register(cellReportRevenueAreaListItem, forCellReuseIdentifier: "CellReportRevenueAreaListItem")
        tableViewArea.isScrollEnabled = false
        tableViewArea.rowHeight = UITableView.automaticDimension
        tableViewArea.separatorStyle = UITableViewCell.SeparatorStyle.none
   
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)

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
                viewModel.view?.getReportRevenueArea()
            }else{
                viewModel.view?.showWarningMessage(content: "Ngày bắt đầu không được lớn hơn ngày kết thúc")
            }
          
        }else if tag == -1{
            if TimeUtils.isDateValid(fromDateStr: report.fromDate,toDateStr: dateString){
                self.reportFilter.setToDateTitle(dateString)
                report.toDate = dateString
                report.reportType = 13
                viewModel.areaRevenueReport.accept(report)
                viewModel.view?.getReportRevenueArea()
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
                      viewModel.view?.getReportRevenueArea()
                  }
                  
              }

               
               var total_revenue_amount = 0
               viewModel.areaRevenueReport.subscribe(onNext: { [self] report in
                   lbl_total_amount.text = report.total_revenue_amount.toString
                   root_view_empty_data.isHidden = report.areaRevenueReportData.count > 0 ? true : false
                   setupBarChart(data: report.areaRevenueReportData, barChart: bar_chart)
                   setRevenueAreaPieChart(dataChart: report.areaRevenueReportData)
                   total_revenue_amount = report.total_revenue_amount
                 }).disposed(by: disposeBag)

               viewModel.areaRevenueReport.map{$0.areaRevenueReportData}.asObservable().bind(to: tableView.rx.items){ [self] (tableView, index, element) in
                   let cell = tableView.dequeueReusableCell(withIdentifier: "AreaItemRevenueTableViewCell") as! AreaItemRevenueTableViewCell
                   cell.back_ground_index.backgroundColor = self.colors[index]
                   cell.lbl_index.text = String(index + 1)
                   cell.data = element
                   return cell
               }.disposed(by: disposeBag)
               
               viewModel.areaRevenueReport.map{$0.areaRevenueReportData}.asObservable().bind(to: tableViewArea.rx.items){ [self] (tableView, index, element) in
                   let cell = tableView.dequeueReusableCell(withIdentifier: "CellReportRevenueAreaListItem") as! CellReportRevenueAreaListItem
                   cell.view_color_area.backgroundColor = self.colors[index]
                   cell.lbl_percent_area.textColor = self.colors[index]
                   cell.totalAmountRevenueArea = total_revenue_amount
                   cell.lbl_index_area.text = String(index + 1)
                   cell.data = element
                   return cell
               }.disposed(by: disposeBag)
           }    
    }
    
    @IBAction func actionDetail(_ sender: Any) {
        guard let viewModel = self.viewModel else {return}
        viewModel.makeToAreaReportViewController()
     
    }
    
}


extension ReportRevenueAreaTableViewCell {
    func setRevenueAreaPieChart(dataChart: [AreaRevenueReportData]) {
        
        ChartUtils.customPieChart(
            pieChart: pie_chart,
            dataEntries: dataChart.enumerated().map{(i,value) in PieChartDataEntry(value: Double(value.revenue),label:"")},
            colors: colors,
            holeEnable: true
        )
        pie_chart.legend.enabled = false
        
    }
    
    func setupBarChart(data:[AreaRevenueReportData],barChart:BarChartView){
        
        ChartUtils.customBarChart(
            chartView: barChart,
            barChartItems: data.enumerated().map{(i,value) in BarChartDataEntry(x: Double(i), y: Double(value.revenue))},
            xLabel: data.map{$0.area_name},
            color: colors
        )
    }
    
}
