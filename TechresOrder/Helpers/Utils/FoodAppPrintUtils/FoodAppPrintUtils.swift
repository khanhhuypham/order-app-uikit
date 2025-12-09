//
//  FoodAppPrintUtils.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 22/08/2024.
//

import UIKit
import RxSwift
import ObjectMapper
import AVFoundation

class FoodAppPrintUtils:NSObject {
    var player: AVAudioPlayer?
    
    let rxbag = DisposeBag()
    
    var foodApptTimer: Timer?
    var refreshFoodApptTimer: Timer?
    
    var isProcessing:Bool = false
    
    static let shared: FoodAppPrintUtils = {
        let foodAppPrintUtils = FoodAppPrintUtils()
        return foodAppPrintUtils
    }()
    
    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self,selector:#selector(printFail(_:)),name: NSNotification.Name(PRINTER_NOTIFI.ERROR_FROM_PRINT_FUNCTION_OF_FOOD_APP),object: nil)
    }
    
    deinit{
        foodApptTimer?.invalidate()
        foodApptTimer = nil
        
        refreshFoodApptTimer?.invalidate()
        refreshFoodApptTimer = nil
        
    
        NotificationCenter.default.removeObserver(self)
        
    }
    @objc func printFail(_ notification: Notification){
        isProcessing = false
    }

}


extension FoodAppPrintUtils {
    
    func performPrintOrderForFoodAppOnBackground(){
 
        if permissionUtils.allowScanOrderFoodApp{
            
            foodApptTimer?.invalidate()
            foodApptTimer = nil
            isProcessing = false
            foodApptTimer = Timer.scheduledTimer(withTimeInterval:6, repeats: true) { [weak self] _ in
                if let _ = Utils.getTopMostViewController(){
                    if (self?.isProcessing ?? false) == false && Constants.isLogin{
                        self?.getOrderListOfFoodApp()
                    }
                }
            }
                
            refreshFoodApptTimer?.invalidate()
            refreshFoodApptTimer = nil
            refreshFoodApptTimer = Timer.scheduledTimer(withTimeInterval:60*30, repeats: true) { [weak self] _ in
                self?.getConformedOrderListOfFoodApp()
            }
            

        }
    }
    
    
    func stopPrintOrderForFoodAppOnBackground(){
        foodApptTimer?.invalidate()
        foodApptTimer = nil
        
        refreshFoodApptTimer?.invalidate()
        refreshFoodApptTimer = nil
        isProcessing = false
        
    }
    
  
}

//MARK: call api
extension FoodAppPrintUtils {
    
    private func getOrderListOfFoodApp(){
        appServiceProvider.rx.request(.getOrderListOfFoodApp(
            isAppFood: ALL,
            branch_id: Constants.branch.id,
            restaurant_id: Constants.restaurant_id,
            area_id: ALL,
            is_have_restaurant_order: DEACTIVE,
            channel_order_food_id: ALL,
            restaurant_brand_id: Constants.brand.id,
            customer_order_status: "0,6,7,8"
        ))
        .filterSuccessfulStatusCodes()
        .mapJSON().asObservable()
        .showAPIErrorToast()
        .mapObject(type: APIResponse.self).subscribe(onNext: {[weak self] response in
            guard let self = self else { return }
            self.isProcessing = true
            defer { self.isProcessing = false } // ✅ ensures reset even on early returns

            guard let res = Mapper<FoodAppOrderResponse>().map(JSONObject: response.data) else { return }
            let orders = Array(res.list.filter { $0.is_app_food == ACTIVE }.prefix(10))
            guard !orders.isEmpty else { return }
            guard let topVc = Utils.getTopMostViewController() else {
                return
            }
            
            if res.is_new_order_app_food == ACTIVE{
                playSound()
            }

            processOrders(orders, presenter: topVc)
            
            if let topVc = Utils.getTabbarViewController(), !res.errors.isEmpty{
          
                FoodAppPrintUtils.presentErrorMessage(
                    content: res.errors.map{$0["token_name"] ?? ""}.joined(separator: ", "),
                    viewController: topVc
                )
            }
    
        }).disposed(by: rxbag)
    }
    
    
    private func processOrders(_ orders: [FoodAppOrder], presenter: UIViewController) {
        var uncancelledOrders = orders.filter { $0.is_cancel_order == DEACTIVE }
        let cancelOrders = orders.filter { $0.is_cancel_order == ACTIVE }

        // Optional driver name filtering
        if Constants.branch.setting.is_enable_confirm_when_driver == ACTIVE {
            uncancelledOrders = uncancelledOrders.filter{ !$0.driver_name.isEmpty }
        }

        if !uncancelledOrders.isEmpty {
            confirmOrdersOfFoodApp(ids: uncancelledOrders.map { $0.id })
        }

        if !cancelOrders.isEmpty {
            cancelOrdersOfFoodApp(ids: cancelOrders.map { $0.id })
        }

        let allOrders = uncancelledOrders + cancelOrders
        
        guard !allOrders.isEmpty else { return }

        PrinterUtils.shared.PrintFoodAppItems(
            presenter: presenter,
            isCustomerOrder: true,
            printers: Constants.printers.filter{
                [.cashier_of_food_app, .stamp_of_food_app].contains($0.type)
            },
            orders: allOrders,
            printMode: .printForeground,
            completetHandler: { [weak self] in
                self?.isProcessing = false
            }
        )
    }
  
