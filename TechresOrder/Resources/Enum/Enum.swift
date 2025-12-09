//
//  Enum.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 05/04/2024.
//

import UIKit
import RealmSwift


enum OrderAction {
    case orderHistory
    case moveTable
    case mergeTable
    case splitFood
    case cancelOrder
    case sharePoint
}


enum Order_Method:Int {
    case EAT_IN = 0 // Phục vụ tại quán
    case TAKE_AWAY = 1 // Đơn hàng mang về
    case ONLINE_DELIVERY = 2 // Đơn hàng online
    case SHOPEE_FOOD = 3 // Đơn hàng online
    case GRAB_FOOD = 4 // Đơn hàng online
    case GO_FOOD = 5 // Đơn hàng online
    case BE_FOOD = 6 // Đơn hàng online
    
    var prefix:String{
        switch self {
        case .EAT_IN:
            return ""
            
        case .TAKE_AWAY:
            return "MV"
            
        case .ONLINE_DELIVERY:
            return ""
            
        case .SHOPEE_FOOD:
            return ""
            
        case .GRAB_FOOD:
            return ""
            
        case .GO_FOOD:
            return ""
            
        case .BE_FOOD:
            return ""
        }
    }
    
    var fgColor:UIColor{
        switch self {
        case .EAT_IN:
            return ColorUtils.black()
        case .TAKE_AWAY:
            return ColorUtils.black()
        case .ONLINE_DELIVERY:
            return ColorUtils.black()
        case .SHOPEE_FOOD:
            return ColorUtils.hexStringToUIColor(hex: "#EE4E2E")
        case .GRAB_FOOD:
            return ColorUtils.hexStringToUIColor(hex: "#009E3A")
        case .GO_FOOD:
            return ColorUtils.black()
        case .BE_FOOD:
            return ColorUtils.hexStringToUIColor(hex: "#FFC418")
        }
    }
}



//MARK: enum for food
enum CATEGORY_TYPE:CaseIterable{
    case processed
    case nonProcessed
    case nonProcessedOther
//    case service
   
    static func setValue(value: Int)-> Self {
        switch value {
            case 1:
                return .processed
            case 2:
                return .nonProcessed
            case 3:
                return .nonProcessedOther
//            case 4:
//                return .service
            default:
                return .processed
        }
    }

    var value: Int {
        switch self {
            case .processed:
                return 1
            case .nonProcessed:
                return 2
            case .nonProcessedOther:
                return 3
//            case .service:
//                return 4
        }
    }
    
    var name: String {
        switch self {
            case .processed:
                return "Có chế biến/Pha chế"
            case .nonProcessed:
                return "Không chế biến"
            case .nonProcessedOther:
                return "Khác (Không chế biến)"
//            case .service:
//                return "Dịch vụ"

        }
    }
}

enum FOOD_CATEGORY:Int{
    case food = 1
    case drink = 2
    case other = 3
    case seafood = 4
    case service = 5
    case buffet_ticket = 6
    case all = -1
}


enum FOOD_STATUS:Int{
    
    case pending = 0; //Mon moi goi
    case cooking = 1; // Dang nau
    case done = 2; // Hoan tat mon
    case not_enough = 3; // het mon
    case cancel = 4; // Huy mon
    case servic_block_using = 7 // dịch vụ đang sử dụng
    case servic_block_stopped = 8 //  dịch vụ đã ngưng
    case wait_fish_tank_confirm = 9 //  Chờ hồ hải sản xác nhận
    case wait_customer_confirm_seafood = 10 //  chờ khách xác nhận hải sản
    case customer_confirmed_seafood = 11 //  Khách hàng đã xác nhận hải sản
    
    
    static func setValue(value: Int) -> Self {
        switch value {
            case 0:
                return .pending
            
            case 1:
                return .cooking
            
            case 2:
                return .done
            
            case 3:
                return .not_enough
                
            case 4:
                return .cancel
                
            case 7:
                return .servic_block_using
            
            case 8:
                return .servic_block_stopped
            
            case 9:
                return .wait_fish_tank_confirm
            
            case 10:
                return .wait_customer_confirm_seafood
            
            case 11:
                return .customer_confirmed_seafood
            
            default:
                return .pending
        }
    }
    
