//
//  ChooseOptionViewController + extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 27/02/2025.
//

import UIKit

// MARK: - UITableViewDataSource and UITableViewDelegate
extension ChooseOptionViewController: UITableViewDataSource, UITableViewDelegate,UITextViewDelegate {
    
    @objc private func keyboardWillShow(notification: NSNotification ) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            if text_view.isFirstResponder || textfield_quantity.isFirstResponder{
                root_view.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height)
            }
        }
    }
        
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        if text_view.isFirstResponder || textfield_quantity.isFirstResponder {
            root_view.transform = .identity
        }
    }
    
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        let cell = UINib(nibName: "ChooseOptionTableViewCell", bundle: .main)
        self.tableView.register(cell, forCellReuseIdentifier: "ChooseOptionTableViewCell")
        tableView.tableFooterView = UIView(frame: .zero)
    }


    func firstSetup() {
        item.quantity = item.quantity == 0 ? 1 : item.quantity
        let imageUrl = URL(string: Utils.getFullMediaLink(string: item.avatar))
        food_image.kf.setImage(with: imageUrl, placeholder: UIImage(named: "image_defauft_medium"))
        lbl_name.text = item.name
        lbl_price.text = (item.price_with_temporary * Int(item.quantity)).toString
        textfield_quantity.text = item.quantity.toString
        text_view.text = item.note
 
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillChangeFrameNotification , object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification , object:nil)
        text_view.withDoneButton()
        text_view.delegate = self // Set the delegate

        for (i,option) in item.food_options.enumerated(){
            
            if option.max_items_allowed > 1 {
                
                for (j,optionItem) in option.addition_foods.enumerated(){
                    if  optionItem.is_selected == ACTIVE{
                        item.food_options[i].addition_foods[j].is_selected = ACTIVE
                    }
                }
//                
//                if item.food_options[i].addition_foods.filter{$0.is_selected == ACTIVE}.isEmpty && option.min_items_allowed > 0{
//                    item.food_options[i].addition_foods[0].is_selected = ACTIVE
//                }
                
                
            }else{
                
                if let j = option.addition_foods.firstIndex(where: {$0.is_selected == ACTIVE}){
                    item.food_options[i].addition_foods[j].is_selected = ACTIVE
                }else{
                    if (option.min_items_allowed > 0){
                        item.food_options[i].addition_foods[0].is_selected = ACTIVE
                    }
                    
                }
                
            }
            
            
            
//            option.addition_foods.filter()
//            
//            for (_,optionItem) in option.addition_foods.enumerated(){
//
//                if (option.min_items_allowed > 0){
//                    item.food_options[i].addition_foods[0].is_selected = ACTIVE
//                }
//            }
//            
            
            
        }

        tableView.reloadData()
    
        if item.food_options.count > 0{
            
            height_of_table.constant = 200
            
            for (i,option) in item.food_options.enumerated(){
                height_of_table.constant += tableView.rect(forSection: i).height

            }
        
            height_of_table.constant -= 200
            tableView.layoutIfNeeded()
        }else{
            height_of_table.constant = 0
        }
        
    }
    
    // UITextViewDelegate method
    func textViewDidChange(_ textView: UITextView) {
        item.note = textView.text
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return item.food_options.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))

        // Create Title Label
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = .darkGray
        titleLabel.text = item.food_options[section].name

        // Create Max Selection Label (Styled as a Button)
        let maxSelectLabel = UILabel()
        
        if  item.food_options[section].max_items_allowed > 1 {
            maxSelectLabel.text = String(format: "Chọn tối đa %d", item.food_options[section].max_items_allowed)
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
        
        
        return item.food_options[section].addition_foods.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseOptionTableViewCell", for: indexPath) as! ChooseOptionTableViewCell
        cell.isMultiple = item.food_options[indexPath.section].max_items_allowed > 1 ? true : false
        cell.data = item.food_options[indexPath.section].addition_foods[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let section = item.food_options[indexPath.section]
        
        if section.max_items_allowed > 1{
            
            for (index, option) in section.addition_foods.enumerated() {
                
                if  index == indexPath.row{
                    item.food_options[indexPath.section].addition_foods[index].is_selected =
                    item.food_options[indexPath.section].addition_foods[index].is_selected == ACTIVE ? DEACTIVE : ACTIVE
                }
                
                if  item.food_options[indexPath.section].addition_foods.filter{$0.is_selected == ACTIVE}.count > section.max_items_allowed{
                    item.food_options[indexPath.section].addition_foods[index].is_selected = DEACTIVE
                    self.showWarningMessage(content: String(format: "Số lượng %@ tối đa là %d", section.name,section.max_items_allowed))
                    
                }
                
            }
        }else{
            for (index, option) in item.food_options[indexPath.section].addition_foods.enumerated() {
               
                if index == indexPath.row{
                    item.food_options[indexPath.section].addition_foods[index].is_selected = ACTIVE
                }else{
                    item.food_options[indexPath.section].addition_foods[index].is_selected = DEACTIVE
                }
            }
        }
        
        tableView.reloadData()
        
    }


}

