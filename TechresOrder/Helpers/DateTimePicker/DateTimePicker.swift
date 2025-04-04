//
//  DateTimePicker.swift
//  DateTimePicker
//
//

import UIKit

public protocol DateTimePickerDelegate {
    func dateTimePicker(_ picker: DateTimePicker, didSelectDate: Date)
}

@objc public class DateTimePicker: UIView {
    
    var contentHeight: CGFloat = 310
    @objc public enum MinuteInterval: Int {
        case `default` = 1
        case five = 5
        case ten = 10
        case fifteen = 15
        case twenty = 20
        case thirty = 30
    }
    
    /// custom background color, default to clear color
    public var backgroundViewColor: UIColor? = .clear {
        didSet {
            shadowView.backgroundColor = backgroundViewColor
        }
    }
    
    /// custom highlight color, default to cyan
    public var highlightColor = UIColor(red: 0/255.0, green: 199.0/255.0, blue: 194.0/255.0, alpha: 1) {
        didSet {
            todayButton.setTitleColor(highlightColor, for: .normal)
            colonLabel1.textColor = highlightColor
            colonLabel2.textColor = highlightColor
        }
    }
    
    /// custom dark color, default to grey
    public var darkColor = UIColor(red: 0, green: 22.0/255.0, blue: 39.0/255.0, alpha: 1) {
        didSet {
            dateTitleLabel.textColor = darkColor
            cancelButton.setTitleColor(darkColor, for: .normal)
            doneButton.backgroundColor = darkColor.withAlphaComponent(0.5)
            borderTopView.backgroundColor = darkColor.withAlphaComponent(0.2)
            borderBottomView.backgroundColor = darkColor.withAlphaComponent(0.2)
            separatorTopView.backgroundColor = darkColor.withAlphaComponent(0.2)
            separatorBottomView.backgroundColor = darkColor.withAlphaComponent(0.2)
        }
    }
    
    /// custom DONE button color, default to darkColor
    public var doneBackgroundColor: UIColor? {
        didSet {
            doneButton.backgroundColor = doneBackgroundColor
        }
    }
    
    /// custom background color for date cells
    public var daysBackgroundColor = UIColor(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, alpha: 1)
    
    var didLayoutAtOnce = false
    public override func layoutSubviews() {
        super.layoutSubviews()
        // For the first time view will be layouted manually before show
        // For next times we need relayout it because of screen rotation etc.
        if !didLayoutAtOnce {
            didLayoutAtOnce = true
        } else {
            self.configureView()
        }
    }
    
    /// date locale (language displayed), default to American English
    public var locale = Locale(identifier: "en_US") {
        didSet {
            configureView()
        }
    }
    
    /// selected date when picker is displayed, default to current date
    public var selectedDate = Date() {
        didSet {
            self.delegate?.dateTimePicker(self, didSelectDate: selectedDate)
            resetDateTitle()
        }
    }
    
