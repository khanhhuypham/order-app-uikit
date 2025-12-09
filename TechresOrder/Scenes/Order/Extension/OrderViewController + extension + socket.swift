//
//  OrderRebuildViewController + extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 16/01/2024.
//

import UIKit
import ObjectMapper

extension OrderViewController{
    func setupSocketIO(){
        // socket io here
        let namespace = String(format:environmentMode == .offline ? "/local" : "/restaurants_%d_branches_%d", Constants.brand.id, Constants.branch.id)
        real_time_url = String(format: "restaurants/%d/branches/%d/orders", Constants.restaurant_id, Constants.branch.id)
        SocketIOManager.shared().initSocketInstance(namespace)
        SocketIOManager.shared().establishConnection()
        
        SocketIOManager.shared().socketOrderRealTime?.on("connect") {data, ack in
            
            SocketIOManager.shared().socketOrderRealTime!.emit("join_room", self.real_time_url)
            
            SocketIOManager.shared().socketOrderRealTime!.on(self.real_time_url) {data, ack in
                self.fetchOrders()
//                var order = Mapper<Order>().map(JSONObject: data[0])!
//                
//                if environmentMode == .offline {
//
//                    if let json = data.first as? [String: Any],
//                       let offlineOrder = Mapper<OfflineRealTimeOrder>().map(JSON: json) {
//                        if let object_data = offlineOrder.object_data {
//                            order = object_data
//                        }
//                    }
//                
//                }
//                
//    
//                
//                if(order.order_status == ORDER_STATUS_WAITING_MERGED){
//                    self.fetchOrders()
//                }else{
//                    self.updateOrderInArray(order: order)
//                }
                
            }
        }
        
    }
    
    func updateOrderInArray(order:Order) {
        var list_orders = self.viewModel.dataArray.value
        
        if let foundOrder = list_orders.first(where: {$0.id == 0}){
            dLog(foundOrder)
        }
        
        if list_orders.first(where: { $0.id == order.id }) != nil {
            //do something
            if(list_orders.count > 0 ){
                //phần tử nào hiện đã được thanh toán thì xoá khỏi list_order (danh sách hiển thị local)
                list_orders.removeAll { $0.order_status == ORDER_STATUS_COMPLETE }
                for i in 0..<list_orders.count {
                    
                    dLog(list_orders[i].id == order.id)
                    
                    if(list_orders[i].id == order.id){
                       
                        switch order.order_status {
                            case ORDER_STATUS_OPENING:
                                list_orders.remove(at: i)
                                list_orders.insert(order, at: i)
                                break
                            case ORDER_STATUS_REQUEST_PAYMENT:
                                list_orders.remove(at: i)
                                list_orders.insert(order, at: 0)//sort order to top list
                                break
                            case ORDER_STATUS_WAITING_WAITING_COMPLETE:
                                list_orders.remove(at: i)
                                list_orders.insert(order, at: 0)//sort order to top list
                                break
                            case ORDER_STATUS_COMPLETE:
                                list_orders[i].order_status = ORDER_STATUS_COMPLETE
                                break
                            case ORDER_STATUS_WAITING_MERGED:
                                dLog(i)
                                list_orders.remove(at: i)//remove order done out array
                                break
                            default:
                                list_orders.remove(at: i)
                                list_orders.insert(order, at: i)
                                
                        }
                    }
                }
            }
        }else{
            list_orders.insert(order, at: list_orders.count)
        }
        
        self.viewModel.dataArray.accept(list_orders)

    }
    
}
