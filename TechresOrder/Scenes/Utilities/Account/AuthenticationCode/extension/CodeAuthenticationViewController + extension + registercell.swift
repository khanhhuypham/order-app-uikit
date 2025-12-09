//
//  CodeAuthenticationViewController + extension + registercell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 13/8/25.
//

import UIKit

extension CodeAuthenticationViewController:UITableViewDelegate{
    
    func firstSetup(){
        registerCell()
        bindTableViewData()
        
    }

    private func registerCell() {
        let cell = UINib(nibName: "CodeAuthenticationTableViewCell", bundle: .main)
        tableView.register(cell, forCellReuseIdentifier: "CodeAuthenticationTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .singleLine
        tableView.delegate = self
    }
      
      
    @objc func refresh(_ sender: AnyObject) {
        // Code to refresh table view
        refreshControl.endRefreshing()
    }



    private func bindTableViewData() {
        viewModel.dataArray.bind(to: tableView.rx.items(cellIdentifier: "CodeAuthenticationTableViewCell", cellType: CodeAuthenticationTableViewCell.self)){(row, data, cell) in
            cell.viewModel = self.viewModel
            cell.data = data
        }.disposed(by: rxbag)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CreateAuthenticationTokenViewController()
        vc.data = viewModel.dataArray.value[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    

     
}
