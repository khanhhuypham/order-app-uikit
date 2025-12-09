//
//  OrderHistoryDetailOfFoodAppViewController + extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 30/08/2024.
//

import UIKit
import ObjectMapper
import RxSwift
extension FoodAppOrderDetailViewController {
    
    public func setupData(order:FoodAppOrder){
        total_amount.text =  order.total_amount.toString
        lbl_display_id.text = order.display_id
        lbl_created_at.text = order.created_at
        lbl_driver_name.text = order.driver_name
        lbl_driver_phone.text = order.driver_phone
        lbl_customer_name.text = order.customer_name
        lbl_customer_phone.text = order.customer_phone
      
        view_print.isHidden = true
        
        if order.details.count > 0{
            height_of_table.constant = 200
            for i in (0...order.details.count - 1){
                let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0))
                height_of_table.constant += CGFloat(cell?.frame.height ?? 0)
                tableView.layoutIfNeeded()
            }
            height_of_table.constant -= 200
        }else{
            height_of_table.constant = 0
        }
        
    }
        

}


extension FoodAppOrderDetailViewController:UITableViewDelegate {

    func bindTableViewAndRegisterCell(){
        registerCell()
        bindTableViewData()
    }
    
    private func registerCell() {
        let cell = UINib(nibName: "FoodAppOrderDetailTableViewCell", bundle: .main)
        tableView.register(cell, forCellReuseIdentifier: "FoodAppOrderDetailTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.isScrollEnabled = false
    }
    
    private func bindTableViewData() {
        viewModel.order.map{$0.details}.bind(to: tableView.rx.items(
            cellIdentifier: "FoodAppOrderDetailTableViewCell",
            cellType: FoodAppOrderDetailTableViewCell.self)
        ){(row, orderDetail, cell) in
                cell.order = self.viewModel.order.value
                cell.data = orderDetail
  
        }.disposed(by: rxbag)
    }
    
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let item = viewModel.order.value.details[indexPath.row]

    
        // reprint item action
        let reprint = UIContextualAction(style: .normal,title: "") {[weak self] (action, view, completionHandler) in
            self?.presentPreprintPopupViewController(item:item)
            completionHandler(true)
        }
        reprint.backgroundColor = ColorUtils.blue_brand_800()
        reprint.image = UIImage(named:"icon-reprint-item")
        
        let configuration = UISwipeActionsConfiguration(actions: self.viewModel.order.value.is_printed == ACTIVE ? [reprint] : [])
        configuration.performsFirstActionWithFullSwipe = false
    
        return configuration
    }
    
    
    func presentPreprintPopupViewController(item:OrderItemOfFoodApp){
        let vc = FoodAppReprintViewController()
        vc.order = viewModel.order.value
        vc.item = item
        vc.view.backgroundColor = ColorUtils.blackTransparent()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
    }
      
  
}

