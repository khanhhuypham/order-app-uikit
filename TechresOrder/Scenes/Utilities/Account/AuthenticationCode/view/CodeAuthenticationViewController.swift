//
//  CodeAuthenticationViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 13/8/25.
//

import UIKit

class CodeAuthenticationViewController: BaseViewController {


    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var view_nodata: UIView!
    
    let refreshControl = UIRefreshControl()
    var viewModel = CodeAuthenticationViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self)
        firstSetup()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCodeAuthenticationList()
    }

    @IBAction func actionBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionCreateAuthenticationCode(_ sender: Any) {
        createAuthenticationCode(expire_at: dateAfterAddingHoursString(2), code: randomString().uppercased())
    
    }
    
    
    private func dateAfterAddingHoursString(_ hours: Int) -> String {
        let formatter = dateFormatter.dd_mm_yyyy_hh_mm.value
        let futureDate = Calendar.current.date(byAdding: .hour, value: hours, to: Date()) ?? Date()
        return formatter.string(from: futureDate)
    }

    
    private func randomString(length: Int = 6) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).compactMap { _ in characters.randomElement() })
    }

    

}
