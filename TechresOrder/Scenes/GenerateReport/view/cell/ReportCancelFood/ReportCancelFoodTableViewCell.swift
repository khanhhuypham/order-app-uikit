//
//  ReportCancelFoodTableViewCell.swift
//  Techres-Seemt
//
//  Created by Huynh Quang Huy on 15/05/2023.
//  Copyright © 2023 OVERATE-VNTECH. All rights reserved.
//

import UIKit
import Charts
import RxSwift
import ObjectMapper
class ReportCancelFoodTableViewCell: UITableViewCell {
    

    @IBOutlet weak var bar_chart: BarChartView!
    @IBOutlet weak var root_view_empty_data: UIView!
    
    // MARK: Biến của button filter
    @IBOutlet weak var btn_today: UIButton!
    @IBOutlet weak var btn_yesterday: UIButton!
    @IBOutlet weak var btn_this_week: UIButton!
    @IBOutlet weak var btn_this_month: UIButton!
    @IBOutlet weak var btn_last_month: UIButton!
    @IBOutlet weak var btn_last_three_month: UIButton!
    @IBOutlet weak var btn_this_year: UIButton!
    @IBOutlet weak var btn_last_year: UIButton!
    @IBOutlet weak var btn_last_three_year: UIButton!
    @IBOutlet weak var btn_all_year: UIButton!
    

    @IBOutlet weak var lbl_total_amount: UILabel!
    
    var btnArray:[UIButton] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)

    }
    
    private(set) var disposeBag = DisposeBag()
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    

    
    @IBAction func actionChooseReportType(_ sender: UIButton) {
        guard let viewModel = self.viewModel else {return}
        var cancelFoodReport = viewModel.cancelFoodReport.value
        cancelFoodReport.foods = []
        cancelFoodReport.reportType = sender.tag
        cancelFoodReport.dateString = Constants.REPORT_TYPE_DICTIONARY[sender.tag] ?? ""
        viewModel.cancelFoodReport.accept(cancelFoodReport)
        viewModel.view?.getReportFoodCancel()
    }
    

        
    var viewModel: GenerateReportViewModel? {
           didSet {
               guard let viewModel = self.viewModel else {return}
      
               btnArray = [btn_today, btn_yesterday, btn_this_week, btn_this_month, btn_last_month, btn_last_three_month, btn_this_year, btn_last_year, btn_last_three_year, btn_all_year]
               
               for btn in self.btnArray{
                   btn.rx.tap.asDriver().drive(onNext: { [weak self] in
                       Utils.changeBgBtn(btn: btn, btnArray: self?.btnArray ?? [])
                   }).disposed(by: disposeBag)
                   if btn.tag == viewModel.cancelFoodReport.value.reportType {
                       Utils.changeBgBtn(btn: btn, btnArray: btnArray)
                   }

               }
               
                viewModel.cancelFoodReport.subscribe(onNext: { [self] report in
                    lbl_total_amount.text = report.total_amount.toString
                    root_view_empty_data.isHidden = report.foods.count != 0 ? true : false
                    setupBarChart(data: report.foods, barChart: bar_chart)
                }).disposed(by: disposeBag)
           }
        
        
    }
    
    @IBAction func actionDetail(_ sender: Any) {
        guard let viewModel = self.viewModel else {return}
        viewModel.makeToDetailReportCancelFoodViewController()
    }
    
}




extension ReportCancelFoodTableViewCell {
    func setupBarChart(data:[FoodReport],barChart:BarChartView){
        
        ChartUtils.customBarChart(
            chartView: bar_chart,
            barChartItems: data.enumerated().map{(i,value) in BarChartDataEntry(x: Double(i), y: Double(value.total_amount))},
            xLabel: data.map{String($0.food_name.count <= 15 ? $0.food_name : $0.food_name.prefix(15) + "...")}
        )
        
        bar_chart.isUserInteractionEnabled = true
        // calculate the required height for the chart based on the number of labels and their rotated height
        let labelHeight = barChart.xAxis.labelRotatedHeight // use the rotated label height
        let labelRotationAngle = CGFloat(barChart.xAxis.labelRotationAngle) * .pi / 180 // convert the rotation angle to radians
        let chartHeight = barChart.frame.origin.y + (CGFloat(barChart.xAxis.labelCount) * labelHeight * abs(cos(labelRotationAngle))) // use the rotated height and the cosine of the rotation angle
        // resize the height of the chart view
        barChart.frame.size.height = chartHeight
    }
 
}
