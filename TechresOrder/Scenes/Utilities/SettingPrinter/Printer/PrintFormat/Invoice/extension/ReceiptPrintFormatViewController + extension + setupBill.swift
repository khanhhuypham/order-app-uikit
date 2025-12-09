//
//  ReceiptPrintFormatViewController + extension + setupBill.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 06/05/2024.
//

import UIKit

extension ReceiptPrintFormatViewController {
    
    func setupBill(order:OrderDetail,bankAccount:BankAccount){
        let setting = ManageCacheObject.getSetting()
        lbl_name_of_food_app_partner.isHidden = true
        lbl_restaurant_name.text = ManageCacheObject.getCurrentBranch().name
        lbl_table_type.text = order.table_id == 0 ? "(Mang về)" : "(Tại bàn)"
        lbl_address.text = String(format: "Địa chỉ: %@", order.branch_address)
        lbl_hotline.text = String(format: "CSKH: %@", order.branch_phone)
        lbl_table_name.text = String(format: order.table_id == 0 ? "Bàn: MV%@ - #%d - Số khách: %d" : "Bàn: %@ - #%d - Số khách: %d",order.table_name,order.id_in_branch,order.customer_slot_number)
        lbl_reprint_number.text = String(format: "In Lần: %d", order.number_of_reprint)
        lbl_customer_name.text = String(format: "Khách hàng: %@", order.customer_name)
        lbl_customer_phone.text = String(format: "SĐT: %@", order.customer_phone)
        lbl_customer_address.text = String(format: "ĐC giao hàng: %@", order.customer_address)
        lbl_employee_name.text = String(format: "Thu ngân: %@", order.employee_name)
        lbl_saler.text = String(format: "NVKD: %@", order.employee_name)
        lbl_accumulative_point.text = String(format: "NV tích điểm: %@", order.employee_name)
        
        
        var payment_time = ""
        if order.payment_date.split(separator: " ").count > 1{
            payment_time = order.payment_date.split(separator: " ")[1].description
        }
        
        lbl_date.text = String(format: "Ngày giờ: %@ - %@", order.created_at,payment_time)
        
        
        if order.status == ORDER_STATUS_COMPLETE || order.status == ORDER_STATUS_DEBT_COMPLETE || order.status == ORDER_STATUS_CANCEL{
            lbl_reprint_number.isHidden = false
        }else{
            lbl_reprint_number.isHidden = true
        }
       
        if order.order_method == .EAT_IN {
            view_of_customer_name.isHidden = true
            view_of_customer_phone.isHidden = true
            view_of_customer_address.isHidden = true
        }else{
          
            
            view_of_customer_name.isHidden = order.customer_name.isEmpty
            view_of_customer_phone.isHidden = order.customer_phone.isEmpty
            view_of_customer_address.isHidden = order.customer_address.isEmpty
        }

        view_of_accumulative_point.isHidden = permissionUtils.GPBH_1 ? true : false
        view_of_saler.isHidden = permissionUtils.GPBH_1 ? true : false
        
        
    
        if permissionUtils.GPBH_1{
            view_of_accumulative_point.isHidden = true
            view_of_saler.isHidden = true
            lbl_title_SL.isHidden = true
            lbl_title_DG.isHidden = true
        }else{
            view_of_accumulative_point.isHidden = false
            view_of_saler.isHidden = false
            
            switch Constants.bill_type {
                case .bill2,.bill4:
                    lbl_title_SL.isHidden = false
                    lbl_title_DG.isHidden = false
                    
                case .bill1,.bill3:
                    lbl_title_SL.isHidden = true
                    lbl_title_DG.isHidden = true
                }
        }
        
        
        
        
        //=================== mapping data cho món tặng==================
        var giftedAmount:Float = 0
        let giftedItems = order.order_details.filter{$0.is_gift == ACTIVE}
        
        for item in giftedItems {
            giftedAmount += Float(item.price) * item.quantity
        }
        lbl_total_gifted.text = giftedAmount.toString
        
        lbl_total_payment.text = order.amount.toString
        net_payment.text = order.total_final_amount.toString
        
        //=================== mapping data cho chi phí dịch vụ==================
        lbl_total_service_charge.text = order.service_charge_amount.toString
        
        //=================== mapping data cho phụ thu==================
        lbl_total_extra_charge.text =  order.total_amount_extra_charge_amount.toString
        
        //=================== mapping data cho vat ==================
        lbl_total_vat.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(order.vat_amount))
        lbl_vat_title.text = setting.is_show_vat_on_items_in_bill == ACTIVE
        ? "VAT (*%VAT hiển thị sau giá món)"
        : "VAT: "
        
        
        for vat in order.vat_details {
            stackview_of_vat.addArrangedSubview(createViewWithTwoLabels(title: String(format: "• %d%%", vat.vat_percent), value: vat.vat_amount.toString,height: 30))
        }
        
      
        
        view_of_vat_content.isHidden = order.is_apply_vat == ACTIVE ? true : false
        top_contraint_of_greeting_content.constant = view_of_vat_content.isHidden == true ? 16 : 8
        
