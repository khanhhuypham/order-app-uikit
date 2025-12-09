//
//  PaymentRebuildViewController + extension + socketIO.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 25/10/2023.
//

import UIKit

extension PaymentRebuildViewController {
    
    func setupSocketIO() {
        // socket io here
        let namespace = String(format:environmentMode == .offline ? "/local" : "/restaurants_%d_branches_%d", Constants.brand.id, Constants.branch.id)
        real_time_url = String(format: "restaurants/%d/branches/%d/orders/%d",Constants.restaurant_id, Constants.branch.id,order.id)
        SocketIOManager.shared().initSocketInstance(namespace)

        SocketIOManager.shared().socketOrderRealTime?.on("connect") {data, ack in
          
            SocketIOManager.shared().socketOrderRealTime!.emit("join_room", self.real_time_url)
            
            SocketIOManager.shared().socketOrderRealTime!.on(self.real_time_url) {data, ack in
                self.getOrder()
            }
        }
    }
    
}
