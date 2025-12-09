//
//  BranchViewController.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 16/01/2023.
//

import UIKit
import ObjectMapper
import RxRelay
import RxSwift

class BranchViewController: BaseViewController {

    @IBOutlet weak var root_view: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var textFieldSearch: UITextField!
    var viewModel = BranchViewModel()
    var key_word = ""
    var delegate:BranchDelegate?
    var brand:Brand = Brand()
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        bindTableViewData()
        viewModel.brand.accept(self.brand)
        getBranch()
    }
}
extension BranchViewController{
    func registerCell() {
        let branchTableViewCell = UINib(nibName: "BranchTableViewCell", bundle: .main)
        tableView.register(branchTableViewCell, forCellReuseIdentifier: "BranchTableViewCell")
        
        self.tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        tableView.rx.modelSelected(Branch.self) .subscribe(onNext: { [self] element in
      
            dismiss(animated: true,completion: {
                ManageCacheObject.saveCurrentBrand(self.viewModel.brand.value)
                self.delegate?.callBackChooseBranch(branch: element)
            })

        }).disposed(by: rxbag)
    }
}



extension BranchViewController{
    
    private func bindTableViewData() {
       viewModel.dataArray.bind(to: tableView.rx.items(cellIdentifier: "BranchTableViewCell", cellType: BranchTableViewCell.self))
           {  (row, branch, cell) in
               cell.data = branch
               cell.viewModel = self.viewModel
           }.disposed(by: rxbag)
       }
}


extension BranchViewController{

    
    private func getBranch(){
     
        viewModel.getBranches().subscribe(onNext: { (response) in
       
            if(response.code == RRHTTPStatusCode.ok.rawValue){
                if let rights = Mapper<Branch>().mapArray(JSONObject: response.data) {

                    self.viewModel.dataArray.accept(rights.filter{$0.is_office == DEACTIVE})
                }
            }else{
                dLog(response.message ?? "")
            }
         
        }).disposed(by: rxbag)
    }
    
    
    

    
}