    var description: String {
        switch self {
            case .pending:
                return "CHỜ CHẾ BIẾN"
            
            case .cooking:
                return "ĐANG CHẾ BIẾN"
            
            case .done:
                return "HOÀN TẤT"
            
            case .not_enough:
                return "HẾT MÓN"
            
            case .cancel:
                return "ĐÃ HỦY"
            
            case .servic_block_using:
                return "ĐANG SỬ DỤNG"
            
            case .servic_block_stopped:
                return "ĐANG TẠM DỪNG"
            
            case .wait_fish_tank_confirm:
                return "CHỜ HỒ HẢI SẢN XÁC NHẬN"
            
            case .wait_customer_confirm_seafood:
                return "CHỜ KHÁCH HÀNG XÁC NHẬN HẢI SẢN"
            
            case .customer_confirmed_seafood:
                return "KHÁCH HÀNG ĐÃ XÁC NHẬN HẢI SẢN"
        }
    }
    
    
    var fgColor: UIColor {
        
        switch self {
            case .pending:
                return ColorUtils.orange_brand_900()
            
            case .cooking:
                return ColorUtils.blue_brand_700()
                
            case .done:
                return ColorUtils.green_600()
            
            case .not_enough:
                return ColorUtils.red_500()
            
            case .cancel:
                return ColorUtils.red_500()
            
            case .servic_block_using:
                return ColorUtils.green_600()
            
            case .servic_block_stopped:
                return ColorUtils.red_500()
            
            case .wait_fish_tank_confirm:
                return ColorUtils.blue_brand_700()
            
            case .wait_customer_confirm_seafood:
                return ColorUtils.blue_brand_700()
            
            case .customer_confirmed_seafood:
                return ColorUtils.blue_brand_700()
        }
    }
    
    var bgColor: UIColor {
        switch self {
            case .pending,.cooking,.done,.servic_block_using,.servic_block_stopped,.wait_fish_tank_confirm,.wait_customer_confirm_seafood,.customer_confirmed_seafood:
                return ColorUtils.white()
            
            case .not_enough:
                return ColorUtils.red_000()
            
            case .cancel:
                return ColorUtils.red_000()
            
        }
    }
    
    
    
}

enum BOOKING_STATUS:Int{
    case booking_completed = 4// hoàn tất
    case booking_cancel = 5 // hủy
    case booking_expired = 8// Hết hạn
    case booking_waiting_confirm = 1// đang chờ nhà hàng xác nhận
    case booking_waiting_setup = 2// Chờ setup
    case booking_setup = 9// đã set up chờ nhận khách
    case bokking_waiting_complete = 3 // đơn hàng đã bắt đầu, chờ hoàn tất hóa đơn
    case booking_confirmed = 7 // Đã xác nhận
}

//MARK: enum for payment process
enum PAYMENT_METHOD:Int{
    case cash = 1
    case transfer = 6 //Chuyển khoản
    case atm_card = 2 //sử dụng thẻ
}

enum PAYMENT_TYPE:Int{
    case viet_qr = 0
    case payos = 2
}


//MARK: enum for printer
enum PRINTER_TYPE:Int,PersistableEnum{
    case bar = 0
    case chef = 1
    case cashier = 2
    case fish_tank = 3
    case stamp = 4
    case cashier_of_food_app = 6
    case stamp_of_food_app = 7
}

@objc(CONNECTION_TYPE)
enum CONNECTION_TYPE:Int,PersistableEnum{
    case wifi = 0
    case Imin = 1
    case sunmi = 2
    case usb = 3
    case blueTooth = 4
    
    var name: String {
        switch self {
            case .wifi:
                return "Wifi"
            case .Imin:
                return "Imin"
            case .sunmi:
                return "Sunmi"
            case .usb:
                return "USB"
            case .blueTooth:
                return "BlueTooth"

        }
    }
}


@objc(PRINTER_METHOD)
public enum PRINTER_METHOD:Int{
    case POSPrinter = 1
    case TSCPrinter = 2
    case BLEPrinter = 3
}

@objc(PRINT_MODE)
enum PRINT_MODE:Int,PersistableEnum{
    case printBackgroundWithRetry = 0
    case printBackgroundWithoutRetry = 1
    case printForeground = 2
}

enum Bill_TYPE:Int{
    case bill1 = 0
    case bill2 = 1
    case bill3 = 2
    case bill4 = 3
}

enum KITCHEN_TICKET_TYPE {
    case new_item
    case cancel_item
    case return_item
    case print_test


    // 2- Hủy món | 3- trả bia | 1- món mới
    var value: Int {
        switch self {
        case .print_test:
            return 0
        case .new_item:
            return 1
        case .cancel_item:
            return 2
        case .return_item:
            return 3
        
        }
    }
}




