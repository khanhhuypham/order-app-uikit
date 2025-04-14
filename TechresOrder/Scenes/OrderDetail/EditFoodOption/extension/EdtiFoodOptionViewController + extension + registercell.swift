//
//  EdtiFoodOptionViewController + extension + registercell.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 10/04/2025.
//

import UIKit
import RxSwift
import RxDataSources
extension EditFoodOptionViewController:UITableViewDelegate {

    func registerCellAndBindTableView(){
        registerCell()
        bindTableViewData()
    }

    private func registerCell() {

        let cell = UINib(nibName: "EditFoodOptionTableViewCell", bundle: .main)
        tableView.register(cell, forCellReuseIdentifier: "EditFoodOptionTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = 30
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        tableView.delegate = self
        
    }
    
    
    private func bindTableViewData() {

        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<OptionOfDetailItem,OptionItem>> (

            configureCell: { (dataSource, tableView, indexPath, item) in
              
                let cell = tableView.dequeueReusableCell(withIdentifier: "EditFoodOptionTableViewCell", for: indexPath) as! EditFoodOptionTableViewCell
                cell.viewModel = self.viewModel
                cell.indexPath = indexPath
                cell.data = item
                
                return cell
            }
        )
        
        viewModel.sectionArray.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: rxbag)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        return renderHeader(section: viewModel.sectionArray.value[section].model)
    }
    
    private func renderHeader (section:OptionOfDetailItem) -> UIView{
       
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))

        // Create Max Selection Label (Styled as a Button)
        let maxSelectLabel = UILabel()
        // Create Title Label
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = .darkGray
        titleLabel.text = section.name



        if section.max_items_allowed > 1 {
            maxSelectLabel.text = String(format: "Chọn tối đa %d", section.max_items_allowed)
        }else {
            maxSelectLabel.text = "Chọn 1"
        }

        maxSelectLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        maxSelectLabel.textColor = .white
        maxSelectLabel.backgroundColor = UIColor.orange
        maxSelectLabel.textAlignment = .center
        maxSelectLabel.layer.cornerRadius = 15
        maxSelectLabel.layer.masksToBounds = true

        // Set fixed width and height for maxSelectLabel
        maxSelectLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            maxSelectLabel.widthAnchor.constraint(equalToConstant: 100)
        ])

        // Create Horizontal StackView
        let stackView = UIStackView(arrangedSubviews: [titleLabel, maxSelectLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing // Ensures labels are spaced properly
        stackView.spacing = 8

        // Add stackView to the view
        view.addSubview(stackView)

        // Enable Auto Layout
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            maxSelectLabel.heightAnchor.constraint(equalToConstant: 30)
        ])

        return view
    }
}