    public var selectedDateString: String {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = self.dateFormat
            return formatter.string(from: self.selectedDate)
        }
    }
    
    /// custom date format to be displayed, default to HH:mm dd/MM/YYYY
    public var dateFormat = "HH:mm dd/MM/YYYY" {
        didSet {
            resetDateTitle()
        }
    }
    
    /// custom title for dismiss button, default to Cancel
    public var cancelButtonTitle = "Cancel" {
        didSet {
            cancelButton.setTitle(cancelButtonTitle, for: .normal)
            let size = cancelButton.sizeThatFits(CGSize(width: 0, height: 44.0)).width + 20.0
            cancelButton.frame = CGRect(x: 20, y: 0, width: size, height: 44)
        }
    }
    
    /// custom title for reset time button, default to Today
    public var todayButtonTitle = "Today" {
        didSet {
            todayButton.setTitle(todayButtonTitle, for: .normal)
            let size = todayButton.sizeThatFits(CGSize(width: 0, height: 44.0)).width
            todayButton.frame = CGRect(x: contentView.frame.width - size - 20, y: 0, width: size, height: 44)
        }
    }
    
    /// custom title for done button, default to DONE
    public var doneButtonTitle = "DONE" {
        didSet {
            doneButton.setTitle(doneButtonTitle, for: .normal)
        }
    }
    
    /// whether to display time in 12 hour format, default to false
    public var is12HourFormat = false {
        didSet {
            configureView()
        }
    }
    
    
    /// whether to only show date in picker view, default to false
    public var isDatePickerOnly = false {
        didSet {
            if isDatePickerOnly {
                isTimePickerOnly = false
            }
            configureView()
        }
    }
    
    /// whether to show only time in picker view, default to false
    public var isTimePickerOnly = false {
        didSet {
            if isTimePickerOnly {
                isDatePickerOnly = false
            }
            configureView()
        }
    }
    
    /// whether to include month in date cells, default to false
    public var includeMonth = false {
        didSet {
            configureView()
        }
    }
    
    /// Time interval, in minutes, default to 1.
    /// If not default, infinite scrolling is off.
    public var timeInterval = MinuteInterval.default {
        didSet {
            resetDateTitle()
        }
    }
    
    public var timeZone = TimeZone.current
    public var completionHandler: ((Date)->Void)?
    public var dismissHandler: (() -> Void)?
    public var delegate: DateTimePickerDelegate?
    
    // private vars
    internal var hourTableView: UITableView!
    internal var minuteTableView: UITableView!
    internal var amPmTableView: UITableView!
    internal var dayCollectionView: UICollectionView!
    internal var monthCollectionView: UICollectionView!
    
    private var shadowView: UIView!
    private var contentView: UIView!
    private var dateTitleLabel: UILabel!
    private var todayButton: UIButton!
    private var doneButton: UIButton!
    private var cancelButton: UIButton!
    private var colonLabel1: UILabel!
    private var colonLabel2: UILabel!
    
    private var borderTopView: UIView!
    private var borderBottomView: UIView!
    private var separatorTopView: UIView!
    private var separatorBottomView: UIView!
    
    internal var minimumDate: Date!
    internal var maximumDate: Date!
    
    internal var calendar: Calendar = .current
    internal var dates: [Date]! = []
    internal var months: [String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "July", "Aug", "Sep", "Oct", "Nov", "Dec"]
    internal var components: DateComponents! {
        didSet {
            components.timeZone = timeZone
        }
    }
    
    
    @objc open class func show(selected: Date? = nil, minimumDate: Date? = nil, maximumDate: Date? = nil, timeInterval: MinuteInterval = .five) -> DateTimePicker {
        let dateTimePicker = DateTimePicker()
        //        dateTimePicker.minimumDate = minimumDate ?? Date(timeIntervalSinceNow: -3600 * 24 * 10)
        //        dateTimePicker.maximumDate = maximumDate ?? Date(timeIntervalSinceNow: 3600 * 24 * 10)
        let currentDate = selected ?? Date()
        dateTimePicker.minimumDate = currentDate.startOfMonth()
        dateTimePicker.maximumDate = currentDate.endOfMonth()
        dateTimePicker.selectedDate = selected ?? dateTimePicker.minimumDate
        dateTimePicker.timeInterval = timeInterval
        
        dateTimePicker.configureView()
        UIApplication.shared.keyWindow?.addSubview(dateTimePicker)
        
        return dateTimePicker
    }
    
    private func configureView() {
        if self.contentView != nil {
            self.contentView.removeFromSuperview()
        }
        let screenSize = UIScreen.main.bounds.size
        self.frame = CGRect(x: 0,
                            y: 0,
                            width: screenSize.width,
                            height: screenSize.height)
        // shadow view
        shadowView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        shadowView.backgroundColor = backgroundViewColor ?? UIColor.black.withAlphaComponent(0.3)
        shadowView.alpha = 1
        let shadowViewTap = UITapGestureRecognizer(target: self, action: #selector(DateTimePicker.dismissView(sender:)))
        shadowView.addGestureRecognizer(shadowViewTap)
        addSubview(shadowView)
        
        // content view
        contentHeight = isDatePickerOnly ? 300 : isTimePickerOnly ? 230 : 400
        contentView = UIView(frame: CGRect(x: 0, y: frame.height, width: frame.width, height: contentHeight))
        contentView.layer.shadowColor = UIColor(white: 0, alpha: 0.3).cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: -2.0)
        contentView.layer.shadowRadius = 1.5
        contentView.layer.shadowOpacity = 0.5
        contentView.backgroundColor = .white
        contentView.isHidden = true
        addSubview(contentView)
        
        // title view
        let titleView = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: contentView.frame.width, height: 50)))
        titleView.backgroundColor = .white
        contentView.addSubview(titleView)
        
        dateTitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
        dateTitleLabel.font = UIFont.systemFont(ofSize: 15)
        dateTitleLabel.textColor = darkColor
        dateTitleLabel.textAlignment = .center
        resetDateTitle()
        titleView.addSubview(dateTitleLabel)
        
        cancelButton = UIButton(type: .system)
        cancelButton.setTitle(cancelButtonTitle, for: .normal)
        cancelButton.setTitleColor(darkColor, for: .normal)
        cancelButton.contentHorizontalAlignment = .left
        cancelButton.addTarget(self, action: #selector(DateTimePicker.dismissView(sender:)), for: .touchUpInside)
        cancelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        let cancelSize = cancelButton.sizeThatFits(CGSize(width: 0, height: 44.0)).width
        cancelButton.frame = CGRect(x: 20, y: 0, width: cancelSize, height: 44)
        titleView.addSubview(cancelButton)
        
        todayButton = UIButton(type: .system)
        todayButton.setTitle(todayButtonTitle, for: .normal)
        todayButton.setTitleColor(highlightColor, for: .normal)
        todayButton.addTarget(self, action: #selector(DateTimePicker.setToday), for: .touchUpInside)
        todayButton.contentHorizontalAlignment = .right
        todayButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        todayButton.isHidden = self.minimumDate.compare(Date()) == .orderedDescending || self.maximumDate.compare(Date()) == .orderedAscending
        let todaySize = todayButton.sizeThatFits(CGSize(width: 0, height: 44.0)).width
        todayButton.frame = CGRect(x: contentView.frame.width - todaySize - 20, y: 0, width: todaySize, height: 44)
        titleView.addSubview(todayButton)
        
        // month collection view
        let monthLayout = StepCollectionViewFlowLayout()
        monthLayout.scrollDirection = .horizontal
        monthLayout.minimumInteritemSpacing = 10
        monthLayout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        monthLayout.itemSize = CGSize(width: 75, height: 40)
        
        monthCollectionView = UICollectionView(frame: CGRect(x: 0, y: 44, width: contentView.frame.width, height: 70), collectionViewLayout: monthLayout)
        
        monthCollectionView.backgroundColor = daysBackgroundColor
        monthCollectionView.showsHorizontalScrollIndicator = false
        monthCollectionView.register(MonthCollectionViewCell.self, forCellWithReuseIdentifier: "monthCell")
        
        monthCollectionView.dataSource = self
        monthCollectionView.delegate = self
        
        let monthInset = (monthCollectionView.frame.width - 75) / 2
        monthCollectionView.contentInset = UIEdgeInsets(top: 0, left: monthInset, bottom: 0, right: monthInset)
        contentView.addSubview(monthCollectionView)
        
        // day collection view
        let layout = StepCollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: 75, height: 80)
        
        dayCollectionView = UICollectionView(frame: CGRect(x: 0, y: 104, width: contentView.frame.width, height: 100), collectionViewLayout: layout)
        dayCollectionView.backgroundColor = daysBackgroundColor
        dayCollectionView.showsHorizontalScrollIndicator = false
        
        if includeMonth {
            dayCollectionView.register(FullDateCollectionViewCell.self, forCellWithReuseIdentifier: "dateCell")
        } else if includeMonth == false {
            dayCollectionView.register(DateCollectionViewCell.self, forCellWithReuseIdentifier: "dateCell")
        }
        
        dayCollectionView.dataSource = self
        dayCollectionView.delegate = self
        dayCollectionView.isHidden = isTimePickerOnly
        
        let inset = (dayCollectionView.frame.width - 75) / 2
        dayCollectionView.contentInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        contentView.addSubview(dayCollectionView)
        
        // top & bottom borders on day collection view
        borderTopView = UIView(frame: CGRect(x: 0, y: titleView.frame.height, width: titleView.frame.width, height: 1))
        borderTopView.backgroundColor = darkColor.withAlphaComponent(0.2)
        borderTopView.isHidden = isTimePickerOnly
        contentView.addSubview(borderTopView)
        
        borderBottomView = UIView(frame: CGRect(x: 0, y: dayCollectionView.frame.origin.y + dayCollectionView.frame.height, width: titleView.frame.width, height: 1))
        borderBottomView.backgroundColor = darkColor.withAlphaComponent(0.2)
        if isTimePickerOnly {
            borderBottomView.frame = CGRect(x: 0, y: dayCollectionView.frame.origin.y, width: titleView.frame.width, height: 1)
        }
        contentView.addSubview(borderBottomView)
        
        // done button
        doneButton = UIButton(type: .system)
        doneButton.frame = CGRect(x: 20, y: contentView.frame.height - 10 - 44 - 10, width: contentView.frame.width - 40, height: 44)
        doneButton.setTitle(doneButtonTitle, for: .normal)
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.backgroundColor = doneBackgroundColor ?? darkColor.withAlphaComponent(0.5)
        doneButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        doneButton.layer.cornerRadius = 3
        doneButton.layer.masksToBounds = true
        doneButton.addTarget(self, action: #selector(DateTimePicker.dismissView(sender:)), for: .touchUpInside)
        contentView.addSubview(doneButton)
        
        // if time picker format is 12 hour, we'll need an extra tableview for am/pm
        // the width for this tableview will be 60, so we need extra -30 for x position of hour & minute tableview
        let extraSpace: CGFloat = is12HourFormat ? -30 : 0
        // hour table view
        hourTableView = UITableView(frame: CGRect(x: contentView.frame.width / 2 - 60 + extraSpace,
                                                  y: borderBottomView.frame.origin.y + 2,
                                                  width: 60,
                                                  height: doneButton.frame.origin.y - borderBottomView.frame.origin.y - 10))
        hourTableView.rowHeight = 36
        hourTableView.showsVerticalScrollIndicator = false
        hourTableView.separatorStyle = .none
        hourTableView.delegate = self
        hourTableView.dataSource = self
        hourTableView.isHidden = isDatePickerOnly
        contentView.addSubview(hourTableView)
        
        // minute table view
        minuteTableView = UITableView(frame: CGRect(x: contentView.frame.width / 2 + extraSpace,
                                                    y: borderBottomView.frame.origin.y + 2,
                                                    width: 60,
                                                    height: doneButton.frame.origin.y - borderBottomView.frame.origin.y - 10))
        minuteTableView.rowHeight = 36
        minuteTableView.showsVerticalScrollIndicator = false
        minuteTableView.separatorStyle = .none
        minuteTableView.delegate = self
        minuteTableView.dataSource = self
        minuteTableView.isHidden = isDatePickerOnly
        if timeInterval != .default {
            minuteTableView.contentInset = UIEdgeInsets(top: minuteTableView.frame.height / 2, left: 0, bottom: minuteTableView.frame.height / 2, right: 0)
        } else {
            minuteTableView.contentInset = UIEdgeInsets.zero
        }
        contentView.addSubview(minuteTableView)
        
        // am/pm table view
        amPmTableView = UITableView(frame: CGRect(x: contentView.frame.width / 2 - extraSpace,
                                                  y: borderBottomView.frame.origin.y + 2,
                                                  width: 64,
                                                  height: doneButton.frame.origin.y - borderBottomView.frame.origin.y - 10))
        amPmTableView.rowHeight = 36
        amPmTableView.contentInset = UIEdgeInsets(top: amPmTableView.frame.height / 2, left: 0, bottom: amPmTableView.frame.height / 2, right: 0)
        amPmTableView.showsVerticalScrollIndicator = false
        amPmTableView.separatorStyle = .none
        amPmTableView.delegate = self
        amPmTableView.dataSource = self
        amPmTableView.isHidden = !is12HourFormat || isDatePickerOnly
        contentView.addSubview(amPmTableView)
        
        
        // colon
        colonLabel1 = UILabel(frame: CGRect(x: 0, y: 0, width: 10, height: 36))
        colonLabel1.center = CGPoint(x: contentView.frame.width / 2 + extraSpace,
                                     y: (doneButton.frame.origin.y - borderBottomView.frame.origin.y - 10) / 2 + borderBottomView.frame.origin.y)
        colonLabel1.text = ":"
        colonLabel1.font = UIFont.boldSystemFont(ofSize: 18)
        colonLabel1.textColor = highlightColor
        colonLabel1.textAlignment = .center
        colonLabel1.isHidden = isDatePickerOnly
        contentView.addSubview(colonLabel1)
        
        colonLabel2 = UILabel(frame: CGRect(x: 0, y: 0, width: 10, height: 36))
        colonLabel2.text = ":"
        colonLabel2.font = UIFont.boldSystemFont(ofSize: 18)
        colonLabel2.textColor = highlightColor
        colonLabel2.textAlignment = .center
        var colon2Center = colonLabel1.center
        colon2Center.x += 57
        colonLabel2.center = colon2Center
        colonLabel2.isHidden = !is12HourFormat || isDatePickerOnly
        contentView.addSubview(colonLabel2)
        
        // time separators
        separatorTopView = UIView(frame: CGRect(x: 0, y: 0, width: 90 - extraSpace * 2, height: 1))
        separatorTopView.backgroundColor = darkColor.withAlphaComponent(0.2)
        separatorTopView.center = CGPoint(x: contentView.frame.width / 2, y: borderBottomView.frame.origin.y + 36)
        separatorTopView.isHidden = isDatePickerOnly
        contentView.addSubview(separatorTopView)
        
        separatorBottomView = UIView(frame: CGRect(x: 0, y: 0, width: 90 - extraSpace * 2, height: 1))
        separatorBottomView.backgroundColor = darkColor.withAlphaComponent(0.2)
        separatorBottomView.center = CGPoint(x: contentView.frame.width / 2, y: separatorTopView.frame.origin.y + 36)
        separatorBottomView.isHidden = isDatePickerOnly
        contentView.addSubview(separatorBottomView)
        
        // fill date
        fillDates(fromDate: minimumDate, toDate: maximumDate)
        updateCollectionView(to: selectedDate)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YYYY"
        for i in 0..<dates.count {
            let date = dates[i]
            if formatter.string(from: date) == formatter.string(from: selectedDate) {
                dayCollectionView.selectItem(at: IndexPath(row: i, section: 0), animated: true, scrollPosition: .centeredHorizontally)
                break
            }
        }
        components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: selectedDate)
        contentView.isHidden = false
        
        resetTime()
        
        // animate to show contentView
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.4, options: .curveEaseIn, animations: {
            self.contentView.frame = CGRect(x: 0,
                                            y: self.frame.height - self.contentHeight,
                                            width: self.frame.width,
                                            height: self.contentHeight)
        }, completion: nil)
    }
    
    @objc
    func setToday() {
        selectedDate = Date()
        fillDates(fromDate: selectedDate.startOfMonth(), toDate: selectedDate.endOfMonth())
        resetTime()
    }
    
    func resetTime() {
        components = calendar.dateComponents([.day, .month, .year, .hour, .minute], from: selectedDate)
        updateCollectionView(to: selectedDate)
        if let hour = components.hour {
            var expectedRow = hour + 24
            if is12HourFormat {
                if hour < 12 {
                    expectedRow = hour + 11
                } else {
                    expectedRow = hour - 1
                }
                
                // workaround to fix issue selecting row when hour 12 am/pm
                if expectedRow == 11 {
                    expectedRow = 23
                }
            }
            hourTableView.selectRow(at: IndexPath(row: expectedRow, section: 0), animated: true, scrollPosition: .middle)
            if hour >= 12 {
                amPmTableView.selectRow(at: IndexPath(row: 1, section: 0), animated: true, scrollPosition: .middle)
            } else {
                amPmTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .middle)
            }
        }
        
        if let minute = components.minute {
            var expectedRow = minute / timeInterval.rawValue
            if timeInterval == .default {
                expectedRow = expectedRow == 0 ? 120 : expectedRow + 60 // workaround for issue when minute = 0
            }
            
            minuteTableView.selectRow(at: IndexPath(row: expectedRow, section: 0), animated: true, scrollPosition: .middle)
        }
    }
    
    private func resetDateTitle() {
        guard dateTitleLabel != nil else {
            return
        }
        
        dateTitleLabel.text = selectedDateString
        dateTitleLabel.sizeToFit()
        dateTitleLabel.center = CGPoint(x: contentView.frame.width / 2, y: 22)
    }
    
    func fillDates(fromDate: Date, toDate: Date) {
        self.dates.removeAll()
        var dates: [Date] = []
        var days = DateComponents()
        
        var dayCount = 0
        repeat {
            days.day = dayCount
            dayCount += 1
            guard let date = calendar.date(byAdding: days, to: fromDate) else {
                break;
            }
            if date.compare(toDate) == .orderedDescending {
                break
            }
            dates.append(date)
        } while (true)
        
        self.dates = dates
        dayCollectionView.reloadData()
        
        if let index = self.dates.index(of: selectedDate) {
            dayCollectionView.selectItem(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        }
    }
    
    func updateCollectionView(to currentDate: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YYYY"
        for i in 0..<dates.count {
            let date = dates[i]
            if formatter.string(from: date) == formatter.string(from: currentDate) {
                let indexPath = IndexPath(row: i, section: 0)
                dayCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                    self.dayCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
                })
                
                break
            }
        }
        
        // udpate month collection view
        formatter.dateFormat = "MM"
        let selectedMonth = Int(formatter.string(from: currentDate))! - 1
        let indexPath = IndexPath(row: selectedMonth, section: 0)
        monthCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            self.monthCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        })
        
    }
    
    @objc
    public func dismissView(sender: UIButton?=nil) {
        UIView.animate(withDuration: 0.3, animations: {
            // animate to show contentView
            self.contentView.frame = CGRect(x: 0,
                                            y: self.frame.height,
                                            width: self.frame.width,
                                            height: self.contentHeight)
        }) {[weak self] (completed) in
            guard let `self` = self else {
                return
            }
            if sender == self.doneButton {
                self.completionHandler?(self.selectedDate)
            } else {
                self.dismissHandler?()
            }
            self.removeFromSuperview()
        }
    }
}

