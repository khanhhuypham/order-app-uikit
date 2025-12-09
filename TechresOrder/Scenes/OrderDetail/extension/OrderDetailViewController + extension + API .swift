//
//  OrderDetailRebuildViewController + extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 31/08/2023.
//

import UIKit
import ObjectMapper
import RxSwift
import JonAlert
extension OrderDetailViewController{
    //MARK: API lấy thông tin chi tiết đơn hàng
    func getOrder(pay:Bool = false){
        viewModel.getOrder().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
        
                if var order = Mapper<OrderDetail>().map(JSONObject: response.data){
                    order.is_take_away = self.order.is_take_away
                    order.order_details.removeAll(where: {($0.category_type == .drink || $0.category_type == .other) && $0.quantity == 0})
                    self.viewModel.order.accept(order)
                    self.mapData(order: order)
                    
                    self.view_action.isHidden = order.status == ORDER_STATUS_COMPLETE || order.status == ORDER_STATUS_WAITING_WAITING_COMPLETE ? true : false
                    
                    //Nếu bàn booking thì sẽ lấy thêm các món ăn
                    if (order.booking_status == STATUS_BOOKING_SET_UP){
                        self.getFoodBookingStatus()
                    }
                    
                    if permissionUtils.GPBH_2 || permissionUtils.GPBH_1{
                        
                        permissionUtils.GPBH_2_o_1 
                        ? self.getOrderNeedToPrintFor2o1()
                        : self.getFoodsNeedPrint()
                      
                    }else if permissionUtils.GPBH_3 && ManageCacheObject.getPaymentMethod().is_enable_send_to_kitchen_request == ACTIVE {
                        self.getItemNeedToSendToKitchen()
                    }
                    
                    if pay{
                        self.handlePayment()
                    }
                    
                }
            }
            
        }).disposed(by: rxbag)
    }
    
    //MARK: API lấy thông tin trạng thái booking
    func getFoodBookingStatus(){
        viewModel.getFoodBookingStatus().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if var bookingItems = Mapper<OrderItem>().mapArray(JSONObject: response.data){
                    
                    bookingItems.enumerated().forEach{(i,_) in
                        bookingItems[i].is_booking_item = ACTIVE
                    }
                    
                    var order = self.viewModel.order.value
                    order.order_details = bookingItems + order.order_details 
                    self.viewModel.order.accept(order)
                    
                }
            }
        }).disposed(by: rxbag)
        
    }
    

    //MARK: API huỷ món ăn
    public func handleCancelFood(item:OrderItem) {
    
        switch item.status {
            case .done:
                
                switch item.category_type {
                    case .buffet_ticket:
                        permissionUtils.BuffetManager
                        ? presentModalCancelFoodViewController(orderItem: item)
                        : showWarningMessage(content: "Bạn chưa được cấp quyền sử dụng tính năng này vui lòng liên hệ quản lý")
                     
                    
                    default:
                        Utils.checkRoleCancelFoodCompleted(permission: ManageCacheObject.getCurrentUser().permissions)
                        ? presentModalCancelFoodViewController(orderItem: item)
                        : showWarningMessage(content: "Bạn chưa được cấp quyền sử dụng tính năng này vui lòng liên hệ quản lý")
                }
            

            default:
                presentModalCancelFoodViewController(orderItem: item)
        }

    }
    
    
    //MARK: API thêm ghi chú cho món ăn
    func addNoteToFood(orderDetailId:Int,note:String){
        viewModel.addNoteToOrderDetail(orderDetailId: orderDetailId, note: note).subscribe(onNext: {[weak self](response) in
            guard let self = self else {return }
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                self.showSuccessMessage(content: "Cập nhật ghi chú thành công",duration: 1.5)
                
                var order = self.viewModel.order.value
                
                if let index = order.order_details.firstIndex(where: { $0.id == orderDetailId}) {
                    order.order_details[index].note = note
                    self.viewModel.order.accept(order)
                }
                
            }else{
                JonAlert.showError(message:response.message ?? "", duration: 3.0)
                dLog(response.message ?? "")
            }
        }).disposed(by: rxbag)
    }
    
        
    //MARK: API Huỷ món
    func cancelFood(item:OrderItem){
        viewModel.cancelFood(orderItem: item).subscribe(onNext: {[weak self](response) in
            guard let self = self else {return }
            
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                var order = self.viewModel.order.value
                if let index = order.order_details.firstIndex(where: { $0.id == item.id }) {
                    order.order_details[index].status = .cancel
                    self.viewModel.order.accept(order)
                }
                
            }else{
                self.showErrorMessage(content: response.message ?? "")
            }
        }).disposed(by: rxbag)
        
    }
    
    //MARK: API cancel buffet ticket
    public func cancelBuffetTicket(item:OrderItem) {
        viewModel.cancelBuffetTicket(orderItem: item).subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){

            }else{
                JonAlert.showError(message:response.message ?? "", duration: 3.0)
            }
        }).disposed(by: rxbag)
    }
    
    
    //MARK: API Huỷ món có kèm phụ thu
    func cancelExtraCharge(item:OrderItem){
        viewModel.cancelExtraCharge(orderItem: item).subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){

            }else{
                JonAlert.showError(message:response.message ?? "", duration: 3.0)
            }
        }).disposed(by: rxbag)
        
    }

    
    
    func updateFoodsToOrder(foods:[FoodUpdate]){
        appServiceProvider.rx.request(.updateFoods(
            branch_id: viewModel.branch_id.value,
            order_id: viewModel.order.value.id,
            foods: foods
        ))
       .filterSuccessfulStatusCodes()
       .mapJSON().asObservable()
       .showAPIErrorToast()
       .mapObject(type: APIResponse.self).subscribe(onNext: {[weak self](response) in
            guard let self = self else {return}
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                self.viewModel.foodsNeedToUpdate.accept([])
                self.lbl_number_need_to_update.text = "0"
                
//                var order = self.viewModel.order.value
//                for food in foods {
//                    if let i = order.order_details.firstIndex(where: {$0.id == food.order_detail_id}){
//                        order.order_details[i].quantity = food.quantity
//                    }
//                }
//                viewModel.order.accept(order)
                
            }else{
                JonAlert.showError(message: response.message ?? "", duration: 3.0)
            }
        }).disposed(by: rxbag)
        
    }
    
        
    
    func pauseService(orderDetailId:Int){
        viewModel.pauseService(orderDetailId: orderDetailId).subscribe(onNext: { [weak self] (response) in
            guard let self = self else {return}
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                self.getOrder()
            }else{
                JonAlert.showError(message: response.message ?? "", duration: 2.0)
            }
        }).disposed(by: rxbag)
    }
    

    
    func discountOrderItem(item:OrderItem) {
        //CALL API COMPLETED ORDER
        viewModel.discountOrderItem(item: item).subscribe(onNext: { [weak self] (response) in
            guard let self = self else {return}
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                JonAlert.showSuccess(message: "Giảm giá thành công", duration: 2.0)

                
                var order = self.viewModel.order.value
                
                if let index = order.order_details.firstIndex(where: { $0.id == item.id}) {
                    order.order_details[index].discount_percent = item.discount_percent
                    self.viewModel.order.accept(order)
                }
                
            }else{
                JonAlert.showError(message: response.message ?? "", duration: 2.0)
            }
        }).disposed(by: rxbag)
    }
    
    func assignCustomerToOrder(orderId:Int,customer:Customer){
        viewModel.assignCustomerToOrder(orderId: orderId, customer: customer).subscribe(onNext: {[weak self] (response) in
            guard let self = self else {return}
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                self.getOrder()
            }else {
                self.showErrorMessage(content: response.message ?? "")
            }
        }).disposed(by: rxbag)
    }
    
    
    func unassignCustomerFromOrder(orderId:Int) {
        //CALL API COMPLETED ORDER
        viewModel.unassignCustomerFromOrder(orderId: orderId).subscribe(onNext: { [weak self] (response) in
            guard let self = self else {return}
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                self.getOrder()
            }else{
                JonAlert.showError(message: response.message ?? "", duration: 2.0)
            }
        }).disposed(by: rxbag)
    }

    
    func updateCustomer(orderId:Int,customer:Customer) {
        //CALL API COMPLETED ORDER
        viewModel.updateCustomer(orderId: orderId, customer: customer).subscribe(onNext: { [weak self] (response) in
            guard let self = self else {return}
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                self.getOrder()
            }else{
                JonAlert.showError(message: response.message ?? "", duration: 2.0)
            }
        }).disposed(by: rxbag)
    }
    
    
   
}
