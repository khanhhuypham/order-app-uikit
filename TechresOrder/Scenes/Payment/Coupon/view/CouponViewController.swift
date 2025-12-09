//
//  CouponViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 24/10/25.
//

import UIKit

class CouponViewController: BaseViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var view_no_data: UIView!
    
    let viewModel = CouponViewModel()

    var order: OrderDetail = OrderDetail()
    var couponId: Int = 0
    var completion:(() -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self)
        viewModel.order.accept(order)
        registerCell()
        tableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCouponList()
    }
    
    
    @IBAction func actionDismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func actionConfirm(_ sender: Any) {
        let totalDiscount = order.total_amount_discount_amount + order.food_discount_amount + order.drink_discount_amount

        guard totalDiscount == 0 else {
            showWarningMessage(content: "Đơn hàng đã được giảm giá, không thể áp dụng coupon")
            return
        }

        guard permissionUtils.discountOrderItem else {
            showWarningMessage(content: "Bạn chưa được cấp quyền sử dụng tính năng này, vui lòng liên hệ quản lý")
            return
        }

        guard let coupon = viewModel.list.value.first(where: { $0.select }) else { return }

        applyCoupon(orderId: order.id, couponId: coupon.id)

        
    }
    

}
