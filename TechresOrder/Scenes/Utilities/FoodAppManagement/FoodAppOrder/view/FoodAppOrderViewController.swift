//
//  FoodAppOrderViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 19/11/25.
//

import UIKit

class FoodAppOrderViewController: BaseViewController {

    @IBOutlet weak var btn_wait_to_confirm: UIButton!
    @IBOutlet weak var btn_confirm: UIButton!
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var view_nodata_order: UIView!

    
    let refreshControl = UIRefreshControl()
    let viewModel = FoodAppOrderViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        firstSetup()
        actionFilterOnStatus(btn_wait_to_confirm)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }


    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionFilterOnStatus(_ sender: UIButton) {
        var p = self.viewModel.APIParameter.value
        
        switch sender.tag{
            case 0:
                btn_wait_to_confirm.backgroundColor = ColorUtils.orange_brand_900()
                btn_confirm.backgroundColor = .systemGray5
                p.confirmation = sender.tag
                btnFilter.isHidden = true
                break
                
            case 1:
                btn_wait_to_confirm.backgroundColor = .systemGray5
                btn_confirm.backgroundColor = ColorUtils.orange_brand_900()
                p.confirmation = sender.tag
                btnFilter.isHidden = false
                break
            
            default:
                break;
        }
        
        viewModel.APIParameter.accept(p)
        getOrderListOfFoodApp()
    }
    
    
    
    

}