    private func confirmOrdersOfFoodApp(ids:[Int]){
        appServiceProvider.rx.request(.postBatchConfirmOrderOfFoodApp(branch_id: Constants.branch.id, ids: ids))
        .filterSuccessfulStatusCodes()
        .mapJSON().asObservable()
        .showAPIErrorToast()
        .mapObject(type: APIResponse.self).subscribe(onNext: { (response) in
     
            if(response.code == RRHTTPStatusCode.ok.rawValue){}
         
        }).disposed(by: rxbag)
        
    }
    	
    private func cancelOrdersOfFoodApp(ids:[Int]){
        appServiceProvider.rx.request(.postBatchCancelOrderOfFoodApp(branch_id: Constants.branch.id, ids: ids))
        .filterSuccessfulStatusCodes()
        .mapJSON().asObservable()
        .showAPIErrorToast()
        .mapObject(type: APIResponse.self).subscribe(onNext: { (response) in
     
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                
            }
         
        }).disposed(by: rxbag)
        
    }
    
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "app_food_noti", withExtension: "caf") else { return }

            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)

                /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.caf.rawValue)

                /* iOS 10 and earlier require the following line:
                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

                guard let player = player else { return }

                player.play()

            } catch let error {
                print(error.localizedDescription)
            }
        
        
    }

}



//MARK: call api refresh order
extension FoodAppPrintUtils {
    
    func getConformedOrderListOfFoodApp(){
        appServiceProvider.rx.request(.getOrderListOfFoodApp(
            isAppFood: -1,
            branch_id: Constants.branch.id,
            restaurant_id: Constants.restaurant_id,
            area_id: ALL,
            is_have_restaurant_order: ACTIVE,
            channel_order_food_id: ALL,
            restaurant_brand_id: Constants.brand.id,
            customer_order_status: "0,8")
        )
        .filterSuccessfulStatusCodes()
        .mapJSON().asObservable()
        .showAPIErrorToast()
        .mapObject(type: APIResponse.self).subscribe(onNext: { (response) in

            if let res = Mapper<FoodAppOrderResponse>().map(JSONObject: response.data){
                
                self.postRefreshOrderOfFoodApp(channelOrders:res.list)
            }
        
        }).disposed(by: rxbag)
    }
    
    private func postRefreshOrderOfFoodApp(channelOrders:[FoodAppOrder]){
        
        var items:[[String:Any]] = []
        
        for order in channelOrders{
            items.append([
                "id":order.id,
                "channel_order_food_id": order.channel_order_food_id,
                "channel_order_code": order.channel_order_code,
                "channel_order_id": order.channel_order_id
            ])
        }
        
        appServiceProvider.rx.request(.postRefreshOrderOfFoodApp(
            restaurant_id:Constants.restaurant_id,
            restaurant_brand_id:Constants.brand.id,
            branch_id:Constants.branch.id,
            channel_orders:items
        ))
        .filterSuccessfulStatusCodes()
        .mapJSON().asObservable()
        .showAPIErrorToast()
        .mapObject(type: APIResponse.self).subscribe(onNext: { (response) in
            
            
            
        }).disposed(by: rxbag)
    }
    

}
