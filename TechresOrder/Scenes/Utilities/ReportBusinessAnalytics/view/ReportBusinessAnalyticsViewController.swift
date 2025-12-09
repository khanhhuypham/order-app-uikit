//
//  ReportBusinessAnalyticsViewController.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 25/02/2023.
//

import UIKit
import BmoViewPager

class ReportBusinessAnalyticsViewController: BaseViewController {
    var viewModel = ReportBusinessAnalyticsViewModel()
    var router = ReportBusinessAnalyticsRouter()
    
    
    @IBOutlet weak var viewPager: BmoViewPager!
    @IBOutlet weak var viewPagerNavigationBar: BmoViewPagerNavigationBar!
    

    @IBOutlet weak var lbl_branch_name: UILabel!
    @IBOutlet weak var lbl_branch_address: UILabel!
    @IBOutlet weak var branch_logo: UIImageView!
    
    var report_type = 1
    var cates = [Category]()
    
    
    @IBOutlet weak var reportFilter: ReportFilter!
    var datePicker: DatePickerUtils = DatePickerUtils()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let link_image = Utils.getFullMediaLink(string: ManageCacheObject.getCurrentBranch().image_logo )
        branch_logo.kf.setImage(with: URL(string: link_image), placeholder: UIImage(named: "image_defauft_medium"))
        lbl_branch_name.text = ManageCacheObject.getCurrentBranch().name
        lbl_branch_address.text =  ManageCacheObject.getCurrentBranch().address

        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        viewModel.branch_id.accept(Constants.branch.id)
        
        self.viewPagerNavigationBar.viewPager = viewPager
        self.viewPagerNavigationBar.layer.masksToBounds = true
        self.viewPager.presentedPageIndex = 0
        self.viewPager.dataSource = self
        self.viewPager.delegate = self
        
//        getCurentTime()
        getCategoriesManagement()
        
        
        datePicker.chooseDate = { [weak self] (date,tag) in
            self?.handleChooseDate(date: date, tag: tag)
        }
        
        reportFilter.defaultReportType = viewModel.report_type.value
        
        reportFilter.chooseReportType = { [weak self] reportType in
            guard let self = self else { return }
           
           if reportType == -1{
               
               self.datePicker.showDatePicker(
                    self,
                    date:TimeUtils.convertStringToDate(from: viewModel.to_date.value, format: .dd_mm_yyyy),
                    tag:reportType
               )
            
           }else if reportType == -2{
               
               self.datePicker.showDatePicker(
                    self,
                    date:TimeUtils.convertStringToDate(from: viewModel.from_date.value, format: .dd_mm_yyyy),
                    tag:reportType
               )


           }else if reportType > 0{
            
               viewModel.date_string.accept(Constants.REPORT_TYPE_DICTIONARY[reportType] ?? "")
               viewModel.report_type.accept(reportType)
     
               
           }
           
       }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    @IBAction func actionBack(_ sender: Any) {
        viewModel.makePopViewController()
    }
    
    
    private func handleChooseDate(date:Date,tag:Int){
    
        let dateString = TimeUtils.convertDateToString(from: date, format: .dd_mm_yyyy)
        
        if tag == -2{
            
            if TimeUtils.isDateValid(fromDateStr: dateString,toDateStr: viewModel.to_date.value){
                self.reportFilter.setFromDateTitle(dateString)
                viewModel.from_date.accept(dateString)
                viewModel.report_type.accept(13)
             
            }else{
                viewModel.view?.showWarningMessage(content: "Ngày bắt đầu không được lớn hơn ngày kết thúc")
            }
          
        }else if tag == -1{
            
            if TimeUtils.isDateValid(fromDateStr: viewModel.from_date.value,toDateStr: dateString){
                self.reportFilter.setToDateTitle(dateString)
                viewModel.to_date.accept(dateString)
                viewModel.report_type.accept(13)
    
            }else{
                viewModel.view?.showWarningMessage(content: "Ngày bắt đầu không được lớn hơn ngày kết thúc")
            }
        }
    }
    
}
extension ReportBusinessAnalyticsViewController: BmoViewPagerDataSource, BmoViewPagerDelegate{
    
    func bmoViewPagerDataSourceNumberOfPage(in viewPager: BmoViewPager) -> Int {
        return self.cates.count
    }
    
    func bmoViewPagerDataSource(_ viewPager: BmoViewPager, viewControllerForPageAt page: Int) -> UIViewController {

        let categoryReportViewController = CategoryReportViewController()
        self.viewModel.cate_id.accept(cates[page].id)
        self.viewModel.category_types.accept(cates[page].type)
        categoryReportViewController.viewModel = self.viewModel
        return categoryReportViewController
    }
    
    func bmoViewPagerDataSourceNaviagtionBarItemNormalAttributed(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> [NSAttributedString.Key : Any]? {
        return [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14.0,weight: .semibold),
            NSAttributedString.Key.foregroundColor : ColorUtils.green_200()
        ]
    }
    
    func bmoViewPagerDataSourceNaviagtionBarItemHighlightedAttributed(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> [NSAttributedString.Key : Any]? {
        return [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14.0, weight: .semibold),
            NSAttributedString.Key.foregroundColor : ColorUtils.green_600()
        ]
    }
    
    
    func bmoViewPagerDataSourceNaviagtionBarItemTitle(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> String? {
        return cates[page].name.uppercased()
    }

    func bmoViewPagerDataSourceNaviagtionBarItemSize(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> CGSize {
        

        if self.cates.count > 3 {
            return CGSize(width: (navigationBar.bounds.width) / 3 - 10, height: navigationBar.bounds.height)
        }
        else {
            return CGSize(width: (navigationBar.bounds.width) / CGFloat(cates.count), height: navigationBar.bounds.height)
        }
    }
    

    func bmoViewPagerDataSourceNaviagtionBarItemHighlightedBackgroundView(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> UIView? {
        let view = UIView()
        view.addBottomBorder(color: ColorUtils.green_600(),borderLineSize:4)
        return view
    }

}
