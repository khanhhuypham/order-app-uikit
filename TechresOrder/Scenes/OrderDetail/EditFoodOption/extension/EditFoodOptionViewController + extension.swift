//
//  EditFoodOptionViewController + extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 26/02/2025.
//

import UIKit
import JonAlert

extension EditFoodOptionViewController{
    
    
    func updateFoodsToOrder(updateFood: [FoodUpdate]){
        viewModel.updateFoods(updateFood: updateFood).subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                self.actionCancel("")
            }else {
                JonAlert.showError(message: response.message ?? "", duration: 3.0)
            }
        }).disposed(by: rxbag)
        
    }
}



// MARK: - UITableViewDataSource and UITableViewDelegate
extension EditFoodOptionViewController: UITableViewDataSource, UITableViewDelegate,UITextViewDelegate {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        let cell = UINib(nibName: "EditFoodOptionTableViewCell", bundle: .main)
        self.tableView.register(cell, forCellReuseIdentifier: "EditFoodOptionTableViewCell")
        tableView.tableFooterView = UIView(frame: .zero)
    }


    func firstSetup() {
        viewModel.orderId.accept(self.orderId)
        viewModel.orderItem.accept(self.item)
        lbl_name.text = item.name
        text_view.text = item.note
        text_view.delegate = self // Set the delegate

        
        _ = viewModel.orderItem.asObservable().subscribe(onNext: {(item) in
            var amount:Float = 0
            amount = Float(item.price) * item.quantity
            
            for option in item.order_detail_options{
                
                for optionItem in option.food_option_foods.filter{$0.status == ACTIVE}{
                    amount += Float(optionItem.price) * item.quantity
                }
            }
            
            self.lbl_price.text = amount.toString
            
        }).disposed(by: rxbag)
        
        
        textfield_quantity.text = item.quantity.toString
        tableView.reloadData()
    }
    
    // UITextViewDelegate method
    func textViewDidChange(_ textView: UITextView) {
        var item = viewModel.orderItem.value
        item.note = textView.text
        
        viewModel.orderItem.accept(item)
        
    }

  
    func numberOfSections(in tableView: UITableView) -> Int {
        return item.order_detail_options.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))

        // Create Title Label
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = .darkGray
        titleLabel.text = viewModel.orderItem.value.order_detail_options[section].name

        // Create Max Selection Label (Styled as a Button)
        let maxSelectLabel = UILabel()
        
        if  viewModel.orderItem.value.order_detail_options[section].max_items_allowed > 1 {
            maxSelectLabel.text = String(format: "Chọn tối đa %d", viewModel.orderItem.value.order_detail_options[section].max_items_allowed)
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
        NSLayoutConstraint.activate([
            maxSelectLabel.widthAnchor.constraint(equalToConstant: 100),
            maxSelectLabel.heightAnchor.constraint(equalToConstant: 30)
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
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        return view
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let item = viewModel.orderItem.value
        if item.order_detail_options.isEmpty{
            return 0
        }
        
        return item.order_detail_options[section].food_option_foods.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = viewModel.orderItem.value
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditFoodOptionTableViewCell", for: indexPath) as! EditFoodOptionTableViewCell
        cell.isMultiple = item.order_detail_options[indexPath.section].max_items_allowed > 1 ? true : false
        cell.data = item.order_detail_options[indexPath.section].food_option_foods[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var item = viewModel.orderItem.value

        let section = item.order_detail_options[indexPath.section]
        
        if section.max_items_allowed > 1{
            
            for (index, option) in item.order_detail_options[indexPath.section].food_option_foods.enumerated() {
                
            
            
    
                if  index == indexPath.row{
                    item.order_detail_options[indexPath.section].food_option_foods[index].status =
                    item.order_detail_options[indexPath.section].food_option_foods[index].status == ACTIVE ? DEACTIVE : ACTIVE
                }
                
                
                if  item.order_detail_options[indexPath.section].food_option_foods.filter{$0.status == ACTIVE}.count > section.max_items_allowed{
                    item.order_detail_options[indexPath.section].food_option_foods[index].status = DEACTIVE
                    self.showWarningMessage(content: String(format: "Số lượng %@ tối đa là %d", section.name,section.max_items_allowed))
                    
                }
                
                
                
                
            }
            
            
            
            
        }else{
            for (index, option) in item.order_detail_options[indexPath.section].food_option_foods.enumerated() {
               
                if index == indexPath.row{
                    item.order_detail_options[indexPath.section].food_option_foods[index].status = ACTIVE
                }else{
                    item.order_detail_options[indexPath.section].food_option_foods[index].status = DEACTIVE
                }
            }
        }
        
        viewModel.orderItem.accept(item)
        
        tableView.reloadData()
    }


}

