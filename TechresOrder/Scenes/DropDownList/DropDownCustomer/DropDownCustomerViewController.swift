//
//  DropDownCustomerViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 31/03/2025.
//

import UIKit



class DropDownCustomerViewController<Element> : UITableViewController {
    
    typealias SelectionHandler = (Element) -> Void
    typealias LabelProvider = (Element) -> String
    
    private let values : [Element]
    private let labels : LabelProvider
    private let onSelect : SelectionHandler?
    
    var delegate: DropDownCustomerViewControllerDelegate?
    
    var list:[Customer] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib.init(nibName: "DropDownCustomerTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "DropDownCustomerTableViewCell")
        self.tableView.showsVerticalScrollIndicator = false
        
    }

    init(_ values : [Element], labels : @escaping LabelProvider = String.init(describing:), onSelect : SelectionHandler? = nil) {
        self.values = values
        self.onSelect = onSelect
        self.labels = labels
        super.init(style: .plain)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
 
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownCustomerTableViewCell", for: indexPath) as! DropDownCustomerTableViewCell
        cell.data = list[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.callbackToGetCustomer(customer: list[indexPath.row])
        dismiss(animated: true, completion: nil)
    }

}


