//
//  BaseURLConnectionManager.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 15/8/25.
//

import Foundation

extension ConnectionManager {
    
    var baseURL: URL {
        
        switch self {
            
            //MARK: Authentication API
            case .loginUsingCode(_,_,_,_):
                return URL(string: onlineBaseUrl)!
            
            case .getCodeAuthenticationList:
                return URL(string: onlineBaseUrl)!
            
            case .postCreateAuthenticationCode(_,_):
                return URL(string: onlineBaseUrl)!
            
            case .postChangeStatusOfAuthenticationCode(_):
                return URL(string: onlineBaseUrl)!
            
            case .forgotPassword(_):
                return URL(string: onlineBaseUrl)!
            
            case .verifyOTP(_,_,_):
                return URL(string: onlineBaseUrl)!
            
            case .verifyPassword(_,_,_):
                return URL(string: onlineBaseUrl)!
            
            case .changePassword(_, _,_,_):
                return URL(string: onlineBaseUrl)!
            
            //MARK: =================
            case .postGoFoodLoginRequest,.postGoFoodToken:
                return URL(string: "https://goid.gojekapi.com")!
            
            case .getUserInforOfShopee(_):
                return URL(string: "https://app.partner.shopee.vn")!
            
            //MARK: API REPORT ========
            case .report_revenue_by_time(_, _, _, _, _, _):
                return URL(string: onlineBaseUrl)!
                
            case .report_revenue_activities_in_day_by_branch(_, _, _, _, _, _):
                return URL(string: onlineBaseUrl)!
                
            case .report_revenue_fee_profit(_,_,_,_,_,_,_):
                return URL(string: onlineBaseUrl)!
                
            case .report_revenue_by_category(_, _, _, _, _, _):
                return URL(string: onlineBaseUrl)!
                
            case .report_revenue_by_employee(_, _, _, _, _, _, _):
                return URL(string: onlineBaseUrl)!
                
            case .report_business_analytics(_, _, _, _, _, _, _, _, _, _, _, _, _):
                return URL(string: onlineBaseUrl)!
           
            case .report_revenue_by_all_employee(_, _, _, _, _, _):
                return URL(string: onlineBaseUrl)!
                
            case .report_food(_,_,_,_,_,_,_,_,_,_,_,_,_):
                return URL(string: onlineBaseUrl)!
                
            case .report_cancel_food(_,_,_,_,_,_,_,_,_,_,_,_):
                return URL(string: onlineBaseUrl)!
                
            case .report_gifted_food(_,_,_,_,_,_,_,_,_,_,_,_):
                return URL(string: onlineBaseUrl)!
                
            case .report_discount(_,_,_,_,_,_):
                return URL(string: onlineBaseUrl)!
                
            case .report_VAT(_,_,_,_,_,_):
                return URL(string: onlineBaseUrl)!
            
            case .report_area_revenue(_,_,_,_,_,_):
                return URL(string: onlineBaseUrl)!
                
            case .report_table_revenue(_,_,_,_,_,_,_):
                return URL(string: onlineBaseUrl)!
            
            //MARK: API REPORT SEEMT
            case .getReportOrderRestaurantDiscountFromOrder(_, _, _, _, _, _):
                return URL(string: onlineBaseUrl)!
                
            case .getOrderReportFoodCancel(_, _, _, _, _, _, _):
                return URL(string: onlineBaseUrl)!
                
            case .getOrderReportFoodGift(_, _, _, _, _, _, _, _):
                return URL(string: onlineBaseUrl)!
                
            case .getOrderReportTakeAwayFood(_, _, _, _, _, _, _, _, _, _, _, _):
                return URL(string: onlineBaseUrl)!
                
            case .getReportRevenueGenral(_, _, _, _, _, _):
                return URL(string: onlineBaseUrl)!
                
            case .getReportRevenueArea(_, _, _, _, _, _):
                return URL(string: onlineBaseUrl)!
                
            case .getReportSurcharge(_, _, _, _, _, _):
                return URL(string: onlineBaseUrl)!
                
            case .getReportRevenueProfitFood(_, _, _, _, _, _, _, _, _):
                return URL(string: onlineBaseUrl)!
                
            case .getRestaurantOtherFoodReport(_, _, _, _, _, _, _, _, _):
                return URL(string: onlineBaseUrl)!
                
            case .getRestaurantVATReport(_, _, _, _, _, _):
                return URL(string: onlineBaseUrl)!
                                
            case .getRenueByEmployeeReport(_, _, _, _, _, _):
                return URL(string: onlineBaseUrl)!
            
            case .getDailyRevenueReportOfFoodApp(_,_,_,_,_,_,_):
                return URL(string: onlineBaseUrl)!
            
            case .getRevenueSummaryReportOfFoodApp(_,_,_,_):
                return URL(string: onlineBaseUrl)!
            
            // MARK: API for APP FOOD
            case .getChannelFoodOrder(_,_,_,_,_):
                return URL(string: onlineBaseUrl)!
                
//            case .getOrderDetailOfChannelFood(_,_,_,_,_,_,_):
//                return URL(string: onlineBaseUrl)!
            
            case .getDetailOfChannelOrderFoodToken(_):
                return URL(string: onlineBaseUrl)!
            
            case .postCreateTokenOfChannelFoodOrder(_,_,_,_,_,_,_,_):
                return URL(string: onlineBaseUrl)!
        
            case .postUpdateTokenOfChannelFoodOrder(_,_,_,_,_):
                return URL(string: onlineBaseUrl)!
                
            case .postChangeConnectOfChannelOrderFoodToken(_,_):
                return URL(string: onlineBaseUrl)!
            
            case .getOrderListOfFoodApp(_,_,_,_,_,_,_,_,_):
                return URL(string: onlineBaseUrl)!
        
            case .getOrderDetailOfFoodApp(_,_):
                return URL(string: onlineBaseUrl)!
    
            case .postConfirmOrderOfFoodApp(_):
                return URL(string: onlineBaseUrl)!
            
            case .postBatchConfirmOrderOfFoodApp(_,_):
                return URL(string: onlineBaseUrl)!
            
            case .postBatchCancelOrderOfFoodApp(_,_):
                return URL(string: onlineBaseUrl)!
            
            case .getCommissionOfFoodApp(_,_):
                return URL(string: onlineBaseUrl)!
            
            case .postSetCommissionForFoodApp(_,_,_,_,_,_,_):
                return URL(string: onlineBaseUrl)!
            
            case .getOrderHistoryOfFoodApp(_,_,_,_,_,_,_):
                return URL(string: onlineBaseUrl)!
            
            case .getOrderHistoryDetailOfFoodApp(_):
                return URL(string: onlineBaseUrl)!
                        
            case .postRefreshOrderOfFoodApp(_,_,_,_):
                return URL(string: onlineBaseUrl)!
            
            case .getBranchSynchronizationOfFoodApp(_,_):
                return URL(string: onlineBaseUrl)!
        
            case .getBranchesOfChannelOrderFood(_,_,_):
                return URL(string: onlineBaseUrl)!
                
            case .getChannelOrderFoodTokenList(_,_,_,_):
                return URL(string: onlineBaseUrl)!
            
            case .getChannelOrderFoodInforList(_,_,_,_,_,_,_,_,_,_,_):
                return URL(string: onlineBaseUrl)!
                
            case .getAssignedBranchOfFoodApp(_,_):
                return URL(string: onlineBaseUrl)!
            
            case .postAssignBrachOfFoodApp(_,_,_):
                return URL(string: onlineBaseUrl)!
            
            // MARK: API for TECHRESSHOP
            case .getTechresShopDeviceList:
                return URL(string: onlineBaseUrl)!
            
            case .postCreateTechresShopOrder(_,_):
                return URL(string: onlineBaseUrl)!
            
            case .getTechresShopOrder(_,_):
                return URL(string: onlineBaseUrl)!
            
            case .getTechresShopOrderDetail(_):
                return URL(string: onlineBaseUrl)!
            
            case .getAlolineCustomer(_,_):
                return URL(string: onlineBaseUrl)!
            
            
            //MARK: working session
            case .openSession(_, _):
                return URL(string: onlineBaseUrl)!
                
            case .workingSessions(_,_):
                return URL(string: onlineBaseUrl)!
                
            case .checkWorkingSessions:
                return URL(string: onlineBaseUrl)!
            
            case .workingSessionValue:
                return URL(string: onlineBaseUrl)!
                
            case .closeWorkingSession(_):
                return URL(string: onlineBaseUrl)!
            
            case .assignWorkingSession(_, _):
                return URL(string: onlineBaseUrl)!
            //===================================================
            case .ordersHistory(_,_,_,_, _,_,_,_):
                return URL(string: onlineBaseUrl)!
            
            case .getTotalAmountOfOrders(_,_,_,_,_,_):
                return URL(string: onlineBaseUrl)!
            
            case .profile(_,_):
                return URL(string: onlineBaseUrl)!
            
            case .updateProfile(_):
                return URL(string: onlineBaseUrl)!
            

            default:
                return URL(string: environmentMode.baseUrl)!
        }
        
    }
    
}
