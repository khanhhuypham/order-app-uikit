//
//  FoodAppOrderViewController + extension + api.swift
//  TechresOrder
//
//  Created by Pham Khanh Huy on 19/11/25.
//

import ObjectMapper

extension FoodAppOrderViewController {

        
    func getOrderListOfFoodApp(){
        var channelId = viewModel.APIParameter.value.partner.value
        if  viewModel.APIParameter.value.confirmation == 0{
            channelId = -1
        }
        
        appServiceProvider.rx.request(.getOrderListOfFoodApp(
            isAppFood: 1,
            branch_id: Constants.branch.id,
            restaurant_id: Constants.restaurant_id,
            area_id: ALL,
            is_have_restaurant_order: viewModel.APIParameter.value.confirmation,
            channel_order_food_id: channelId,
            restaurant_brand_id: Constants.brand.id,
            customer_order_status: "0,6,7,8",
            showLoading:true
        ))
        .filterSuccessfulStatusCodes()
        .mapJSON().asObservable()
        .showAPIErrorToast()
        .mapObject(type: APIResponse.self).subscribe(onNext: {[weak self] response in
            guard let self = self else { return }
            guard let res = Mapper<FoodAppOrderResponse>().map(JSONObject: response.data) else { return }
            
            self.viewModel.array.accept(res.list)
            self.tableView.reloadData()
            self.view_nodata_order.isHidden = !res.list.isEmpty
    
        }).disposed(by: rxbag)
    }


}