//MARK: enum for food app
enum APP_PARTNER:String,CaseIterable{
    case shoppee = "SHF"
    case grabfood = "GRF"
    case gofood = "GOF"
    case befood = "BEF"
    
    
    var maximumQuantityAccount:Int{
        switch self {
            case .shoppee:
                return Constants.brand.setting?.maximum_shf_account ?? 0
            
            case .grabfood:
                return Constants.brand.setting?.maximum_grf_account ?? 0
            
            case .gofood:
                return 0
            
            case .befood:
                return Constants.brand.setting?.maximum_bef_account ?? 0
        }
    }
    
    var logo:UIImage{
        switch self {
            case .shoppee:
                return UIImage(named: "image-shopeefood-logo") ?? UIImage()
            
            case .grabfood:
                return UIImage(named: "image-grabfood-logo") ?? UIImage()
            
            case .gofood:
                return UIImage(named: "") ?? UIImage()
            
            case .befood:
                return UIImage(named: "image-befood-logo") ?? UIImage()
        }
    }
    
    var value:Int{
        switch self {
            case .shoppee:
                return 1
            
            case .grabfood:
                return 2
            
            case .gofood:
                return 3
            
            case .befood:
                return 4
        }
    }
    
    
    var description:String{
        switch self {
            case .shoppee:
                return "ShopeeFood"
            
            case .grabfood:
                return "GrabFood"
            
            case .gofood:
                return "GoFood"
            
            case .befood:
                return "BeFood"
        }
    }
    
    
    func displayOrderCode(displayId: String) -> String {
        switch self {
            case .shoppee:
                return String(format:"SHOPEE-%@", displayId)
            
            case .grabfood:
                return String(format:"GRAB-%@",  displayId)
            
            case .gofood:
                return String(format:"GO-%@", displayId)
            
            case .befood:
                return String(format:"BE-%@", displayId)
        }
    }
    
    
}




//MARK: enum for food e-invoice
enum PARTNER_INVOICE_TYPE:Int,CaseIterable{
    case minvoice = 1
    case fpt = 2
    case mifi = 3
    case vnpt = 4
    case misa = 5
    case hilo = 6
    case viettel = 7
    
    var name: String {
        switch self {
            case .minvoice:
                return "MINVOICE"
    
            case .fpt:
                return "FPT"
            
            case .mifi:
                return "MIFI"
                
            case .vnpt:
                return "VNPT"
            
            case .misa:
                return "MISA"
            
            case .hilo:
                return "HILO"
            
            case .viettel:
                return "VIETTEL"
          
        }
    }
}



enum QRCODE_TYPE:Int{
    case viet_qr = 0
    case eco_pay = 1
    case pay_os = 2
}


enum itemType {
    case wifi
    case tsc
    
    var name: String {
        switch self {
            case .wifi:
                return "wifi"
            case .tsc:
                return "tsc"
          
        }
    }
}


enum OrderStatusOfFoodApp:Int {
    case cancel = 0
    case complete = 1
    case processing = -1
}

enum OrderStatusOfTechresShop:Int {
    case waiting_confirm = 0
    case payment = 2
    case cancel = 3
    case RETURN = 4
}

enum PaymentStatusOfTechresShop:Int {
    case payment_waitting_confirm = 1 //cho thanh toa
    case payment_complete = 2// hoan tat
  
}


enum DISCOUNT_TYPE:Int{
    case percent = 1
    case number = 2
}


enum Gender:Int,CaseIterable{
    case male = 1
    case female = 0
    
    var name: String {
        switch self {
            
            case .male:
                return "Nam"
            
            case .female:
                return "Nữ"
          
        }
    }
}

enum REPORT_TYPE:Int,CaseIterable{
    case today = 1 //lấy theo ngày
    case yesterday = 9  // lấy theo ngày hôm qua
    case this_week = 2 // lấy theo tuần
    case this_month = 3 // lấy theo tháng
    case three_month = 4 // lấy theo 3 tháng gần nhất
    case this_year = 5 // lấy theo năm
    case last_year = 11//Lấy theo năm trước
    case three_year = 6// lấy theo 3 năm gần nhất
    case last_month = 10 // lấy theo tháng trước
    case all_year = 8 // lấy tất cả thời gian
    