        //=================== mapping data for deposit ==================
        deposit_amount.text = order.booking_deposit_amount.toString
        returned_amount.text = Utils.stringVietnameseMoneyFormatWithNumberInt(
            amount: order.cash_amount + order.bank_amount + order.transfer_amount + order.wallet_amount
        )
        change_amount.text = order.tip_amount.toString
        
        //=================== mapping data for discount ==================
        
        let totalDiscount = order.total_amount_discount_amount + order.food_discount_amount + order.drink_discount_amount
        
        lbl_total_discount.text = totalDiscount.toString
        
        if order.total_amount_discount_amount > 0{
            view_of_discount_detail.isHidden = true
            
            lbl_total_discount.text = String(
                format: "%@ (%d%%)",
                Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(totalDiscount)),
                order.total_amount_discount_percent
            )
            
            lbl_discount_percent.text = "(tổng bill)"
        }else if order.food_discount_amount > 0 || order.drink_discount_amount > 0{
            view_of_discount_detail.isHidden = false
            lbl_discount_percent.text = "(Theo loại món)"
            lbl_discount_percent_of_food.text = String(format:"%@ (%d%%)", order.food_discount_amount.toString,order.food_discount_percent)
            lbl_discount_percent_of_drink.text = String(format:"%@ (%d%%)", order.drink_discount_amount.toString,order.drink_discount_percent)
        } else{
            stack_view_of_discount.isHidden = true
            view_of_discount_detail.isHidden = true
            lbl_discount_percent.text = ""
        }
        
        //=================== mapping data cho coupon==================
        lbl_coupon_amount.text =  String(format: order.coupon_percent > 0 ? "%@ (%d%%)" : "%@",order.coupon_amount.toString, order.coupon_percent)
        
        //==============================================================
    
        if setting.is_hidden_payment_detail_in_bill == ACTIVE {
            view_of_gift.isHidden = giftedAmount == 0 ? true : false
            view_of_used_point.isHidden = order.membership_point_used_amount == 0 ? true : false
            view_of_extra_charge.isHidden = order.total_amount_extra_charge_amount == 0 ? true : false
            stackview_of_vat.isHidden = order.vat_amount == 0 ? true : false
            view_of_deposit.isHidden = order.booking_deposit_amount == 0 ? true : false
            view_of_change_amount.isHidden = order.tip_amount == 0 ? true : false
        }
        
        if order.transfer_amount > 0 {
            
            if !bankAccount.bank_number.isEmpty && !bankAccount.bank_name.isEmpty && !bankAccount.bank_account_name.isEmpty {
                container_view_of_qr_code.isHidden = false
                
                if bankAccount.payment_type == .payos{
                    qr_code_img_view?.image = generateQRCode(from:bankAccount.qr_code)
                }
                lbl_account_number.text = String(format: "Số tài khoản: %@", bankAccount.bank_number)
                lbl_bank.text = String(format: "Tên ngân hàng: %@", bankAccount.bank_name)
                lbl_account_holder.text = String(format: "Tên tài khoản: %@", bankAccount.bank_account_name)
                
            }else{
                container_view_of_qr_code.isHidden = true
            }
            
        }else if order.cash_amount > 0{
            container_view_of_qr_code.isHidden = true
        }else{
            container_view_of_qr_code.isHidden = true
        }
        
       
        if permissionUtils.GPBH_1{
            lbl_title_total_payment.font = UIFont.systemFont(ofSize: 18, weight: .light)
            lbl_total_payment.font = UIFont.systemFont(ofSize: 18, weight: .light)
            net_payment.font = UIFont.systemFont(ofSize: 18, weight: .light)
            title_net_payment.font = UIFont.systemFont(ofSize: 18, weight: .light)
            
            view_of_greeting.isHidden = false
            view_of_used_point.isHidden = true
            view_of_service_charge.isHidden = true
            view_of_extra_charge.isHidden = true
            view_of_deposit.isHidden = true
            view_of_change_amount.isHidden = true
            view_of_return_amount.isHidden = true
            
        }else{
            view_of_greeting.isHidden = setting.greeting_content_on_bill.isEmpty && setting.vat_content_on_bill.isEmpty ? true : false
            vat_content.text = setting.vat_content_on_bill
            greeting_content.text = setting.greeting_content_on_bill
            view_of_used_point.isHidden = Constants.brand.setting?.show_points_used == ACTIVE ? false : true
            view_of_service_charge.isHidden = order.service_charge_amount > 0 ? false : true
            view_of_extra_charge.isHidden = false
            view_of_deposit.isHidden = false
            view_of_change_amount.isHidden = false
            view_of_return_amount.isHidden = false

            lbl_title_total_payment.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            lbl_total_payment.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            net_payment.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            title_net_payment.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        }
        
        lbl_restaurant_name.isHidden = Constants.brand.setting?.show_branch_name == ACTIVE ? false : true
        lbl_title.isHidden = Constants.brand.setting?.show_bill_title == ACTIVE ? false : true
        lbl_address.isHidden = Constants.brand.setting?.show_address == ACTIVE ? false : true
        lbl_hotline.isHidden = Constants.brand.setting?.show_hotline == ACTIVE ? false : true
        lbl_table_type.isHidden = Constants.brand.setting?.show_table_code == ACTIVE ? false : true
        view_of_table_name.isHidden = Constants.brand.setting?.show_table_code == ACTIVE ? false : true
      
        view_of_employee_name.isHidden = Constants.brand.setting?.show_cashier_name == ACTIVE ? false : true
        view_of_saler.isHidden = Constants.brand.setting?.show_waiter_name == ACTIVE ? false : true
        view_of_accumulative_point.isHidden = Constants.brand.setting?.show_point_staff_name == ACTIVE ? false : true
        view_of_date.isHidden = Constants.brand.setting?.show_datetime == ACTIVE ? false : true
        view_of_gift.isHidden = Constants.brand.setting?.show_gift == ACTIVE ? false : true
        stack_view_of_discount.isHidden = Constants.brand.setting?.show_discount == ACTIVE ? false : true
        stackview_of_vat.isHidden = Constants.brand.setting?.show_vat == ACTIVE ? false : true
        view_of_extra_charge.isHidden = Constants.brand.setting?.show_surcharge == ACTIVE ? false : true
        view_of_service_charge.isHidden = Constants.brand.setting?.show_service_charge == ACTIVE ? false : true
        view_of_deposit.isHidden = Constants.brand.setting?.show_deposit == ACTIVE ? false : true
        qr_code_view.isHidden = Constants.brand.setting?.show_qr_code == ACTIVE ? false : true
        stack_view_of_bank_info.isHidden = Constants.brand.setting?.show_bank_info == ACTIVE ? false : true
        topline_of_greeting.isHidden = !container_view_of_qr_code.isHidden
        view_of_greeting.isHidden = Constants.brand.setting?.show_footer == ACTIVE ? false : true
        view_of_copy_right.isHidden = Constants.brand.setting?.show_dev_info == ACTIVE ? false : true
        
        tableView.reloadData()
        
        if order.order_details.count > 0{
            height_of_table.constant = 200
            for i in (0...order.order_details.count - 1){
                
                let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0))
                height_of_table.constant += CGFloat(cell?.frame.height ?? 0)
                tableView.layoutIfNeeded()
            }
            
            tableView.layoutIfNeeded()
            height_of_table.constant -= 200
        }else{
            height_of_table.constant = 0
        }
        
        PrinterUtils.shared.changeTextColorForPOSPrinter(view: contentView,textColor:textColor,bgColor:.black)
        addViewBorder(color: textColor, thickness: 1)
        view.layoutIfNeeded()
    }

    private func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 10, y: 10)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
    
    func fetchQRCodeImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let encodedURLString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedURLString) else {
            print("❌ Invalid or unencoded URL")
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Error loading QR image: \(error)")
                completion(nil)
                return
            }

            guard let data = data, let originalImage = UIImage(data: data) else {
                print("❌ Failed to decode image data")
                completion(nil)
                return
            }