extension DateTimePicker: UITableViewDataSource, UITableViewDelegate {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == hourTableView {
            // need triple of origin storage to scroll infinitely
            return (is12HourFormat ? 12 : 24) * 3
        } else if tableView == amPmTableView {
            return 2
        }
        
        if timeInterval != .default {
            return 60 / timeInterval.rawValue
        }
        // need triple of origin storage to scroll infinitely
        return 60 * 3
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timeCell") ?? UITableViewCell(style: .default, reuseIdentifier: "timeCell")
        
        cell.selectedBackgroundView = UIView()
        cell.textLabel?.textAlignment = tableView == hourTableView ? .right : .left
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        cell.textLabel?.textColor = darkColor.withAlphaComponent(0.4)
        cell.textLabel?.highlightedTextColor = highlightColor
        // add module operation to set value same
        if tableView == amPmTableView {
            cell.textLabel?.text = (indexPath.row == 0) ? "AM" : "PM"
        } else if tableView == minuteTableView{
            if timeInterval == .default {
                cell.textLabel?.text = String(format: "%02i", indexPath.row % 60)
            } else {
                cell.textLabel?.text = String(format: "%02i", indexPath.row * timeInterval.rawValue)
            }
            
        } else {
            if is12HourFormat {
                cell.textLabel?.text = String(format: "%02i", (indexPath.row % 12) + 1)
            } else {
                cell.textLabel?.text = String(format: "%02i", indexPath.row % 24)
            }
        }
        
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedRow = indexPath.row
        var shouldAnimate = true
        
