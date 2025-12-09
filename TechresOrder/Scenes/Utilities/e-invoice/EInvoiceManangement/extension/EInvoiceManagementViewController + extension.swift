//
//  EInvoiceManagementViewController + extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 07/06/2025.
//

import UIKit
import RxSwift
extension EInvoiceManagementViewController:UITableViewDelegate,UITableViewDataSource{
    
    
    func setup(){
        // search call API
        text_field_search.rx.controlEvent(.editingChanged)
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .withLatestFrom(text_field_search.rx.text)
            .subscribe (onNext:{ [self] query in
                var apiParameter = viewModel.APIParameter.value
                apiParameter.key_search = query ?? ""
                viewModel.APIParameter.accept(apiParameter)
                viewModel.clearDataAndCallAPI()
                
        }).disposed (by: rxbag)
        
        
        btnArray = [btn_today, btn_yesterday, btn_this_week, btn_this_month, btn_last_month, btn_last_three_month, btn_this_year, btn_last_year, btn_last_three_year, btn_all_year]
        
        Utils.changeBgBtn(btn: btn_today, btnArray: btnArray)
        
        for btn in self.btnArray{
            btn.rx.tap.asDriver().drive(onNext: { [weak self] in
                Utils.changeBgBtn(btn: btn, btnArray: self!.btnArray)
            }).disposed(by: rxbag)
        }
        
        
        registerCell()
        
        actionChooseTabType(btn_waiting_to_export)
    }
    
    
   
    
    
    private func registerCell() {
        let cell = UINib(nibName: "EInvoiceManagementTableViewCell", bundle: .main)
        tableView.register(cell, forCellReuseIdentifier: "EInvoiceManagementTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        tableView.dataSource = self
        tableView.delegate = self
        
        btnShowMore = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: view.frame.width, height: 40)))
        btnShowMore.setTitleColor(ColorUtils.blue_brand_700(), for: .normal)
        btnShowMore.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btnShowMore.setTitle("Xem thêm", for: .normal)
        btnShowMore.addTarget(self, action: #selector(showMore(_:)), for: .touchUpInside)
        btnShowMore.isHidden = true
        tableView.tableFooterView = btnShowMore
    }
    
    @objc private func showMore(_ sender: UIButton) {
        var apiParameter = viewModel.APIParameter.value
        if(!apiParameter.isGetFullData){
            apiParameter.page += 1
            viewModel.APIParameter.accept(apiParameter)
            getInvoiceList()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.invoiceArray.value.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EInvoiceManagementTableViewCell", for: indexPath) as! EInvoiceManagementTableViewCell
        cell.viewModel = viewModel
        cell.data = viewModel.invoiceArray.value[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var order = Order()
        order.id = viewModel.invoiceArray.value[indexPath.row].order_id
        viewModel.makePayMentViewController(order: order)
    }

}