    var from_date: String {
        let calendar = Calendar.current
        let formatter = dateFormatter.dd_mm_yyyy.value
        let today = Date()
     
        
        switch self {
            case .today:
                // Start of today
                return formatter.string(from: calendar.startOfDay(for: today))
                
            case .yesterday:
                // Start of yesterday
                if let yesterday = calendar.date(byAdding: .day, value: -1, to: today) {
                    return formatter.string(from: calendar.startOfDay(for: yesterday))
                }
                return ""

            case .this_week:
                // Start of this week (Monday)
                if let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)) {
                    return formatter.string(from: startOfWeek)
                }
                return ""

            case .this_month:
                // Start of this month (1st day)
                let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: today))
                return formatter.string(from: startOfMonth!)

            case .three_month:
                // Start of three months ago
                if let threeMonthsAgo = calendar.date(byAdding: .month, value: -3, to: today) {
                    let startOfThreeMonthsAgo = calendar.date(from: calendar.dateComponents([.year, .month], from: threeMonthsAgo))
                    return formatter.string(from: startOfThreeMonthsAgo!)
                }
                return ""

            case .this_year:
                // Start of this year (1st January)
                let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: today))
                return formatter.string(from: startOfYear!)

            case .last_year:
                // Start of last year (1st January)
                if let lastYear = calendar.date(byAdding: .year, value: -1, to: today) {
                    let startOfLastYear = calendar.date(from: calendar.dateComponents([.year], from: lastYear))
                    return formatter.string(from: startOfLastYear!)
                }
                return ""

            case .three_year:
                // Start of three years ago
                if let threeYearsAgo = calendar.date(byAdding: .year, value: -3, to: today) {
                    let startOfThreeYearsAgo = calendar.date(from: calendar.dateComponents([.year], from: threeYearsAgo))
                    return formatter.string(from: startOfThreeYearsAgo!)
                }
                return ""

            case .last_month:
                // Start of last month (1st day of previous month)
                if let lastMonth = calendar.date(byAdding: .month, value: -1, to: today) {
                    let startOfLastMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: lastMonth))
                    return formatter.string(from: startOfLastMonth!)
                }
                return ""

            case .all_year:
                // Start of all time (you can define a fixed starting date or use a very early date)
                return "01/10/2000" // Example: Start from January 1st, 2000, or adjust as needed.
        }
    }
    
    var to_date: String {
        let calendar = Calendar.current
        let formatter = dateFormatter.dd_mm_yyyy.value
        let today = Date()
        
        switch self {
            case .today:
                // End of today
                return formatter.string(from: today)
                
            case .yesterday:
                // End of yesterday
                return formatter.string(from: today)
            
            case .this_week:
                if let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)) {
                    if let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek) {
                        return formatter.string(from: endOfWeek)
                    }
                }
                return formatter.string(from: today)
            
            case .this_month:
                // End of this month (last day)
                if let range = calendar.range(of: .day, in: .month, for: today) {
                    let lastDayOfMonth = range.count
                    let components = calendar.dateComponents([.year, .month], from: today)
                    if let endOfMonth = calendar.date(from: components)?.addingTimeInterval(TimeInterval((lastDayOfMonth - 1) * 86400)) {
                        return formatter.string(from: endOfMonth)
                    }
                }
                return ""
            
            case .three_month:
                // End of the current day (today)
                return formatter.string(from: today)
            
            case .this_year:
                // End of this year (31st December)
                let components = DateComponents(year: calendar.component(.year, from: today) + 1, month: 1, day: 0)
                if let endOfYear = calendar.date(from: components) {
                    return formatter.string(from: endOfYear)
                }
                return ""
            
            case .last_year:
                // End of last year (31st December)
                let components = DateComponents(year: calendar.component(.year, from: today), month: 1, day: 0)
                if let endOfLastYear = calendar.date(from: components) {
                    return formatter.string(from: endOfLastYear)
                }
                return ""
            
            case .three_year:
                // End of the current day (today)
                return formatter.string(from: today)
                
            case .last_month:
                // End of last month (last day of previous month)
                if let lastMonth = calendar.date(byAdding: .month, value: -1, to: today) {
                    let range = calendar.range(of: .day, in: .month, for: lastMonth)!
                    let lastDayOfMonth = range.count
                    let components = calendar.dateComponents([.year, .month], from: lastMonth)
                    if let endOfLastMonth = calendar.date(from: components)?.addingTimeInterval(TimeInterval((lastDayOfMonth - 1) * 86400)) {
                        return formatter.string(from: endOfLastMonth)
                    }
                }
                return ""
            
            case .all_year:
                // End of today as the default
                return formatter.string(from: today)
        }
    }
}



