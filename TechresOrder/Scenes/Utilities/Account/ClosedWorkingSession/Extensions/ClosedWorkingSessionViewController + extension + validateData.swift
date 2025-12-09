//
//  ClosedWorkingSessionViewController + extension + validateData.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 17/06/2025.
//

import UIKit


extension ClosedWorkingSessionViewController {
    
    func mapData(workingSessionValue:WorkingSessionValue){
        
        //TỔNG HỢP
        txtTotalReceipt.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.total_receipt_amount_final!)
        sum_cashAmountOfFirstShift.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.before_cash!)
        sum_totalRevenue.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.cash_amount!)
        sum_Receipt.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.in_cash_amount_by_addition_fee!)
        sum_deposit.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.deposit_amount!)
        sum_topUpCardAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.total_top_up_card_amount!)
        sum_totalCashReceived.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.total_amount_final!)
        sum_totalCashPaid.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.total_cost_final!)
        sum_returnedDeposit.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.return_deposit_cash_amount!)
        sum_payment.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.out_cash_amount_by_addition_fee!)
        sum_tip.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.tip_amount!)
        sum_difference.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(getRealAmount()) - workingSessionValue.total_receipt_amount_final!)
        
        
        //TIỀN ĐẶT CỌC
        deposit_totalAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.deposit_amount!)
        deposit_cashAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.deposit_cash_amount!)
        deposit_bankCardAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.deposit_bank_amount!)
        deposit_cashTransferAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.deposit_transfer_amount!)
        deposit_digitalWalletAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.deposit_wallet_amount!)
        
        
        //TIỀN TRẢ CỌC
        returnedDeposit_totalAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.return_deposit_amount!)
        returnedDeposit_cashAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.return_deposit_cash_amount!)
        returnedDeposit_cashTransferAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.return_deposit_transfer_amount!)
        
        //TỔNG NẠP THẺ
        topUpCard_totalAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.total_top_up_card_amount!)
        topUpCard_cashAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.total_top_up_card_cash_amount!)
        topUpCard_bankCardAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.total_top_up_card_bank_amount!)
        topUpCard_cashTransferAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.total_top_up_card_transfer_amount!)
        topUpCard_digitalWalletAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.total_top_up_card_wallet_amount!)
        
        //TỔNG PHIẾU THI
        receipt_totalAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.in_total_amount_by_addition_fee!)
        receipt_cashAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.in_cash_amount_by_addition_fee!)
        receipt_bankCardAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.in_bank_amount_by_addition_fee!)
        receipt_cashTransferAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.in_transfer_amount_by_addition_fee!)
        receipt_digitalWalletAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.in_wallet_amount_by_addition_fee!)
        
        //TỔNG PHIẾU CHI
        payment_TotalAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.out_total_amount_by_addition_fee!)
        payment_cashAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.out_cash_amount_by_addition_fee!)
        payment_tip.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.tip_amount!)
        payment_cashTransferAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.out_transfer_amount_by_addition_fee!)
        
        
        //TỔNG DOANH THU BÁN HÀNG
       
        sale_total.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.total_amount!)
        sale_cashAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.cash_amount!)
        sale_bankCardAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.bank_amount!)
        sale_cashTransferAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.transfer_amount!)
        sale_digitalWalletAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.wallet_amount!)
        sale_debtAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.debt_amount!)
        sale_topUpCardAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.total_top_up_used_amount!)
        sale_tip.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: workingSessionValue.tip_amount!)
        
        
        
        if let workingSession = self.workingSession{
          
            view_of_save_btn.isHidden = true
            textfield_money_500.isUserInteractionEnabled = false
            textfield_money_200.isUserInteractionEnabled = false
            textfield_money_100.isUserInteractionEnabled = false
            textfield_money_50.isUserInteractionEnabled = false
            textfield_money_20.isUserInteractionEnabled = false
            textfield_money_10.isUserInteractionEnabled = false
            textfield_money_5.isUserInteractionEnabled = false
            textfield_money_2.isUserInteractionEnabled = false
            textfield_money_1.isUserInteractionEnabled = false
            
            for cash in workingSession.cash_value{
                
                if cash.value == 500000 {
                  
                    textfield_money_500.insertText(cash.quantity.toString)
                    
                }else if cash.value == 200000{
                    
                    textfield_money_200.insertText(cash.quantity.toString)
                    
                }else if cash.value == 100000{
                    textfield_money_100.insertText(cash.quantity.toString)
                    
                }else if cash.value == 50000{
                    textfield_money_50.insertText(cash.quantity.toString)
                    
                }else if cash.value == 20000{
                    textfield_money_20.insertText(cash.quantity.toString)
                    
                }else if cash.value == 10000{
                    textfield_money_10.insertText(cash.quantity.toString)
                    
                }else if cash.value == 5000{
                    textfield_money_5.insertText(cash.quantity.toString)
                    
                }else if cash.value == 2000{
                    textfield_money_2.insertText(cash.quantity.toString)
                    
                }else if cash.value == 1000{
                    textfield_money_1.insertText(cash.quantity.toString)
                    
                }
            }
            
        }else{
            textfield_money_500.isUserInteractionEnabled = true
            textfield_money_200.isUserInteractionEnabled = true
            textfield_money_100.isUserInteractionEnabled = true
            textfield_money_50.isUserInteractionEnabled = true
            textfield_money_20.isUserInteractionEnabled = true
            textfield_money_10.isUserInteractionEnabled = true
            textfield_money_5.isUserInteractionEnabled = true
            textfield_money_2.isUserInteractionEnabled = true
            textfield_money_1.isUserInteractionEnabled = true
            
            view_of_save_btn.isHidden = false
        }
        

    }
    
    func validate(){
        
        _ = textfield_money_500.rx.text.map { $0 ?? "" }.bind(to: viewModel.money_500)

        // 500.000
        textfield_money_500.rx.controlEvent([.editingChanged]).asObservable().subscribe({ [unowned self] _ in
                if let money = self.textfield_money_500.text{
                    if(money.count > 0){
                        if(Int(money)! <= 1000){
                            self.lbl_amout_500.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float((500000 * Int(money)!)))//String(format: "%d", (500000 * Int(money)!))
                        }else{
                            self.lbl_amout_500.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: (500000 * 1000))
                            self.textfield_money_500.text = "1000"
                        }
                        
                    }else{
                        self.lbl_amout_500.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: (0))
                        self.textfield_money_500.text = "0"
                    }
                    self.txtTotalDepositCashAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(getRealAmount()))
                }else{
                    self.lbl_amout_500.text = "0"
                }
                var deposit_transfer_amount:Float = 0.0
                if let deposit_transfer_amount_txt = self.txtTotalReceipt.text?.trim().replacingOccurrences(of: ",", with: ""){
                    deposit_transfer_amount = Float(deposit_transfer_amount_txt)!
                }
                self.sum_difference.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(getRealAmount()) - deposit_transfer_amount)

             }).disposed(by: rxbag)
        
        // 200.000
        textfield_money_200.rx.controlEvent([.editingChanged]).asObservable().subscribe({ [unowned self] _ in
                if let money = self.textfield_money_200.text{
                    if(money.count > 0){
                        if(Int(money)! <= 1000){
                            self.lbl_amout_200.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float((200000 * Int(money)!)))//String(format: "%d", (500000 * Int(money)!))
                        }else{
                            self.lbl_amout_200.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: (200000 * 1000))
                            self.textfield_money_200.text = "1000"
                        }
                        
                    }else{
                        self.lbl_amout_200.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: (0))
                        self.textfield_money_200.text = "0"
                    }
                    self.txtTotalDepositCashAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(getRealAmount()))
                }else{
                    self.lbl_amout_200.text = "0"
                }
                var deposit_transfer_amount:Float = 0.0
                if let deposit_transfer_amount_txt = self.txtTotalReceipt.text?.trim().replacingOccurrences(of: ",", with: ""){
                    deposit_transfer_amount = Float(deposit_transfer_amount_txt)!
                }
                self.sum_difference.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(getRealAmount()) - deposit_transfer_amount)
             }).disposed(by: rxbag)
        
        // 100.000
        textfield_money_100.rx.controlEvent([.editingChanged])
            .asObservable().subscribe({ [unowned self] _ in
                if let money = self.textfield_money_100.text{
                    if(money.count > 0){
                        if(Int(money)! <= 1000){
                            self.lbl_amout_100.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float((100000 * Int(money)!)))
                        }else{
                            self.lbl_amout_100.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: (100000 * 1000))
                            self.textfield_money_100.text = "1000"
                        }
                        
                    }else{
                        self.lbl_amout_100.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: (0))
                        self.textfield_money_100.text = "0"
                    }
                    self.txtTotalDepositCashAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(getRealAmount()))
                    
                    
                }else{
                    self.lbl_amout_100.text = "0"
                }
                var deposit_transfer_amount:Float = 0.0
                if let deposit_transfer_amount_txt = self.txtTotalReceipt.text?.trim().replacingOccurrences(of: ",", with: ""){
                    deposit_transfer_amount = Float(deposit_transfer_amount_txt)!
                }
                self.sum_difference.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(getRealAmount()) - deposit_transfer_amount)
             }).disposed(by: rxbag)
        
        // 50.000
        textfield_money_50.rx.controlEvent([.editingChanged])
            .asObservable().subscribe({ [unowned self] _ in
                if let money = self.textfield_money_50.text{
                    if(money.count > 0){
                        if(Int(money.trim())! <= 1000){
                            self.lbl_amout_50.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float((50000 * Int(money.trim() )!)))
                        }else{
                            self.lbl_amout_50.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: (50000 * 1000))
                            self.textfield_money_50.text = "1000"
                        }
                        
                    }else{
                        self.lbl_amout_50.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: (0))
                        self.textfield_money_50.text = "0"
                    }
                    self.txtTotalDepositCashAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(getRealAmount()))
                }else{
                    self.lbl_amout_50.text = "0"
                }
                var deposit_transfer_amount:Float = 0.0
                if let deposit_transfer_amount_txt = self.txtTotalReceipt.text?.trim().replacingOccurrences(of: ",", with: ""){
                    deposit_transfer_amount = Float(deposit_transfer_amount_txt)!
                }
                self.sum_difference.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(getRealAmount()) - deposit_transfer_amount)
                
            }).disposed(by: rxbag)
        
        // 20.000
        textfield_money_20.rx.controlEvent([.editingChanged])
            .asObservable().subscribe({ [unowned self] _ in
                if let money = self.textfield_money_20.text?.trim().replacingOccurrences(of: ",", with: ""){
                    if(money.count > 0){
                        if(Int(money)! <= 1000){
                            self.lbl_amout_20.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float((20000 * Int(money)!)))
                        }else{
                            self.lbl_amout_20.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: (20000 * 1000))
                            self.textfield_money_20.text = "1000"
                        }
                        
                    }else{
                        self.lbl_amout_20.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: (0))
                        self.textfield_money_20.text = "0"
                    }
                    self.txtTotalDepositCashAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(getRealAmount()))
                }else{
                    self.lbl_amout_20.text = "0"
                }
                var deposit_transfer_amount:Float = 0.0
                if let deposit_transfer_amount_txt = self.txtTotalReceipt.text?.trim().replacingOccurrences(of: ",", with: ""){
                    deposit_transfer_amount = Float(deposit_transfer_amount_txt)!
                }
                self.sum_difference.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(getRealAmount()) - deposit_transfer_amount)
                
            }).disposed(by: rxbag)
        
        // 10.000
        textfield_money_10.rx.controlEvent([.editingChanged])
            .asObservable().subscribe({ [unowned self] _ in
                if let money = self.textfield_money_10.text?.trim().replacingOccurrences(of: ",", with: ""){
                    if(money.count > 0){
                        if(Int(money)! <= 1000){
                            self.lbl_amout_10.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float((10000 * Int(money)!)))
                        }else{
                            self.lbl_amout_10.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: (10000 * 1000))
                            self.textfield_money_10.text = "1000"
                        }
                        
                    }else{
                        self.lbl_amout_10.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: (0))
                        self.textfield_money_10.text = "0"
                    }
                    self.txtTotalDepositCashAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(getRealAmount()))
                }else{
                    self.lbl_amout_10.text = "0"
                }
                var deposit_transfer_amount:Float = 0.0
                if let deposit_transfer_amount_txt = self.txtTotalReceipt.text?.trim().replacingOccurrences(of: ",", with: ""){
                    deposit_transfer_amount = Float(deposit_transfer_amount_txt)!
                }
                self.sum_difference.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(getRealAmount()) - deposit_transfer_amount)
                
            }).disposed(by: rxbag)
        
        // 5.000
        textfield_money_5.rx.controlEvent([.editingChanged])
            .asObservable().subscribe({ [unowned self] _ in
                if let money = self.textfield_money_5.text?.trim().replacingOccurrences(of: ",", with: ""){
                    if(money.count > 0){
                        if(Int(money)! <= 1000){
                            self.lbl_amout_5.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float((5000 * Int(money)!)))
                        }else{
                            self.lbl_amout_5.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: (5000 * 1000))
                            self.textfield_money_5.text = "1000"
                        }
                        
                    }else{
                        self.lbl_amout_5.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: (0))
                        self.textfield_money_5.text = "0"
                    }
                    self.txtTotalDepositCashAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(getRealAmount()))
                    
                }else{
                    self.lbl_amout_5.text = "0"
                }
                var deposit_transfer_amount:Float = 0.0
                if let deposit_transfer_amount_txt = self.txtTotalReceipt.text?.trim().replacingOccurrences(of: ",", with: ""){
                    deposit_transfer_amount = Float(deposit_transfer_amount_txt)!
                }
                self.sum_difference.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(getRealAmount()) - deposit_transfer_amount)
                
            }).disposed(by: rxbag)
        
        // 2.000
        textfield_money_2.rx.controlEvent([.editingChanged])
            .asObservable().subscribe({ [unowned self] _ in
                if let money = self.textfield_money_2.text?.trim().replacingOccurrences(of: ",", with: ""){
                    if(money.count > 0){
                        if(Int(money)! <= 1000){
                            self.lbl_amout_2.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float((2000 * Int(money)!)))
                        }else{
                            self.lbl_amout_2.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: (2000 * 1000))
                            self.textfield_money_2.text = "1000"
                        }
                        
                    }else{
                        self.lbl_amout_2.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: (0))
                        self.textfield_money_2.text = "0"
                    }
                    self.txtTotalDepositCashAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(getRealAmount()))
                }else{
                    self.lbl_amout_2.text = "0"
                }
                var deposit_transfer_amount:Float = 0.0
                if let deposit_transfer_amount_txt = self.txtTotalReceipt.text?.trim().replacingOccurrences(of: ",", with: ""){
                    deposit_transfer_amount = Float(deposit_transfer_amount_txt)!
                }
                self.sum_difference.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(getRealAmount()) - deposit_transfer_amount)
                
            }).disposed(by: rxbag)
        
        // 1.000
        textfield_money_1.rx.controlEvent([.editingChanged])
            .asObservable().subscribe({ [unowned self] _ in
                if let money = self.textfield_money_1.text?.trim().replacingOccurrences(of: ",", with: ""){
                    if(money.count > 0){
                        if(Int(money)! <= 1000){
                            self.lbl_amout_1.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float((1000 * Int(money)!)))
                            
                        }else{
                            self.lbl_amout_1.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: (1000 * 1000))
                            self.textfield_money_1.text = "1000"
                        }
                        
                    }else{
                        self.lbl_amout_1.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: (0))
                        self.textfield_money_1.text = "0"
                    }
                    self.txtTotalDepositCashAmount.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(getRealAmount()))
                    
                }else{
                    self.lbl_amout_1.text = "0"
                }
                var deposit_transfer_amount:Float = 0.0
                if let deposit_transfer_amount_txt = self.txtTotalReceipt.text?.trim().replacingOccurrences(of: ",", with: ""){
                    deposit_transfer_amount = Float(deposit_transfer_amount_txt)!
                }
                self.sum_difference.text = Utils.stringVietnameseMoneyFormatWithNumber(amount: Float(getRealAmount()) - deposit_transfer_amount)
                
            }).disposed(by: rxbag)
      
    }
}
/*
 deposit_amount: tiền đặt cọc
 deposit_cash_amount: tiền mặt của tiền đặt cọc
 deposit_bank_amount: tiền thẻ của tiền đặt cọc
 deposit_transfer_amount: tiền chuyển khoản của tiền đặt cọc

 return_deposit_amount: tiền trả cọc
 return_deposit_cash_amount:  tiền mặt của tiền trả cọc
 return_deposit_bank_amount:  _____________________
 return_deposit_transfer_amount: chuyển khoản của tiền trả cọc   
 total_top_up_card_amount: Tổng nạp thẻ
 total_top_up_card_cash_amount: Tiền mặt của nạp thẻ
 total_top_up_card_bank_amount: Tiền thẻ của nạp thẻ
 total_top_up_card_transfer_amount: Tiền chuyển khoản của nạp thẻ  
 in_total_amount_by_addition_fee: Tổng phiếu thu
 in_cash_amount_by_addition_fee: Tiền mặt của phiếu thu
 in_bank_amount_by_addition_fee: Tiền thẻ của phiếu thu
 in_transfer_amount_by_addition_fee: Tiền chuyển khoản của phiếu thu


 out_total_amount_by_addition_fee: Tổng phiếu chi
 out_cash_amount_by_addition_fee: Tiền mặt của phiếu chi
 out_bank_amount_by_addition_fee:  Tiền thẻ của phiếu chi
 out_transfer_amount_by_addition_fee: Tiền chuyển khoản của phiếu chi


 // TỔNG DOANH THU BÁN HÀNG
 total_amount: Tổng doanh thu bán hàng
 cash_amount: Tổng tiền mặt  (DOANH THU BÁN HÀNG)
 bank_amount: Tổng tiền thẻ tín dụng của (DOANH THU BÁN HÀNG)
 transfer_amount: Tổng chuyển khoản của (DOANH THU BÁN HÀNG)
 debt_amount: Tổng nợ hàng của (DOANH THU BÁN HÀNG)
 total_top_up_used_amount:
 tip_amount: Tiền tiếp trả lại cho khách
 before_cash: tiền đầu ca
 total_cost_final: Tổng chi tiền mặt
 total_amount_final: Tổng thu tiền mặt
 total_receipt_amount_final: Tổng tiền mặt nhận

 wallet_amount:
 in_wallet_amount_by_addition_fee:
 out_wallet_amount_by_addition_fee:
 deposit_wallet_amount:
 return_deposit_wallet_amount:
 total_top_up_card_wallet_amount:
*/
