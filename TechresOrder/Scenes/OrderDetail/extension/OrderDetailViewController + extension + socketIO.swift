//
//  OrderDetailRebuildViewController + extension + socketIO.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 01/09/2023.
//

import UIKit

extension OrderDetailViewController{

    
    func setupSocketIO() {
        // socket io here
        let namespace = String(format:environmentMode == .offline ? "/local" : "/restaurants_%d_branches_%d", Constants.brand.id, Constants.branch.id)
    
        let real_time_url = String(format: "restaurants/%d/branches/%d/orders/%d",Constants.restaurant_id,Constants.branch.id, viewModel.order.value.id)
       
        SocketIOManager.shared().initSocketInstance(namespace)
        SocketIOManager.shared().establishConnection()
        
        SocketIOManager.shared().socketOrderRealTime?.on("connect") {data, ack in
           
            SocketIOManager.shared().socketOrderRealTime!.emit("join_room", real_time_url)
            
            SocketIOManager.shared().socketOrderRealTime!.on(real_time_url) {data, ack in
                self.getOrder()
            }
        }
    }
    
}
