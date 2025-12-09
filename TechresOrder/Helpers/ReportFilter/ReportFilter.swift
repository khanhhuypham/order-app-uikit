//
//  ReportFilter.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 14/06/2025.
//

import UIKit

class ReportFilter: UIView {
    
    var container:UIStackView!
    var stackViewOfLeftBtn:UIStackView!


    var btnArray:[UIButton] = []
    
    var chooseReportType: ((Int) -> Void)? = nil
    
    var defaultReportType:Int? = nil{
        didSet{
            if let type = self.defaultReportType, let btn = btnArray.first(where: {$0.tag == type}){
                buttonTapped(btn)
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
        
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    


    private func setup() {
        container = UIStackView()
        container.axis = .horizontal
        container.spacing = 4
        container.alignment = .fill
        container.distribution = .fill
        container.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(container)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: self.topAnchor),
            container.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            container.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            container.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])

        // MARK: - Left Stack (Fixed buttons)
        stackViewOfLeftBtn = UIStackView()
        stackViewOfLeftBtn.axis = .horizontal
        stackViewOfLeftBtn.spacing = 4
        stackViewOfLeftBtn.alignment = .fill
        stackViewOfLeftBtn.distribution = .fill
        stackViewOfLeftBtn.translatesAutoresizingMaskIntoConstraints = false

        stackViewOfLeftBtn.addArrangedSubview(createBtn(title: "Chọn ngày", tag: 0, width: 85))
        container.addArrangedSubview(stackViewOfLeftBtn)

        // MARK: - ScrollView for right-side buttons
        let scrollContainerView = UIView()
        scrollContainerView.translatesAutoresizingMaskIntoConstraints = false
        container.addArrangedSubview(scrollContainerView)

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true
        scrollContainerView.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: scrollContainerView.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: scrollContainerView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: scrollContainerView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: scrollContainerView.trailingAnchor)
        ])

        // MARK: - Stack inside scroll view
        let stackViewOfBtn = UIStackView()
        stackViewOfBtn.axis = .horizontal
        stackViewOfBtn.spacing = 10
        stackViewOfBtn.alignment = .fill
        stackViewOfBtn.distribution = .fill
        stackViewOfBtn.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackViewOfBtn)

        NSLayoutConstraint.activate([
            stackViewOfBtn.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackViewOfBtn.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackViewOfBtn.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackViewOfBtn.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackViewOfBtn.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])

        let buttons: [UIView] = [
            createBtn(title: "Hôm nay", tag: REPORT_TYPE_TODAY, width: 80),
            createBtn(title: "Hôm qua", tag: REPORT_TYPE_YESTERDAY, width: 80),
            createBtn(title: "Tuần này", tag: REPORT_TYPE_THIS_WEEK, width: 80),
            createBtn(title: "Tháng này", tag: REPORT_TYPE_THIS_MONTH, width: 80),
            createBtn(title: "Tháng trước", tag: REPORT_TYPE_LAST_MONTH, width: 100),
            createBtn(title: "3 tháng gần nhất", tag: REPORT_TYPE_THREE_MONTHS, width: 130),
            createBtn(title: "Năm nay", tag: REPORT_TYPE_THIS_YEAR, width: 80),
            createBtn(title: "Năm trước", tag: REPORT_TYPE_LAST_YEAR, width: 90),
            createBtn(title: "3 Năm gần nhất", tag: REPORT_TYPE_THREE_YEAR, width: 120),
            createBtn(title: "Tất cả các năm", tag: REPORT_TYPE_ALL_YEAR, width: 120)
        ]

        for btn in buttons {
            stackViewOfBtn.addArrangedSubview(btn)
        }
        
    }


    private func createBtn(title: String,tag:Int,width: CGFloat) -> UIView {
        
        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.widthAnchor.constraint(equalToConstant: width).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 30).isActive = true

        btn.backgroundColor = .white
        btn.layer.cornerRadius = 15
        btn.layer.masksToBounds = true
        btn.layer.borderColor = ColorUtils.orange_brand_900().cgColor
        btn.layer.borderWidth = 1

        btn.setTitle(title, for: .normal)
        btn.setTitleColor(ColorUtils.orange_brand_900(), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        btn.tag = tag
        
        // ✅ Add action
        btn.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        if (tag > 0){
            // ✅ Append to array
            btnArray.append(btn)
        }

        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(btn)

      
        NSLayoutConstraint.activate([
            btn.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            btn.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            btn.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
   

        return containerView
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        for button in btnArray {
            button.backgroundColor = .white
            button.setTitleColor(ColorUtils.orange_brand_900(), for: .normal)
        }

        sender.backgroundColor = ColorUtils.orange_brand_900()
        sender.setTitleColor(.white, for: .normal)

        print("Selected: \(sender.currentTitle ?? "") \(sender.tag)")
        
        
        if (sender.tag == 0){
            
            stackViewOfLeftBtn.removeAllSubViews()
            stackViewOfLeftBtn.addArrangedSubview(createBtn(title: TimeUtils.getToday(), tag: -2, width: 85))
            stackViewOfLeftBtn.addArrangedSubview(createBtn(title: TimeUtils.getToday(), tag: -1, width: 85))
 
        }else if sender.tag > 0 {
            
            stackViewOfLeftBtn.removeAllSubViews()
            stackViewOfLeftBtn.addArrangedSubview(createBtn(title: "Chọn ngày", tag: 0, width: 85))
            
        }
        
        
        chooseReportType?(sender.tag)
    }


}


extension ReportFilter {
    func setFromDateTitle(_ title: String) {

        
        if let firstView = stackViewOfLeftBtn.arrangedSubviews.first as? UIView{

            if let btn = firstView.subviews.first as? UIButton{
                btn.setTitle(title, for: .normal)
            }
            
        }
    }

    func setToDateTitle(_ title: String) {
        // Get the second arranged view (index 1)
         if stackViewOfLeftBtn.arrangedSubviews.count > 1,let secondView = stackViewOfLeftBtn.arrangedSubviews[1] as? UIView {
             
             if let btn = secondView.subviews.first as? UIButton{
                 btn.setTitle(title, for: .normal)
             }
             
         }
    }
}