        // adjust selected row number for inifinite scrolling
        if selectedRow != adjustedRowForInfiniteScrolling(tableView: tableView, selectedRow: selectedRow) {
            selectedRow = adjustedRowForInfiniteScrolling(tableView: tableView, selectedRow: selectedRow)
            shouldAnimate = false
        }
        
        tableView.selectRow(at: IndexPath(row: selectedRow, section: 0), animated: shouldAnimate, scrollPosition: .middle)
        if tableView == hourTableView {
            if is12HourFormat {
                components.hour = indexPath.row < 12 ? indexPath.row + 1 : (indexPath.row - 12)%12 + 1
                if let hour = components.hour,
                    amPmTableView.indexPathForSelectedRow?.row == 0 && hour >= 12 {
                    components.hour! -= 12
                } else if let hour = components.hour,
                    amPmTableView.indexPathForSelectedRow?.row == 1 && hour < 12 {
                    components.hour! += 12
                }
            } else {
                components.hour = indexPath.row < 24 ? indexPath.row : (indexPath.row - 24)%24
            }
            
        } else if tableView == minuteTableView {
            if timeInterval == .default {
                components.minute = indexPath.row < 60 ? indexPath.row : (indexPath.row - 60)%60
            } else {
                components.minute = indexPath.row * timeInterval.rawValue
            }
            
        } else if tableView == amPmTableView {
            if let hour = components.hour,
                indexPath.row == 0 && hour >= 12 {
                components.hour = hour - 12
            } else if let hour = components.hour,
                indexPath.row == 1 && hour < 12 {
                components.hour = hour + 12
            }
        }
        
