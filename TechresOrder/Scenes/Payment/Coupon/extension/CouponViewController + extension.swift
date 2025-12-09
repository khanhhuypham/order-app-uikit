//
//  CouponViewController + extension.swift
//  TechresOrder
//
//  Created by Pham Khanh Huy on 24/10/25.
//
import ObjectMapper
extension CouponViewController:UITableViewDelegate,UITableViewDataSource{

    
    func registerCell(){
        let cell = UINib(nibName: "CouponTableViewCell", bundle: .main)
        tableView.register(cell, forCellReuseIdentifier: "CouponTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.list.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CouponTableViewCell") as? CouponTableViewCell else{
            return UITableViewCell()
        }
        cell.viewModel = viewModel
        cell.data = viewModel.list.value[indexPath.row]
        return cell
    }

}

extension CouponViewController{

    func getCouponList(){
        appServiceProvider.rx.request(.getCouponList(brand_id: Constants.brand.id, branch_id:  Constants.branch.id))
        .filterSuccessfulStatusCodes()
        .mapJSON().asObservable()
        .showAPIErrorToast()
        .mapObject(type: APIResponse.self).subscribe(onNext: {[weak self](response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if var list = Mapper<Coupon>().mapArray(JSONObject: response.data) {
                    
                    for (i,value) in list.enumerated(){
                        list[i].select = value.id == self?.couponId
                    }
                    self?.view_no_data.isHidden = !list.isEmpty
                    self?.viewModel.list.accept(list)
                    self?.tableView.reloadData()
                }
            }else {
                self?.showErrorMessage(content: response.message ?? "")
            }
        }).disposed(by: rxbag)
    }
    
    
    func applyCoupon(orderId:Int,couponId:Int){
        appServiceProvider.rx.request(.postApplyCoupon(branchId: Constants.branch.id, orderId: orderId,couponId: couponId))
        .filterSuccessfulStatusCodes()
        .mapJSON().asObservable()
        .showAPIErrorToast()
        .mapObject(type: APIResponse.self).subscribe(onNext: {[weak self](response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
               
                self?.dismiss(animated: true,completion: {
                    self?.completion?()
                    self?.showSuccessMessage(content: "Áp dụng thành công")
                })
                
            }else {
                self?.showErrorMessage(content: response.message ?? "")
            }
        }).disposed(by: rxbag)
    }
    
    
}
