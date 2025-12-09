//
//  RevenueDetailViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 05/02/2023.
//

import UIKit
import Charts
import Kingfisher
class RevenueDetailViewController: BaseViewController {
    var viewModel = RevenueDetailViewModel()
    var router = RevenueDetailRouter()
    var saleReport = SaleReport.init(reportType: REPORT_TYPE_TODAY, dateString: TimeUtils.getCurrentDateTime().dateTimeNow)
    
    @IBOutlet weak var barChartView: BarChartView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbl_revenue_title: UILabel!
    @IBOutlet weak var lbl_branch_name: UILabel!
    @IBOutlet weak var lbl_branch_address: UILabel!
    @IBOutlet weak var avatar_branch: UIImageView!
    
    @IBOutlet weak var lbl_total_revenue: UILabel!
    
    @IBOutlet weak var reportFilter: ReportFilter!
    var datePicker: DatePickerUtils = DatePickerUtils()

    var lineChartItems = [ChartDataEntry]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        viewModel.saleReport.accept(saleReport)


        registerCell()
        bindTableView()
        
        
        datePicker.chooseDate = { [weak self] (date,tag) in
            self?.handleChooseDate(date: date, tag: tag)
        }
        
        reportFilter.defaultReportType = viewModel.saleReport.value.reportType
        
        reportFilter.chooseReportType = { [weak self] reportType in
            guard let self = self else { return }
            var report = self.viewModel.saleReport.value
           
            if reportType == -1{
               
               
               self.datePicker.showDatePicker(
                    self,
                    date:TimeUtils.convertStringToDate(from: report.fromDate, format: .dd_mm_yyyy),
                    tag:reportType
               )
                
                

            }else if reportType == -2{
               
               self.datePicker.showDatePicker(
                    self,
                    date:TimeUtils.convertStringToDate(from: report.toDate, format: .dd_mm_yyyy),
                    tag:reportType
               )

               
            }else if reportType > 0{
                report.saleReportData = []
                report.reportType = reportType
                report.dateString = Constants.REPORT_TYPE_DICTIONARY[reportType] ?? ""
                viewModel.saleReport.accept(report)
                reportRevenueByTime()
                
                
                switch reportType{
                    case REPORT_TYPE_TODAY:
                        lbl_revenue_title.text = String(format: "DOANH THU %@ | %@", "HÔM NAY",report.dateString)
                    
                    case REPORT_TYPE_YESTERDAY:
                        lbl_revenue_title.text = String(format: "DOANH THU %@ | %@", "HÔM QUA",report.dateString)
                    
                    case REPORT_TYPE_THIS_WEEK:
                        lbl_revenue_title.text = String(format: "DOANH THU %@ | %@", "TUẦN NÀY",report.dateString)
                    
                    case REPORT_TYPE_LAST_MONTH:
                        lbl_revenue_title.text = String(format: "DOANH THU %@ | %@", "THÁNG TRƯỚC",report.dateString)
                    
                    case REPORT_TYPE_THIS_MONTH:
                        lbl_revenue_title.text = String(format: "DOANH THU %@ | %@", "THÁNG NÀY",report.dateString)
                    
                    case REPORT_TYPE_THREE_MONTHS:
                        lbl_revenue_title.text = "DOANH THU 3 THÁNG TRƯỚC"
                    
                    case REPORT_TYPE_LAST_YEAR:
                        lbl_revenue_title.text = String(format: "DOANH THU %@ | %@", "NĂM TRƯỚC",report.dateString)
                    
                    case REPORT_TYPE_THIS_YEAR:
                        lbl_revenue_title.text = String(format: "DOANH THU %@ | %@", "NĂM NAY",report.dateString)
                     
                    case REPORT_TYPE_THREE_YEAR:
                        lbl_revenue_title.text = "DOANH THU 3 NĂM TRƯỚC"
                    
                    case REPORT_TYPE_ALL_YEAR:
                        lbl_revenue_title.text = "DOANH THU TẤT CẢ CÁC NĂM"
                    
                    default:
                        break
                }

                
            }
           
       }
        
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        lbl_branch_name.text = ManageCacheObject.getCurrentBranch().name
        lbl_branch_address.text = ManageCacheObject.getCurrentBranch().address

        avatar_branch.kf.setImage(with: URL(string: Utils.getFullMediaLink(string: ManageCacheObject.getCurrentBranch().image_logo )), placeholder: UIImage(named: "image_defauft_medium"))
        
        reportRevenueByTime()
    }
    


    @IBAction func actionBack(_ sender: Any) {
        viewModel.makePopViewController()
    }
    
    private func handleChooseDate(date:Date,tag:Int){
      
        let dateString = TimeUtils.convertDateToString(from: date, format: .dd_mm_yyyy)
        var report = viewModel.saleReport.value
     
        if tag == -2{
            if TimeUtils.isDateValid(fromDateStr: dateString,toDateStr: report.toDate){
                self.reportFilter.setFromDateTitle(dateString)
                report.fromDate = dateString
                report.reportType = 13
                viewModel.saleReport.accept(report)
                reportRevenueByTime()
            }else{
                viewModel.view?.showWarningMessage(content: "Ngày bắt đầu không được lớn hơn ngày kết thúc")
            }
            
        }else if tag == -1{
            if TimeUtils.isDateValid(fromDateStr: report.fromDate,toDateStr: dateString){
                self.reportFilter.setToDateTitle(dateString)
                report.toDate = dateString
                report.reportType = 13
                viewModel.saleReport.accept(report)
                reportRevenueByTime()
            }else{
                viewModel.view?.showWarningMessage(content: "Ngày bắt đầu không được lớn hơn ngày kết thúc")
            }
        }
        lbl_revenue_title.text = String(format: "DOANH THU %@ - %@",report.fromDate,report.toDate)
    }
}