//
//            // Apply grayscale filter
//            let grayImage = self.applyGrayscale(to: originalImage)originalImage

            DispatchQueue.main.async {
                completion(originalImage)
            }
    
            
        }.resume()
    }
    
    
    func applyGrayscale(to image: UIImage) -> UIImage? {
        guard let ciImage = CIImage(image: image) else { return nil }

        let filter = CIFilter(name: "CIColorControls")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(0.0, forKey: kCIInputSaturationKey) // 0 = full gray

        guard let outputCIImage = filter?.outputImage else { return nil }

        let context = CIContext()
        if let cgImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) {
            return UIImage(cgImage: cgImage)
        }

        return nil
    }

    private func addViewBorder(color:UIColor,thickness:CGFloat) {
        createLine(view:topline_of_title, color: color, width: 2)
        createLine(view:topLine_of_tableView, color: color, width: 2)
        createLine(view:underLine_of_tableView, color: color, width: 2)
        createDashedLine(parentView:topLine_of_qr_code, color: color, strokeLength: 10, gapLength: 2, width: 2)
        createDashedLine(parentView:underLine_of_qr_code, color: color, strokeLength: 10, gapLength: 2, width: 2)
        createDashedLine(parentView:topline_of_greeting, color: color, strokeLength: 10, gapLength: 2, width: 2)
    }
    

    func createViewWithTwoLabels(title: String, value: String, height: CGFloat = 40) -> UIView {
        let containerView = UIView()

          // Title label
        let label_1 = UILabel()
        label_1.text = title
        label_1.font = UIFont.boldSystemFont(ofSize: 18)
        label_1.textColor = .black

          // Subtitle label
        let label_2 = UILabel()
        label_2.text = value
        label_2.textAlignment = .right
        label_2.font = UIFont.systemFont(ofSize: 14)
        label_2.textColor = .darkGray

        // StackView to hold labels horizontally
        let stackView = UIStackView(arrangedSubviews: [label_1, label_2])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(stackView)
        containerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
          containerView.heightAnchor.constraint(equalToConstant: height),
          
          stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
          stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
          stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0),
          stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])

        return containerView
    }
    
}
