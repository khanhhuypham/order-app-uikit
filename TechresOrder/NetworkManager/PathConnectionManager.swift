//
//  PathConnectionManager.swift
//  aloline-phamkhanhhuy
//
//  Created by Pham Khanh Huy on 16/02/2024.
//

import UIKit


extension ConnectionManager {
    
    private static let version_of_small_order = "v17"
    private static let version_of_order = "v17"
    private static let version_of_dashboard = "v16"
    private static let version_of_app_food = "v5"
    private static let version_of_report = "v2"
    private static let version_of_finance_report = "v2"
    private static let upload_api_version = "v2"
    private static let version_oauth_service = "v11"
    private static let version_of_log_api = "v2"
    
    var path: String {
        
        switch self {
            //MARK: Authentication API
            case .sessions:
                return String(format:environmentMode == .offline ? "/api/sessions" : "/api/%@/sessions",ConnectionManager.version_oauth_service)
            
            case .config:
                return String(format:environmentMode == .offline ? "/api/configs" : "/api/%@/configs", ConnectionManager.version_oauth_service)
                
            case .orders(_,_,_,_,_):
                return String(
                    format:environmentMode == .offline ? "/api/orders/elk/list" : "/api/%@/orders/elk/list",
                    permissionUtils.GPBH_1 ? ConnectionManager.version_of_small_order : ConnectionManager.version_of_order
                )
       
            case .checkVersion:
                return String(format:environmentMode == .offline ? "/api/check-version" : "/api/%@/check-version", ConnectionManager.version_oauth_service)
                
            case .regisDevice(_):
                return String(format:environmentMode == .offline ? "/api/register-device" : "/api/%@/register-device", ConnectionManager.version_oauth_service)
            
            case .login(_, _):
                return String(format:environmentMode == .offline ? "/api/employees/login" : "/api/%@/employees/login", ConnectionManager.version_oauth_service)
        
            case .loginUsingCode(_,_,_,_):
                return String(format: "/api/%@/employees/code/login", ConnectionManager.version_oauth_service)
            
            case .getCodeAuthenticationList:
                return String(format: "/api/%@/code-authentication", ConnectionManager.version_oauth_service)
            
            case .postCreateAuthenticationCode(_,_):
                return String(format: "/api/%@/code-authentication/create", ConnectionManager.version_oauth_service)
            
            case .postChangeStatusOfAuthenticationCode(let id):
                return String(format: "/api/%@/code-authentication/%d/change-status", ConnectionManager.version_oauth_service,id)
            
            case .forgotPassword(_):
                return String(format: "/api/%@/employees/forgot-password",ConnectionManager.version_oauth_service)
                
            case .verifyOTP(_, _, _):
                return String(format: "/api/%@/employees/verify-code", ConnectionManager.version_oauth_service)
                
            case .verifyPassword(_, _, _):
                return String(format: "/api/%@/employees/verify-change-password", ConnectionManager.version_oauth_service)
            
            case .changePassword(let employee_id, _, _, _):
                let version = permissionUtils.GPBH_1 ? ConnectionManager.version_of_small_order : ConnectionManager.version_of_order
                return String(format: "/api/%@/employees/%d/change-password", version, employee_id)

            //MARK: restaurant setting
            case .setting(_):
                return String(format:environmentMode == .offline ? "/api/employees/settings" : "/api/%@/employees/settings", ConnectionManager.version_oauth_service)
            
            case .brands(_, _):
                return String(format:environmentMode == .offline ?  "/api/restaurant-brands" :  "/api/%@/restaurant-brands", ConnectionManager.version_of_dashboard)
     
            case .branches(_, _):
                return String(format:environmentMode == .offline ?  "/api/branches" :  "/api/%@/branches", ConnectionManager.version_of_dashboard)
            
            case .getBrandSetting(let brand_id):
                return environmentMode == .offline
                ? String(format:"/api/restaurant-brands/%d/setting",brand_id)
                : String(format:"/api/%@/restaurant-brands/%d/setting",ConnectionManager.version_of_dashboard,brand_id)
            
            case .postApplyOnlyCashAmount(let branchId):
                return String(format: "/api/%@/branches/%d/setting/is-apply-only-cash-amount",ConnectionManager.version_of_dashboard,branchId)
            
            case .getApplyOnlyCashAmount(let branchId):
                return environmentMode == .offline
                ? String(format: "/api/branches/%d/setting/is-apply-only-cash-amount",branchId)
                : String(format: "/api/%@/branches/%d/setting/is-apply-only-cash-amount",ConnectionManager.version_of_dashboard,branchId)
        
            case .postConfirmChannelOrder(let branchId,_):
                return environmentMode == .offline
                ? String(format: "/api/branches/%d/setting/confirm-channel-order",branchId)
                : String(format: "/api/%@/branches/%d/setting/confirm-channel-order",ConnectionManager.version_of_dashboard,branchId)
            
            //MARK: =============
            
            case .areas(_, _):
                return String(format:environmentMode == .offline ? "/api/areas" : "/api/%@/areas", ConnectionManager.version_of_order)
     
            case .tables(_, _, _, _, _,_):
                return String(format:environmentMode == .offline ? "/api/tables" : "/api/%@/tables", ConnectionManager.version_of_order)
        
            
                
            case .order(let order_id, _):
                return environmentMode == .offline
                ?  String(format: "/api/orders/%d",order_id)
                :  String(format: "/api/%@/orders/%d", ConnectionManager.version_of_order,order_id)
                
                
            case .foods(_,_,_,_,_,_,_,_,_,_):
                return String(format:environmentMode == .offline ?  "/api/foods/menu" :  "/api/%@/foods/menu", ConnectionManager.version_of_order)
            
            case .addFoods(_, let  order_id, _, _):
                return environmentMode == .offline
                ?  String(format:"/api/orders/%d/add-food",order_id)
                :  String(format:"/api/%@/orders/%d/add-food", ConnectionManager.version_of_order,order_id)

            case .addGiftFoods(_, let order_id, _, _):
                return environmentMode == .offline
                ?  String(format:"/api/orders/%d/gift-food",order_id)
                :  String(format:"/api/%@/orders/%d/gift-food", ConnectionManager.version_of_order,order_id)
                
            case .kitchenes(_, _, _):
                return String(format:environmentMode == .offline ?  "/api/restaurant-kitchen-places" : "/api/%@/restaurant-kitchen-places", ConnectionManager.version_of_order)
       
            case .vats:
                return String(format:environmentMode == .offline ?  "/api/restaurant-vat-configs" : "/api/%@/restaurant-vat-configs", ConnectionManager.version_of_order)
                
            case .addOtherFoods(_, let order_id, _):
                return environmentMode == .offline
                ?  String(format:"/api/orders/%d/add-special-food",order_id)
                :  String(format:"/api/%@/orders/%d/add-special-food", ConnectionManager.version_of_order,order_id)
                
            case .addNoteToOrderDetail(_, let order_detail_id, _):
                return environmentMode == .offline
                ?  String(format:"/api/order-details/%d/note",order_detail_id)
                :  String(format:"/api/%@/order-details/%d/note", ConnectionManager.version_of_order,order_detail_id)
                
                
            case .reasonCancelFoods(_):
                return String(format:environmentMode == .offline ?  "/api/orders/cancel-reasons" : "/api/%@/orders/cancel-reasons", ConnectionManager.version_of_order)
                
            case .cancelFood(_, let order_id, _, _, _):
                return environmentMode == .offline
                ?  String(format: "/api/orders/%d/cancel-order-detail",order_id)
                :  String(format: "/api/%@/orders/%d/cancel-order-detail", ConnectionManager.version_of_order,order_id)
                
            case .updateFoods(_, let order_id, _):
                return environmentMode == .offline
                ?  String(format:"/api/orders/%d/update-multi-order-detail",order_id)
                :  String(format:"/api/%@/orders/%d/update-multi-order-detail", ConnectionManager.version_of_order,order_id)
                
            case .ordersNeedMove(_, let order_id, _):
                return environmentMode == .offline
                ? String(format: "/api/orders/%d/order-detail-move",order_id)
                : String(format: "/api/%@/orders/%d/order-detail-move", ConnectionManager.version_of_order, order_id)
                    
            case .moveFoods(_,_, let destination_table_id,_,_):
                return environmentMode == .offline
                ? String(format: "/api/tables/%d/move-food",destination_table_id)
                : String(format: "/api/%@/tables/%d/move-food", ConnectionManager.version_of_order,destination_table_id)
          
            case .getOrderDetail(let order_id,_,_,_):
                return environmentMode == .offline
                ? String(format: "/api/orders/%d",order_id)
                : String(format: "/api/%@/orders/%d", ConnectionManager.version_of_order,order_id)
                    
            case .openTable(let table_id):
                return environmentMode == .offline
                ? String(format: "/api/tables/%d/open",table_id)
                : String(format: "/api/%@/tables/%d/open", ConnectionManager.version_of_order,table_id)
            
            case .discount(let order_id,_,_,_,_,_,_,_,_):
                return environmentMode == .offline
                ? String(format: "/api/orders/%d/apply-discount",order_id)
                : String(format: "/api/%@/orders/%d/apply-discount", ConnectionManager.version_of_order,order_id)
                
            case .moveTable(_,let destination_table_id,_):
                return environmentMode == .offline
                ? String(format: "/api/tables/%d/move",destination_table_id)
                : String(format: "/api/%@/tables/%d/move", ConnectionManager.version_of_order,destination_table_id)
                
            case .mergeTable(_, let destination_table_id,_):
                return environmentMode == .offline
                ? String(format: "/api/tables/%d/merge",destination_table_id)
                : String(format: "/api/%@/tables/%d/merge", ConnectionManager.version_of_order,destination_table_id)
                
            case .profile(_, let employee_id):
                return String(format: "/api/%@/employees/%d",ConnectionManager.version_of_order,employee_id)
                
            case .extra_charges(_, _, _):
                return String(format: environmentMode == .offline ? "/api/restaurant-extra-charges" : "/api/%@/restaurant-extra-charges" ,ConnectionManager.version_of_order)
                
            case .addExtraCharge(_,let order_id,_,_,_,_,_):
                return environmentMode == .offline
                ? String(format: "/api/order-extra-charges/%d/add-extra-charges",order_id)
                : String(format: "/api/%@/order-extra-charges/%d/add-extra-charges",ConnectionManager.version_of_order,order_id)
                    
            
            case .returnBeer(_,let order_id, _, _, _):
               
                return environmentMode == .offline
                ? String(format: "/api/orders/%d/return-beer",order_id)
                : String(format: "/api/%@/orders/%d/return-beer",ConnectionManager.version_of_order,order_id)
                
            case .reviewFood(let order_id, _):
                return environmentMode == .offline
                ? String(format: "/api/orders/%d/review-order-details",order_id)
                : String(format: "/api/%@/orders/%d/review-order-details",ConnectionManager.version_of_order, order_id)
               
                
            case .getFoodsNeedReview(_,let order_id):
                return environmentMode == .offline
                ? String(format: "/api/orders/%d/customer-review",order_id)
                : String(format: "/api/%@/orders/%d/customer-review",ConnectionManager.version_of_order,order_id)
                
            case .updateCustomerNumberSlot(_,let order_id,_):
                return String(format: "/api/%@/orders/%d/update-customer-slot-number",ConnectionManager.version_of_order,order_id)
                
            case .requestPayment(_,let order_id, _, _):
                return environmentMode == .offline
                ? String(format: "/api/orders/%d/request-payment",order_id)
                : String(format: "/api/%@/orders/%d/request-payment",ConnectionManager.version_of_order,order_id)
                
            case .completedPayment(_,let order_id, _, _, _, _, _):
                return environmentMode == .offline
                ? String(format: "/api/orders/%d/complete",order_id)
                : String(format: "/api/%@/orders/%d/complete",ConnectionManager.version_of_order,order_id)
            
            case .createArea(_,_,_):
                return String(format: "/api/%@/areas/manage",ConnectionManager.version_of_order)

            case .foodsManagement(_, _, _, _, _):
                return String(format: "/api/%@/foods/branch",ConnectionManager.version_of_order)

            case .categoriesManagement(_,_,_):
                return String(format:environmentMode == .offline ? "/api/categories" : "/api/%@/categories",ConnectionManager.version_of_order)
                
            case .notesManagement(_, _):
                return String(format: "/api/%@/order-detail-notes",ConnectionManager.version_of_order)
                
            case .createTable(_, _, _, _, _, _):
                return String(format:"/api/%@/tables/manage",ConnectionManager.version_of_order)
                
            case .prints(_, _, _, _):
                return String(format:"/api/%@/restaurant-kitchen-printers",ConnectionManager.version_of_order)
            
            //MARK: working session
            case .openSession(_, _):
                return String(format: "/api/%@/order-session/open-session",ConnectionManager.version_of_order)
                
            case .workingSessions(_,  let employee_id):
                return String(format: "/api/%@/employees/%d/branch-working-sessions",ConnectionManager.version_of_dashboard, employee_id)
                
            case .checkWorkingSessions:
                return String(format: "/api/%@/order-session/check-working-session",ConnectionManager.version_of_order)
            
            case .workingSessionValue:
                return String(format: "/api/%@/order-session/working-session-value",ConnectionManager.version_of_order)
                
            case .closeWorkingSession(_):
                return String(format: "/api/%@/order-session/close-session",ConnectionManager.version_of_order)
                
            case .assignWorkingSession(_, _):
                return String(format: "/api/%@/order-session-employee/create",ConnectionManager.version_of_dashboard)
            //===================================================
            
            case .sharePoint(let order_id, _):
                return String(format:"/api/%@/orders/%d/share-point",ConnectionManager.version_of_order,order_id)
                
            case .employeeSharePoint(_,let order_id):
                return String(format:"/api/%@/orders/%d/share-point",ConnectionManager.version_of_order,order_id)
                
            case .currentPoint(let employee_id):
                return String(format: "/api/%@/employees/%d/next-salary-target", ConnectionManager.version_of_order,employee_id)
                
            case .assignCustomerToBill(let order_id, _):
                return String(format: "/api/%@/orders/%d/assign-to-customer",ConnectionManager.version_of_order,order_id)
                
            case .applyVAT(_, let order_id, _):
                return environmentMode == .offline
                ? String(format: "/api/orders/%d/apply-vat",order_id)
                : String(format: "/api/%@/orders/%d/apply-vat",ConnectionManager.version_of_order,order_id)
                
            case .fees(_, _, _, _, _, _, _, _, _, _):
                return String(format: "/api/%@/addition-fees",ConnectionManager.version_of_order)
                
            case .createFee(_, _, _, _, _, _, _):
                return String(format: "/api/%@/addition-fees/create",ConnectionManager.version_of_order)
                
            case .foodsNeedPrint(_):
                return String(format: environmentMode == .offline ? "/api/orders/is-print" : "/api/%@/orders/is-print",ConnectionManager.version_of_order)
                
            case .requestPrintChefBar(let order_id, _, _):
                return environmentMode == .offline
                ?  String(format: "/api/orders/%d/print",order_id)
                :  String(format: "/api/%@/orders/%d/print",ConnectionManager.version_of_order,order_id)

                
            case .updateReadyPrinted(_, _):
                return String(format:environmentMode == .offline ? "/api/orders/is-print" : "/api/%@/orders/is-print", ConnectionManager.version_of_order)
       
                
            case .employees(_, _):
                return String(format: "/api/%@/employees",ConnectionManager.version_of_order)
                
            case .kitchens(_, _):
                return String(format: environmentMode == .offline ? "/api/restaurant-kitchen-places" : "/api/%@/restaurant-kitchen-places",ConnectionManager.version_of_order)
                
            case .updatePrinter(_,  let kitchen):
                return environmentMode == .offline
                ?  String(format: "/api/restaurant-kitchen-places/%d",kitchen.id)
                :  String(format: "/api/%@/restaurant-kitchen-places/%d",ConnectionManager.version_of_order,kitchen.id)
                
            case .createNote(_, _, _):
                return String(format:"/api/%@/order-detail-notes/manage",ConnectionManager.version_of_order)
                
            case .createCategory(_, _, _, _, _):
                return String(format: "/api/%@/categories/create",ConnectionManager.version_of_order)
                
            case .ordersHistory(_, _,_,_, _,_,_,_):
                return String(format: "/api/%@/orders/elk/list",permissionUtils.GPBH_1 ? ConnectionManager.version_of_small_order : ConnectionManager.version_of_order)
                
            case .units:
                return String(format: "/api/%@/foods/unit",ConnectionManager.version_of_order)
                
            case .createFood(_, _):
                return String(format: "/api/%@/foods/create",ConnectionManager.version_of_order)
                
            case .generateFileNameResource(_):
                return APIEndPoint.Name.urlGenerateLink
                
            case .updateFood(_, let food):
                return String(format: "/api/%@/foods/%d/update",ConnectionManager.version_of_order,food.id)
                
            case .updateCategory(let id, _, _, _, _, _):
                return String(format: "/api/%@/categories/%d/update",ConnectionManager.version_of_order,id)
                
            case .cities:
                return String(format: "/api/%@/administrative-units/cities",ConnectionManager.version_of_order)
                
            case .districts(_, _):
                return String(format: "/api/%@/administrative-units/districts",ConnectionManager.version_of_order)
                
            case .wards(_,_):
                return String(format: "/api/%@/administrative-units/wards", ConnectionManager.version_of_order)
                
            case .updateProfile(let profileRequest):
                return String(format: "/api/%@/employees/%d/change-profile",ConnectionManager.version_of_order,profileRequest.id)
                
            case .updateProfileInfo(let infoRequest):
                return String(format: "/api/%@/employee-profile/%d",ConnectionManager.version_of_order,infoRequest.employee_id)
                
                
            case .closeTable(let order_id):
                return environmentMode == .offline
                ? String(format: "/api/tables/%d/close",order_id)
                : String(format: "/api/%@/tables/%d/close",ConnectionManager.version_of_order,order_id)
            
            case .feedbackDeveloper(_, _, _, _, _):
                return String(format: "/api/%@/employees/feedback",ConnectionManager.version_of_order)
                
            case .sentError(_, _, _, _, _):
                return String(format: "/api/%@/employees/feedback",ConnectionManager.version_of_order)
                
            case .notes(_):
                return String(format:environmentMode == .offline ? "/api/order-detail-notes" : "/api/%@/order-detail-notes", ConnectionManager.version_of_order)
                
            case .gift(_, _):
                return String(format: "/api/%@/customer-gifts/qr-code-gift", ConnectionManager.version_of_order)
                
            case .useGift(_,let order_id, _, _):
                return String(format: "/api/%@/orders/%d/use-customer-gift-food",ConnectionManager.version_of_order,order_id)
                
            case .tablesManager(_, _, _, _):
                return String(format: "/api/%@/tables/manage", ConnectionManager.version_of_order)
                
            case .notesByFood(let order_detail_id, _):
                return environmentMode == .offline
                ? String(format: "/api/food-notes/by-food-id/%d",order_detail_id)
                : String(format: "/api/%@/food-notes/by-food-id/%d",ConnectionManager.version_of_dashboard, order_detail_id)
           
            case .getVATDetail(let order_id, _):
                return environmentMode == .offline
                ? String(format: "/api/orders/%d/order-detail-by-vat-percent",order_id)
                : String(format: "/api/%@/orders/%d/order-detail-by-vat-percent",ConnectionManager.version_of_order,order_id)
            
            //MARK: API REPORT
            case .report_revenue_by_time(_, _, _, _, _, _):
                return String(format:"/api/%@/order-restaurant-revenue-report",ConnectionManager.version_of_report)
                
            case .report_revenue_activities_in_day_by_branch(_, _, _, _, _, _):
                return String(format:"/api/%@/order-restaurant-current-day",ConnectionManager.version_of_report)
                
            case .report_revenue_fee_profit(_,_,_,_,_,_,_):
                return String(format:"/api/%@/order-revenue-cost-profit-by-branch",ConnectionManager.version_of_report)
          
            case .report_revenue_by_category(_, _, _, _, _, _):
                return String(format:"/api/%@/order-restaurant-revenue-by-category",ConnectionManager.version_of_report)
                
            case .report_revenue_by_employee(_, _, _, _, _, _, _):
                return String(format:"/api/%@/order-revenue-current-by-employee",ConnectionManager.version_of_report)
                
            case .report_business_analytics(_, _, _, _, _, _, _, _, _, _, _, _, _):
                return String(format:"/api/%@/order-restaurant-revenue-by-food",ConnectionManager.version_of_report)
           
            case .report_revenue_by_all_employee(_, _, _, _, _, _):
                return String(format:"/api/%@/order-restaurant-revenue-by-employee",ConnectionManager.version_of_report)
                
            case .cancelExtraCharge(branch_id: _, order_id: let order_id, reason: _, order_extra_charge: _, _):
                return environmentMode == .offline
                ? String(format: "/api/order-extra-charges/%d/cancel-extra-charge",order_id)
                : String(format: "/api/%@/order-extra-charges/%d/cancel-extra-charge",ConnectionManager.version_of_order ,order_id)
            
            case .postUpdateReprintNumber(let order_id):
                return String(format: "/api/%@/orders/%d/reprint",ConnectionManager.version_of_order,order_id)
                
            case .postTransferConfirmationToFishTank(let itemId):
                return String(format: "/api/%@/order-details/%d/seafood-waiting-tank-confirm",ConnectionManager.version_of_order,itemId)
                
            case .report_food(_,_,_,_,_,_,_,_,_,_,_,_,_):
                return String(format:"/api/%@/order-report-food",ConnectionManager.version_of_report)
                
            case .report_cancel_food(_,_,_,_,_,_,_,_,_,_,_,_):
                return String(format:"/api/%@/order-report-food-cancel",ConnectionManager.version_of_report)
                
            case .report_gifted_food(_,_,_,_,_,_,_,_,_,_,_,_):
                return String(format:"/api/%@/order-report-food-gift",ConnectionManager.version_of_report)
                
            case .report_discount(_,_,_,_,_,_):
                return String(format:"/api/%@/order-restaurant-discount-from-order",ConnectionManager.version_of_report)
                
            case .report_VAT(_,_,_,_,_,_):
                return String(format:"/api/%@/window-order-report-data/vat",ConnectionManager.version_of_report)
                    
            case .report_area_revenue(_,_,_,_,_,_):
                return String(format:"/api/%@/window-area-revenue-rank",ConnectionManager.version_of_report)
                
            case .report_table_revenue(_,_,_,_,_,_,_):
                return String(format:"/api/%@/order-restaurant-revenue-by-table",ConnectionManager.version_of_report)
            
            case .updateOtherFeed(let id, _,_,_):
                return String(format: "/api/%@/addition-fees/%d", ConnectionManager.version_of_order,id)
            
            case .getAdditionFee(let id):
                return String(format: "/api/%@/addition-fees/%d", ConnectionManager.version_of_order,id)
                
            case .updateAdditionFee(let id,_,_,_,_,_,_,_,_,_,_,_,_):
                return String(format: "/api/%@/addition-fees/%d/update",ConnectionManager.version_of_order,id)
                
            case .cancelAdditionFee(let id,_,_,_):
                return String(format: "/api/%@/addition-fees/%d/change-status",ConnectionManager.version_of_order,id)
                
            case .updateOtherFee(let id,_,_,_,_,_,_,_,_,_):
                return String(format: "/api/%@/addition-fees/%d/update", ConnectionManager.version_of_order,id)
                
            case .moveExtraFoods(_,let order_id,_,_):
                return String(format: "/api/%@/order-extra-charges/%d/move",ConnectionManager.version_of_order,order_id)
                
            case .getFoodsBookingStatus(let order_id):
                return String(format: "api/%@/order-details/%d/booking",ConnectionManager.version_of_order,order_id)
                
            case .updateBranch(let branch):
                return String(format:"api/%@/branches/%d",ConnectionManager.version_of_order,branch.id)
            
            //MARK: API REPORT SEEMT
            case .getReportOrderRestaurantDiscountFromOrder(_, _, _, _, _, _):
                return String(format:"/api/%@/order-restaurant-discount-from-order",ConnectionManager.version_of_report)
                
            case .getOrderReportFoodCancel(_, _, _, _, _, _, _):
                return String(format:"/api/%@/order-report-food-cancel",ConnectionManager.version_of_report)
                
            case .getOrderReportFoodGift(_, _, _, _, _, _, _, _):
                return String(format:"/api/%@/order-report-food-gift",ConnectionManager.version_of_report)
                
            case .getOrderReportTakeAwayFood(_, _, _, _, _, _, _, _, _, _, _, _):
                return String(format:"/api/%@/order-report-food-take-away",ConnectionManager.version_of_report)
                
            case .getReportRevenueGenral(_, _, _, _, _, _):
                return String(format:"/api/%@/order-restaurant-revenue-report",ConnectionManager.version_of_report)
                
            case .getReportRevenueArea(_, _, _, _, _, _):
                return String(format:"/api/%@/order-restaurant-revenue-by-area",ConnectionManager.version_of_report)
                
            case .getReportSurcharge(_, _, _, _, _, _):
                return String(format:"/api/%@/order-restaurant-order-extra-charge",ConnectionManager.version_of_report)
                
            case .getReportRevenueProfitFood(_, _, _, _, _, _, _, _, _):
                return String(format:"/api/%@/order-report-food",ConnectionManager.version_of_report)
            
            case .getRestaurantOtherFoodReport(_, _, _, _, _, _, _, _, _):
                return String(format:"/api/%@/order-restaurant-revenue-by-food",ConnectionManager.version_of_report)
                
            case .getRestaurantVATReport(_, _, _, _, _, _):
                return String(format:"/api/%@/window-order-report-data/vat",ConnectionManager.version_of_report)
                                    
            case .getRenueByEmployeeReport(_, _, _, _, _, _):
                return String(format:"/api/%@/order-restaurant-revenue-by-employee",ConnectionManager.version_of_report)
                
            case .getInfoBranches(let IdBranches):
                return String(format: "/api/%@/branches/%d",ConnectionManager.version_of_order,IdBranches)
            
            case .healthCheckForBuffet(_,_,_,_):
                return APIEndPoint.Name.urlHealthCheckForBuffet
                    
            case .getLastLoginDevice(_,_):
                return String(format: "/api/%@/employees/device/last-login", ConnectionManager.version_oauth_service)
                
            case .postCreateOrder(_,_,_):
                return String(format: environmentMode == .offline ? "api/orders/create" : "api/%@/orders/create",ConnectionManager.version_of_order)
                
            case .getTotalAmountOfOrders(_,_,_,_,_,_):
                return String(format: "/api/%@/orders/elk/count",permissionUtils.GPBH_1 ? ConnectionManager.version_of_small_order : ConnectionManager.version_of_dashboard)
            
            case .postApplyExtraChargeOnTotalBill(let order_id,_,_):
                return environmentMode == .offline
                ? String(format: "/api/orders/%d/apply-extra-charge",order_id)
                : String(format: "/api/%@/orders/%d/apply-extra-charge",ConnectionManager.version_of_dashboard,order_id)
                    
             
            case .postPauseService(let order_id,_,_):
                return environmentMode == .offline
                ? String(format: "/api/order-details/service/%d/pause",order_id)
                : String(format: "/api/%@/order-details/service/%d/pause",ConnectionManager.version_of_order,order_id)
                
            case .postUpdateService(let order_id,_,_,_,_,_):
                return environmentMode == .offline
                ? String(format: "/api/order-details/service/%d/update",order_id)
                : String(format: "/api/%@/order-details/service/%d/update",ConnectionManager.version_of_order,order_id)
            
                
            case .getActivityLog(_,_,_,_,_,_,_,_):
                return String(format:environmentMode == .offline ? "/api/log-activities" : "/api/%@/logs/activity",ConnectionManager.version_of_log_api)
                
        
            case .getVersionApp(_, _, _, _, _):
                return "/api/public/versions"
                
            case .postApplyTakeAwayTable(let branch_id):
                return String(format: "/api/%@/branches/%d/setting/is-apply-take-away-table",ConnectionManager.version_of_order,branch_id)
                
            case .postCreateTableList(_,_,_):
                return String(format:"/api/%@/tables/create/list",ConnectionManager.version_of_order)
                
            case .getPrintItem(_,_,_):
                excludedAPIString = "/api/print/v2"
                return "/api/print/v2"
            
            case .getReprintItems(let order_id):
                return environmentMode == .offline
                ? String(format: "/api/order-details/%d/reprint",order_id)
                : String(format: "/api/%@/order-details/%d/reprint",ConnectionManager.version_of_order,order_id)
            
            case .getSendToKitchen(_,_):
                return String(format:environmentMode == .offline ? "/api/order-details/send-to-kitchen" : "/api/%@/order-details/send-to-kitchen",ConnectionManager.version_of_order)
            
            case .postSendToKitchen(_,_,_):
                return String(format:environmentMode == .offline ? "/api/order-details/send-to-kitchen" : "/api/%@/order-details/send-to-kitchen",ConnectionManager.version_of_order)
            
            case .getBankAccount(_, _, _):
                return String(format: "/api/%@/restaurant-brand-bank-accounts", ConnectionManager.version_of_order)
            
            case .getBankList:
                return String(format: "/api/%@/restaurant-brand-bank-accounts/bank-list",ConnectionManager.version_of_order)
            
            case .getBrandBankAccount(_,_):
                return String(format: environmentMode == .offline ? "/api/restaurant-brand-bank-accounts/default": "/api/%@/restaurant-brand-bank-accounts/default",ConnectionManager.version_of_order)
                
            case .postCreateBrandBankAccount(_,_):
                return String(format:"/api/%@/restaurant-brand-bank-accounts/create",ConnectionManager.version_of_order)
                    
            case .postUpdateteBrandBankAccount(_,let bankAccount):
                return String(format:"/api/%@/restaurant-brand-bank-accounts/%d/update",ConnectionManager.version_of_order,bankAccount.id)
            
            case .getAlolineCustomer(_,_):
                return String(format:"/api/%@/customers/list-customer-registered-membership-card",ConnectionManager.version_of_dashboard)
            
            case .postAssignCustomerToOrder(_,let orderId,_):
                return environmentMode == .offline
                ? String(format:"/api/orders/%d/assign-to-customer",orderId)
                : String(format:"/api/%@/orders/%d/assign-to-customer",ConnectionManager.version_of_order,orderId)
         
                
            case .postUnassignCustomerFromOrder(let orderId):
                return environmentMode == .offline
                ? String(format:"/api/orders/%d/un-assign-to-customer",orderId)
                : String(format:"/api/%@/orders/%d/un-assign-to-customer",ConnectionManager.version_of_order,orderId)
            
            case .postCreateNewCustomer(let orderId,_):
                return environmentMode == .offline
                ? String(format:"/api/orders/%d/shipping-address",orderId)
                : String(format:"/api/%@/orders/%d/shipping-address",ConnectionManager.version_of_order,orderId)
            
            case .getBuffetTickets(_,_,_,_,_):
                return String(format: "/api/%@/buffet-ticket", ConnectionManager.version_of_order)
            
            case .getDetailOfBuffetTicket(_,_,_,_,_,_):
                return String(format: "/api/%@/foods/menu-buffet", ConnectionManager.version_of_order)
            
            case .getFoodsOfBuffetTicket(_,_):
                return String(format: "/api/%@/buffet-ticket/foods", ConnectionManager.version_of_order)
            
            case .postCreateBuffetTicket(_,_,_,_,_,_,_):
                return String(format: "/api/%@/order-buffets/create", ConnectionManager.version_of_order)
            
            case .postUpdateBuffetTicket(_,_,let buffet):
                return String(format: "/api/%@/order-buffets/%d/update",ConnectionManager.version_of_order,buffet.id)
            
            case .postCancelBuffetTicket(let id):
                return String(format: "/api/%@/order-buffets/%d/cancel",ConnectionManager.version_of_order,id)
            
            case .postDiscountOrderItem(_,let orderId,_):
                return environmentMode == .offline
                ? String(format:"/api/order-details/%d/discount",orderId)
                : String(format:"/api/%@/order-details/%d/discount",ConnectionManager.version_of_order,orderId)

            case .getCouponList(_,_):
                return String(format:environmentMode == .offline ? "/api/coupons/available" : "/api/%@/coupons/available",ConnectionManager.version_of_dashboard)
            
            case .postApplyCoupon(_,let orderId,_):
                return environmentMode == .offline
                ? String(format:"/api/orders/%d/apply-coupon",orderId)
                : String(format:"/api/%@/orders/%d/apply-coupon",ConnectionManager.version_of_order,orderId)
            
            
            // MARK: API for chat
            case .postCreateGroupSuppport:
                return APIEndPoint.Chat.urlPostCreateGroupSuppport
            
            case .getMessageList(_,_,_,_):
                return APIEndPoint.Chat.urlGetMessageList
            
            case .getListMedia(_, _, _, _, _, _, _):
                return APIEndPoint.Chat.urlListMedia
            
            case .postRemovePrintedItem(_,_):
                return APIEndPoint.Name.urlPostRemovePrintedItem
            
            case .getClosedSessionHistory(_,_,_,_,_,_,_,_):
                return String(format:environmentMode == .offline ? "/api/order-session/end-working-sessions" : "/api/%@/order-session/end-working-sessions", ConnectionManager.version_of_order)
            
            // MARK: API for APP FOOD
            case .getChannelFoodOrder(_,_,_,_,_):
                return String(format:"/api/%@/channel-order-foods/list", ConnectionManager.version_of_app_food)
                
//            case .getOrderDetailOfChannelFood(_,_,_,_,_,_,_):
//                return String(format:"/api/%@/channel-order-foods/order-detail", ConnectionManager.version_of_app_food)
            
            case .getDetailOfChannelOrderFoodToken(let id):
                return String(format:"/api/%@/channel-order-food-token/%d/detail", ConnectionManager.version_of_app_food,id)
            
            case .postCreateTokenOfChannelFoodOrder(_,_,_,_,_,_,_,_):
                return String(format:"/api/%@/channel-order-food-token/create",ConnectionManager.version_of_app_food)
        
            case .postUpdateTokenOfChannelFoodOrder(let id,_,_,_,_):
                return String(format:"/api/%@/channel-order-food-token/update/%d",ConnectionManager.version_of_app_food,id)
                
            case .postChangeConnectOfChannelOrderFoodToken(let id,_):
                return String(format:"/api/%@/channel-order-food-token/change-connection/%d",ConnectionManager.version_of_app_food,id)
            
            case .getUserInforOfShopee(_):
                return String(format:"/mss/app-api/PartnerRNServer/GetUserInfoForRn")
            
            case .postGoFoodLoginRequest(_):
                return String(format:"/goid/login/request")
            
            case .postGoFoodToken(_,_):
                return String(format:"/goid/token")
            
            case .getOrderListOfFoodApp(_,_,_,_,_,_,_,_,let showLoading):
                let path = String(format:"/api/%@/channel-order-foods/orders",ConnectionManager.version_of_app_food)
                excludedAPIString = showLoading ? "" : path
                return path
        
            case .getOrderDetailOfFoodApp(_,_):
                let path = String(format:"/api/%@/channel-order-foods/order-detail",ConnectionManager.version_of_app_food)
                excludedAPIString = path
                return path
    
            case .postConfirmOrderOfFoodApp(let orderId):
                let path = String(format:"/api/%@/order-channel-foods/%d/confirm",ConnectionManager.version_of_order,orderId)
                excludedAPIString = path
                return path
            
            case .postBatchConfirmOrderOfFoodApp(_,_):
                let path = String(format:"/api/%@/channel-order-foods/orders/batch-confirm",ConnectionManager.version_of_app_food)
                excludedAPIString = path
                return path
            
            case .postBatchCancelOrderOfFoodApp(_,_):
                let path = String(format:"/api/%@/channel-order-foods/orders/cancel-print",ConnectionManager.version_of_app_food)
                excludedAPIString = path
                return path
            
            case .getCommissionOfFoodApp(_,_):
                return String(format: "/api/%@/branch-channel-food-commission-percent-maps/list",ConnectionManager.version_of_app_food)
            
            case .postSetCommissionForFoodApp(_,_,_,_,_,_,_):
                return String(format: "/api/%@/branch-channel-food-commission-percent-maps/setting",ConnectionManager.version_of_app_food)
            
            case .getOrderHistoryOfFoodApp(_,_,_,_,_,_,_):
                return String(format:"/api/%@/food-channel-histories",ConnectionManager.version_of_report)
            
            case .getOrderHistoryDetailOfFoodApp(let id):
                return String(format: "/api/%@/food-channel-histories/%d/detail",ConnectionManager.version_of_report,id)
            
            case .getDailyRevenueReportOfFoodApp(_,_,_,_,_,_,_):
                return String(format: "/api/%@/food-channel-sumary-datas",ConnectionManager.version_of_report)
            
            case .getRevenueSummaryReportOfFoodApp(_,_,_,_):
                return String(format: "/api/%@/food-channel-revenue-sumary",ConnectionManager.version_of_report)
            
            case .postRefreshOrderOfFoodApp(_,_,_,_):
                return String(format: "/api/%@/channel-order-foods/order/refresh",ConnectionManager.version_of_app_food)
            
            case .getBranchSynchronizationOfFoodApp(_,_):
                return String(format: "/api/%@/channel-order-foods/sync-branches",ConnectionManager.version_of_app_food)
        
            case .getBranchesOfChannelOrderFood(_,_,_):
                return String(format: "/api/%@/channel-order-foods/branches",ConnectionManager.version_of_app_food)
                
            case .getChannelOrderFoodTokenList(_,_,_,_):
                return String(format: "/api/%@/channel-order-food-token/list",ConnectionManager.version_of_app_food)
            
            case .getChannelOrderFoodInforList(_,_,_,_,_,_,_,_,_,_,_):
                return String(format: "/api/%@/channel-order-food-information/list",ConnectionManager.version_of_app_food)
                
            case .getAssignedBranchOfFoodApp(_,_):
                return String(format: "/api/%@/branch-channel-food-branch-maps/list-assigned",ConnectionManager.version_of_dashboard)
            
            case .postAssignBrachOfFoodApp(_,_,_):
                return String(format: "/api/%@/branch-channel-food-branch-maps/assign-multiple",ConnectionManager.version_of_dashboard)
            
            case .getReprintItemsOfFoodApp(let channel_order_id):
                return String(format: "/api/%@/channel-order-foods/orders/print-order-detail/%d",ConnectionManager.version_of_app_food,channel_order_id)
            
            case .postCancelItemOfFoodApp(_,_):
                return String(format: "/api/%@/channel-order-foods/orders/handle-cancel-v2",ConnectionManager.version_of_app_food)
                
            // MARK: API for TECHRESSHOP
            case .getTechresShopDeviceList:
                let version = permissionUtils.GPBH_1 ? ConnectionManager.version_of_small_order : ConnectionManager.version_of_order
                return String(format: "/api/%@/restaurant-order-device-requests/list-product",version)
            
            case .postCreateTechresShopOrder(_,_):
                let version = permissionUtils.GPBH_1 ? ConnectionManager.version_of_small_order : ConnectionManager.version_of_order
                return String(format: "/api/%@/restaurant-order-device-requests/create-product-order",version)
            
            case .getTechresShopOrder(_,_):
                let version = permissionUtils.GPBH_1 ? ConnectionManager.version_of_small_order : ConnectionManager.version_of_order
                return String(format: "/api/%@/restaurant-order-device-requests/list-product-order", version)
            
            case .getTechresShopOrderDetail(let orderId):
                let version = permissionUtils.GPBH_1 ? ConnectionManager.version_of_small_order : ConnectionManager.version_of_order
                return String(format: "/api/%@/restaurant-order-device-requests/%d/detail-product-order", version,orderId)
            
           
            //==================================================================================================================================================================
            
            case .getPartnerInvoiceConnection:
                return String(format: "/api/%@/restaurant-partner-invoice/parner-connect",ConnectionManager.version_of_dashboard)
            
            
            case .getPartnerInvoiceConnectionDetail(_):
                return String(format: "/api/%@/restaurant-partner-invoice/partner-connect/detail",ConnectionManager.version_of_dashboard)
            
            
            case .postChangeStatusPartnerInvoiceConnection(let id,_):
                return String(format: "/api/%@/restaurant-partner-invoice/%d/change-status",ConnectionManager.version_of_dashboard,id)
            
            case .postUpdatePartnerInvoiceConnection(let invoice):
                return String(format: "/api/%@/restaurant-partner-invoice/partner-connect/%d/update",
                    ConnectionManager.version_of_dashboard,
                    invoice.partner_electronic_invoice_type.rawValue
                )
            
            case .postCreatePartnerInvoiceConnection(_,let invoice):
                return String(format: "/api/%@/restaurant-partner-invoice/create",ConnectionManager.version_of_dashboard)
            
            case .getEInvoiceList(_,_,_,_,_,_,_,_,_):
                return String(format: APIEndPoint.Name.urlGetEInvoiceList)
            
            case .postAssignBranchForEInvoicePartner(_):
                return String(format: "/api/%@/restaurant-partner-invoice/assign-branch",ConnectionManager.version_of_dashboard)
            
            case .postUnassignBranchForEInvoicePartner(_):
                return String(format: "/api/%@/restaurant-partner-invoice/unassign-branch",ConnectionManager.version_of_dashboard)
        }
    }
}
