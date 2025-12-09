//
//  PaymentRebuildViewController + extension + registerCell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 23/10/2023.
//

import UIKit

extension PaymentRebuildViewController {

    func bindTableViewAndRegisterCell(){
        registerCell()
        bindTableViewData()
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    private func registerCell() {
        let cell = UINib(nibName: "PaymentRebuildTableViewCell", bundle: .main)
        tableView.register(cell, forCellReuseIdentifier: "PaymentRebuildTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isScrollEnabled = false
    }
    
    private func bindTableViewData() {
        viewModel.order.map{$0.order_details}.bind(to: tableView.rx.items(cellIdentifier: "PaymentRebuildTableViewCell", cellType: PaymentRebuildTableViewCell.self))
           {  (row, orderDetail, cell) in
                cell.viewModel = self.viewModel
                cell.orderStatus = self.viewModel.order.value.status
                cell.data = orderDetail
           }.disposed(by: rxbag)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if let newValue = change?[.newKey] as? NSValue {
                let newSize = newValue.cgSizeValue
                self.height_of_table.constant = newSize.height
            }
        }
    }

  
}



