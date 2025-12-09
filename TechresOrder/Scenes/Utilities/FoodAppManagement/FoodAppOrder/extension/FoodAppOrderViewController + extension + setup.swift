//
//  FoodAppOrderViewController + extension + setup.swift
//  TechresOrder
//
//  Created by Pham Khanh Huy on 21/11/25.
//

import UIKit

extension FoodAppOrderViewController {
    func firstSetup() {
        registerCell()
        setupMenu()
    }
    
    private func setupMenu() {
        let actions = APP_PARTNER.allCases
            .filter { $0 != .gofood }
            .map { partner in
                UIAction(
                    title: partner.description,
                    identifier: .init(partner.rawValue),
                    handler: { [weak self] action in
                        self?.handlePartnerSelection(from: action)
                    }
                )
            }

        btnFilter.menu = UIMenu(title: "Đối tác", children: actions)
        btnFilter.showsMenuAsPrimaryAction = true
        btnFilter.changesSelectionAsPrimaryAction = true
//        
        if let firstAction = actions.first{
            let attribute = Utils.setAttributesForBtn(
                content: firstAction.title,
                attributes: [.font: UIFont.systemFont(ofSize: 13, weight: .semibold)]
            )
            btnFilter.setAttributedTitle(attribute, for: .normal)
        }
       
    }

    // MARK: - Handle Selection
    private func handlePartnerSelection(from action: UIAction) {
        guard let selectedPartner = APP_PARTNER(rawValue: action.identifier.rawValue) else { return }
    
        let attribute = Utils.setAttributesForBtn(
            content: selectedPartner.description,
            attributes: [.font: UIFont.systemFont(ofSize: 13, weight: .semibold)]
        )
        btnFilter.setAttributedTitle(attribute, for: .normal)

        // update ViewModel
        var param = viewModel.APIParameter.value
        param.partner = selectedPartner
        viewModel.APIParameter.accept(param)
        getOrderListOfFoodApp()
    }

}

// MARK: register cell
extension FoodAppOrderViewController: UITableViewDataSource,UITableViewDelegate {

    func registerCell(){
        let cell = UINib(nibName: "FoodAppOrderTableViewCell", bundle: .main)
        tableView.register(cell, forCellReuseIdentifier: "FoodAppOrderTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl) // not required when using UItableViewController
    }
    
    
    @objc func refresh(_ sender: AnyObject) {
          // Code to refresh table view
        getOrderListOfFoodApp()
        refreshControl.endRefreshing()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.array.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodAppOrderTableViewCell", for: indexPath) as! FoodAppOrderTableViewCell
        cell.data = viewModel.array.value[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = FoodAppOrderDetailViewController()
        dLog(viewModel.array.value[indexPath.row])
        vc.order = viewModel.array.value[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    

 }

