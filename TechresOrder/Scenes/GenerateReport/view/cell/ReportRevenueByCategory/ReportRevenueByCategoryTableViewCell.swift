//
//  ReportRevenueByCategoryTableViewCell.swift
//  TechresOrder
//
//  Created by Kelvin on 04/02/2023.
//

import UIKit
import Charts
import RxSwift
import RxRelay
class ReportRevenueByCategoryTableViewCell: UITableViewCell {
    @IBOutlet weak var btnDetail: UIButton!
    @IBOutlet weak var lbl_total_revenue: UILabel!
    @IBOutlet weak var table_view_cate: UITableView!

    @IBOutlet weak var lbl_title_report: UILabel!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var pie_chart: PieChartView!
    var pieChartItems = [PieChartDataEntry]()
    var colors = [UIColor]()
    
    var totalAmount = 1.0
    
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
        // Initialization code
        registerCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
        // Configure the view for the selected state
    }
    
    //MARK: Register Cells as you want
    func registerCell(){
        let categoryItemRevenueTableViewCell = UINib(nibName: "CategoryItemRevenueTableViewCell", bundle: .main)
        table_view_cate.register(categoryItemRevenueTableViewCell, forCellReuseIdentifier: "CategoryItemRevenueTableViewCell")
        table_view_cate.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
//    @IBAction func actionChooseReportType(_ sender: UIButton) {
//        
//        guard let viewModel = self.viewModel else {return}
//        var categoryReport = viewModel.categoryRevenueReport.value
//        categoryReport.revenuesData = []
//        categoryReport.reportType = sender.tag
//        categoryReport.dateString = Constants.REPORT_TYPE_DICTIONARY[sender.tag] ?? ""
//        viewModel.categoryRevenueReport.accept(categoryReport)
//        viewModel.view?.getCategoryReport()
//    }

    
    @IBAction func actionDetail(_ sender: Any) {
        guard let viewModel = self.viewModel else {return}
        viewModel.makeToDetailRevenueByFoodCategoryViewController()
    }
    
    private func handleChooseDate(date:Date,tag:Int){
        guard let viewModel = self.viewModel else {return}
        
        
        let dateString = TimeUtils.convertDateToString(from: date, format: .dd_mm_yyyy)
        var report = viewModel.categoryRevenueReport.value
     
        if tag == -2{
            
            if TimeUtils.isDateValid(fromDateStr: dateString,toDateStr: report.toDate){
                self.reportFilter.setFromDateTitle(dateString)
                report.fromDate = dateString
                report.reportType = 13
                viewModel.categoryRevenueReport.accept(report)
                viewModel.view?.getCategoryReport()
            }else{
                viewModel.view?.showWarningMessage(content: "Ngày bắt đầu không được lớn hơn ngày kết thúc")
            }
          
        }else if tag == -1{
            
            if TimeUtils.isDateValid(fromDateStr: report.fromDate,toDateStr: dateString){
                self.reportFilter.setToDateTitle(dateString)
                report.toDate = dateString
                report.reportType = 13
                viewModel.categoryRevenueReport.accept(report)
                viewModel.view?.getCategoryReport()
                
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
           
           reportFilter.defaultReportType = viewModel.categoryRevenueReport.value.reportType
           reportFilter.chooseReportType = { [weak self] reportType in
              var report = viewModel.categoryRevenueReport.value
              
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
                  viewModel.categoryRevenueReport.accept(report)
                  viewModel.view?.getCategoryReport()
                  
              }
              
          }
           
           
           
           bindViewModel()
       }
    }
    
}
extension ReportRevenueByCategoryTableViewCell:UITableViewDelegate{
    private func bindViewModel() {
        if let viewModel = viewModel {
            /*
                 table_view_cate lắng nghe trước sau đó
                 viewModel.revenueCategories.accept(revenueCategory.revenues!) là table_view_cate sẽ có dữ liệu
             */
            viewModel.categoryRevenueReport.map{$0.revenuesData}.bind(to: table_view_cate.rx.items(cellIdentifier: "CategoryItemRevenueTableViewCell", cellType: CategoryItemRevenueTableViewCell.self))
            {(row, category, cell) in
                cell.color = self.colors[row]
                cell.totalAmount = self.totalAmount
                cell.category = category
            }.disposed(by: disposeBag)
            
            viewModel.categoryRevenueReport.subscribe( // Thực hiện subscribe Observable data
              onNext: { [weak self] report in
                  self?.lbl_total_revenue.text = Utils.stringVietnameseMoneyFormatWithNumberInt(amount: report.total_amount)
                  
                  self!.setByCategoryRevenueChart(revenues: report.revenuesData)
                  self!.totalAmount = Double(report.total_amount)

            }).disposed(by: disposeBag)
        }

     }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ReportRevenueByCategoryTableViewCell{

    func setByCategoryRevenueChart(revenues: [RevenueCategory]) {
        self.pie_chart.noDataText = NSLocalizedString("Data not available", comment: "")
        pieChartItems.removeAll()
        
        
        
        colors = revenues.map{_ in ColorUtils.random()}
        pieChartItems = revenues.enumerated().map{(index,value) in PieChartDataEntry(value: Double(value.total_amount))}

    
//        
        self.colors.append(ColorUtils.red_color())
        self.colors.append(ColorUtils.orange_brand_900())
//        
        

        pie_chart.drawHoleEnabled = true
        pie_chart.drawCenterTextEnabled = true
        pie_chart.holeRadiusPercent = 0.5
        pie_chart.transparentCircleRadiusPercent = 0.61
               
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center

        let centerText = NSMutableAttributedString(string: Utils.stringVietnameseMoneyFormatWithNumberInt(amount: Int(revenues.map{Double($0.total_amount)}.reduce(0.0, +))))

        centerText.addAttributes([.font : UIFont.systemFont(ofSize: 14,weight: .bold),
                                  .foregroundColor : ColorUtils.green_600()],
                             range: NSRange(location: 0, length: centerText.length))

        pie_chart.centerAttributedText = centerText
     
        
        let pieChartDataSet = PieChartDataSet(entries: self.pieChartItems, label: "")
        pieChartDataSet.colors = self.colors
        pieChartDataSet.sliceSpace = 0
        pieChartDataSet.selectionShift = 5
        pieChartDataSet.xValuePosition = .insideSlice
        pieChartDataSet.yValuePosition = .insideSlice
        pieChartDataSet.valueTextColor = .white
        pieChartDataSet.valueLineWidth = 100
        pieChartDataSet.valueLinePart1Length = 1
        pieChartDataSet.valueLinePart2Length = 1
        pieChartDataSet.drawValuesEnabled = false
        pieChartDataSet.drawIconsEnabled = false
        
        let noZeroFormatter = NumberFormatter()
        noZeroFormatter.zeroSymbol = ""
        pieChartDataSet.valueFormatter = DefaultValueFormatter(formatter: noZeroFormatter)
        
        pie_chart.data = PieChartData(dataSet: pieChartDataSet)
        pie_chart.entryLabelColor = .black
        pie_chart.transparentCircleRadiusPercent = CGFloat(0.1)
        //gone chú thích
        pie_chart.legend.enabled = false
        pie_chart.legend.horizontalAlignment = .center

        pie_chart.clearsContextBeforeDrawing = true
        pie_chart.animate(yAxisDuration: 2.0, easingOption: ChartEasingOption.easeInOutBack)
        pie_chart.entryLabelFont = UIFont.init(name: "HelveticaNeue", size: 4)
    }
    
}
