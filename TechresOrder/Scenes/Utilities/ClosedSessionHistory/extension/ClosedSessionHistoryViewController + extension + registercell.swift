//
//  ClosedSessionHistoryViewController + extension + registercell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 17/06/2025.
//

import UIKit
import RxSwift
extension ClosedSessionHistoryViewController:UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate{
  
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
        
        
        lbl_from_date.text = Utils.getCurrentDateString()
        lbl_to_date.text = Utils.getCurrentDateString()
      
        registerCell()
 
    }
    
    

    private func registerCell() {
        let cell = UINib(nibName: "ClosedSessionHistoryTableViewCell", bundle: .main)
        tableView.register(cell, forCellReuseIdentifier: "ClosedSessionHistoryTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
    @objc func refresh(_ sender: AnyObject) {
      // Code to refresh table view
        viewModel.clearDataAndCallAPI()
        refreshControl.endRefreshing()
    }
 
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataArray.value.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClosedSessionHistoryTableViewCell", for: indexPath) as! ClosedSessionHistoryTableViewCell
        cell.data = viewModel.dataArray.value[indexPath.row]
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ClosedWorkingSessionViewController()
        vc.workingSession = viewModel.dataArray.value[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        var p = viewModel.APIParameter.value
        let tableViewContentHeight = tableView.contentSize.height
        let tableViewHeight = tableView.frame.size.height
        let scrollOffset = scrollView.contentOffset.y
        
        if scrollOffset + tableViewHeight >= tableViewContentHeight {
            
            if(!p.isGetFullData && !p.isAPICalling){
                p.page += 1
                p.isAPICalling = true
                viewModel.APIParameter.accept(p)
                getClosedSessionHistory()
            }
        }
    }
}