        if let selected = calendar.date(from: components) {
            if selected.compare(minimumDate) == .orderedAscending {
                selectedDate = minimumDate
                resetTime()
            } else {
                selectedDate = selected
            }
        }
    }
    
}

extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
}

extension DateTimePicker: UICollectionViewDataSource, UICollectionViewDelegate {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == dayCollectionView{
            return dates.count
        }else if collectionView == monthCollectionView {
            return months.count
        }
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == dayCollectionView{
            if includeMonth {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as! FullDateCollectionViewCell
                let date = dates[indexPath.item]
                cell.populateItem(date: date, highlightColor: highlightColor, darkColor: darkColor, locale: locale)
                
                return cell
            }
            else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCollectionViewCell
                let date = dates[indexPath.item]
                cell.populateItem(date: date, highlightColor: highlightColor, darkColor: darkColor, locale: locale)
                
                return cell
            }
        }
        
        // show month collection view
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "monthCell", for: indexPath) as! MonthCollectionViewCell
        cell.monthLabel.text = months[indexPath.item]
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //workaround to center to every cell including ones near margins
        if let cell = collectionView.cellForItem(at: indexPath) {
            let offset = CGPoint(x: cell.center.x - collectionView.frame.width / 2, y: 0)
            collectionView.setContentOffset(offset, animated: true)
        }
        if collectionView == dayCollectionView{
            // update selected dates
            let date = dates[indexPath.item]
            let dayComponent = calendar.dateComponents([.day, .month, .year], from: date)
            components.day = dayComponent.day
//            components.month = dayComponent.month
            components.year = dayComponent.year
            if let selected = calendar.date(from: components) {
                if selected.compare(minimumDate) == .orderedAscending {
                    selectedDate = minimumDate
                    resetTime()
                } else {
                    selectedDate = selected
                }
            }
        } else if collectionView == monthCollectionView{
            var monthComponent = calendar.dateComponents([.day,.month,.year], from: selectedDate)
            monthComponent.month = indexPath.item + 1
            if let selected = calendar.date(from: monthComponent) {
                selectedDate = selected
                fillDates(fromDate: selected.startOfMonth(), toDate: selected.endOfMonth())
                minimumDate = selected.startOfMonth()
                maximumDate  = selected.endOfMonth()
                resetTime()
            }
        }
        
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        alignScrollView(scrollView)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            alignScrollView(scrollView)
        }
    }
    
    func alignScrollView(_ scrollView: UIScrollView) {
        if let collectionView = scrollView as? UICollectionView {
            if collectionView == dayCollectionView{
                let centerPoint = CGPoint(x: collectionView.center.x + collectionView.contentOffset.x, y: 50);
                if let indexPath = collectionView.indexPathForItem(at: centerPoint) {
                    // automatically select this item and center it to the screen
                    // set animated = false to avoid unwanted effects
                    collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
                    if let cell = collectionView.cellForItem(at: indexPath) {
                        let offset = CGPoint(x: cell.center.x - collectionView.frame.width / 2, y: 0)
                        collectionView.setContentOffset(offset, animated: false)
                    }
                    
                    // update selected date
                    let date = dates[indexPath.item]
                    let dayComponent = calendar.dateComponents([.day, .month, .year], from: date)
                    components.day = dayComponent.day
                    components.month = dayComponent.month
                    components.year = dayComponent.year
                    if let selected = calendar.date(from: components) {
                        if selected.compare(minimumDate) == .orderedAscending {
                            selectedDate = minimumDate
                            resetTime()
                        } else {
                            selectedDate = selected
                        }
                    }
                }
            } else if collectionView == monthCollectionView {
                //TODO: do requried operation
            }
        } else if let tableView = scrollView as? UITableView {
            
            var selectedRow = 0
            if let firstVisibleCell = tableView.visibleCells.first,
                tableView != amPmTableView {
                var firstVisibleRow = 0
                if tableView.contentOffset.y >= firstVisibleCell.frame.origin.y + tableView.rowHeight/2 - tableView.contentInset.top {
                    firstVisibleRow = (tableView.indexPath(for: firstVisibleCell)?.row ?? 0) + 1
                } else {
                    firstVisibleRow = (tableView.indexPath(for: firstVisibleCell)?.row ?? 0)
                }
                if tableView == minuteTableView && timeInterval != .default {
                    selectedRow = min(max(firstVisibleRow, 0), self.tableView(tableView, numberOfRowsInSection: 0)-1)
                } else {
                    selectedRow = firstVisibleRow + 1
                }
                
                // adjust selected row number for inifinite scrolling
                selectedRow = adjustedRowForInfiniteScrolling(tableView: tableView, selectedRow: selectedRow)
                
            } else if tableView == amPmTableView {
                if -tableView.contentOffset.y > tableView.rowHeight/2 {
                    selectedRow = 0
                } else {
                    selectedRow = 1
                }
            }
            
            tableView.selectRow(at: IndexPath(row: selectedRow, section: 0), animated: false, scrollPosition: .middle)
            if tableView == hourTableView {
                if is12HourFormat {
                    components.hour = selectedRow < 12 ? selectedRow + 1 : (selectedRow - 12)%12 + 1
                    if let hour = components.hour,
                        amPmTableView.indexPathForSelectedRow?.row == 0 && hour >= 12 {
                        components.hour! -= 12
                    } else if let hour = components.hour,
                        amPmTableView.indexPathForSelectedRow?.row == 1 && hour < 12 {
                        components.hour! += 12
                    }
                } else {
                    components.hour = selectedRow < 24 ? selectedRow : (selectedRow - 24)%24
                }
                
            } else if tableView == minuteTableView {
                if timeInterval == .default {
                    components.minute = selectedRow < 60 ? selectedRow : (selectedRow - 60)%60
                } else {
                    components.minute = selectedRow * timeInterval.rawValue
                }
            } else if tableView == amPmTableView {
                if let hour = components.hour,
                    selectedRow == 0 && hour >= 12 {
                    components.hour = hour - 12
                } else if let hour = components.hour,
                    selectedRow == 1 && hour < 12 {
                    components.hour = hour + 12
                }
            }
            
            if let selected = calendar.date(from: components) {
                if selected.compare(minimumDate) == .orderedAscending {
                    selectedDate = minimumDate
                    resetTime()
                } else {
                    selectedDate = selected
                }
                
            }
        }
    }
    
    func adjustedRowForInfiniteScrolling(tableView: UITableView, selectedRow: Int) -> Int {
        if tableView == minuteTableView &&
            timeInterval != .default {
            return selectedRow
        }
        
        let numberOfRow = self.tableView(tableView, numberOfRowsInSection: 0)
        if selectedRow == 1 {
            return selectedRow + numberOfRow / 3
        } else if selectedRow == numberOfRow - 2 {
            return selectedRow - numberOfRow / 3
        }
        return selectedRow
    }
}
