//
//  EReceiptConnectionViewController + extension.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 05/06/2025.
//

import UIKit


extension EReceiptConnectionViewController:UITableViewDelegate,UITableViewDataSource{
    
    func registerCell() {
        let cell = UINib(nibName: "EReceiptConnectionTableViewCell", bundle: .main)
        tableView.register(cell, forCellReuseIdentifier: "EReceiptConnectionTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.invoiceArray.value.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EReceiptConnectionTableViewCell", for: indexPath) as! EReceiptConnectionTableViewCell
        cell.viewModel = self.viewModel
        cell.data = self.viewModel.invoiceArray.value[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}


//MARK: yc nhập thông tin khách hàng (dành cho bàn mang về)
extension EReceiptConnectionViewController{
        
    func presentEditEReceiptConnectionViewController(invoice:EInvoicePartner) {
        let vc = EditEInvoiceConnectionViewController()
        vc.invoice = invoice
        vc.completion = getRestaurantPartnerInvoice
        vc.view.backgroundColor = ColorUtils.blackTransparent()
        vc.modalPresentationStyle = .pageSheet
        present(vc, animated: true, completion: nil)
    }
    
    
}




