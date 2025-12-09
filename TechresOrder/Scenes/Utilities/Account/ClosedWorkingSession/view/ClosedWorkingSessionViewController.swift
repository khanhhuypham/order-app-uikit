//
//  ClosedWorkingSessionViewController.swift
//  TechresOrder
//
//  Created by Kelvin on 22/02/2023.
//

import UIKit

class ClosedWorkingSessionViewController: BaseViewController {
    var viewModel = ClosedWorkingSessionViewModel()
    var router = ClosedWorkingSessionRouter()
    var workingSession:WorkingSessionValue? = nil
    var delegate: TechresDelegate?
     
    
    @IBOutlet weak var txtTotalDepositCashAmount: UILabel!
    
    @IBOutlet weak var textfield_money_500: UITextField!
    @IBOutlet weak var textfield_money_200: UITextField!
    @IBOutlet weak var textfield_money_100: UITextField!
    @IBOutlet weak var textfield_money_50: UITextField!
    @IBOutlet weak var textfield_money_20: UITextField!
    @IBOutlet weak var textfield_money_10: UITextField!
    @IBOutlet weak var textfield_money_5: UITextField!
    @IBOutlet weak var textfield_money_2: UITextField!
    @IBOutlet weak var textfield_money_1: UITextField!
    
    
    @IBOutlet weak var lbl_amout_500: UILabel!
    @IBOutlet weak var lbl_amout_200: UILabel!
    @IBOutlet weak var lbl_amout_100: UILabel!
    @IBOutlet weak var lbl_amout_50: UILabel!
    @IBOutlet weak var lbl_amout_20: UILabel!
    @IBOutlet weak var lbl_amout_10: UILabel!
    @IBOutlet weak var lbl_amout_5: UILabel!
    @IBOutlet weak var lbl_amout_2: UILabel!
    @IBOutlet weak var lbl_amout_1: UILabel!
    
    
    
    //Tổng hợp
    @IBOutlet weak var txtTotalReceipt: UILabel! //
    @IBOutlet weak var sum_totalCashReceived: UILabel! // total cash received
    @IBOutlet weak var sum_cashAmountOfFirstShift: UILabel! //cash amount of first shift
    @IBOutlet weak var sum_totalRevenue: UILabel! //total revenue
    @IBOutlet weak var sum_Receipt: UILabel! // receipt
    @IBOutlet weak var sum_deposit: UILabel! //deposit
    @IBOutlet weak var sum_topUpCardAmount: UILabel! // cash of
    @IBOutlet weak var sum_totalCashPaid: UILabel! //total amount spent
    @IBOutlet weak var sum_returnedDeposit: UILabel! // returned deposit
    @IBOutlet weak var sum_payment: UILabel!    // total amount paid
    @IBOutlet weak var sum_tip: UILabel!  //tip
    @IBOutlet weak var sum_difference: UILabel!
    
    
    //Tiền đặt cọc
    @IBOutlet weak var deposit_totalAmount: UILabel! // total deposit
    @IBOutlet weak var deposit_cashAmount: UILabel! // cash deposit
    @IBOutlet weak var deposit_bankCardAmount: UILabel! // bankcard deposit
    @IBOutlet weak var deposit_cashTransferAmount: UILabel! // cash tranfer deposit
    @IBOutlet weak var deposit_digitalWalletAmount: UILabel!  //digital wallet deposit
    
    //Tiền trả cọc
    @IBOutlet weak var returnedDeposit_totalAmount: UILabel! // total returned deposit
    @IBOutlet weak var returnedDeposit_cashAmount: UILabel! // cash returned deposit
    @IBOutlet weak var returnedDeposit_cashTransferAmount: UILabel! // cash tranfer returned deposit
    
    //Tiền Nạp thẻ
    @IBOutlet weak var topUpCard_totalAmount: UILabel!
    @IBOutlet weak var topUpCard_cashAmount: UILabel!
    @IBOutlet weak var topUpCard_bankCardAmount: UILabel!
    @IBOutlet weak var topUpCard_cashTransferAmount: UILabel!
    @IBOutlet weak var topUpCard_digitalWalletAmount: UILabel!
    
    //Phiếu thu
    @IBOutlet weak var receipt_totalAmount: UILabel! // total amount receieved
    @IBOutlet weak var receipt_cashAmount: UILabel! // cash amount receieved
    @IBOutlet weak var receipt_bankCardAmount: UILabel! // bank card amount receieved
    @IBOutlet weak var receipt_cashTransferAmount: UILabel! // cash transfer amount receieved
    @IBOutlet weak var receipt_digitalWalletAmount: UILabel!  //digital wallet amount receieved
    
    
    //Phiếu chi
    @IBOutlet weak var payment_TotalAmount: UILabel!        // total amount paid
    @IBOutlet weak var payment_cashAmount: UILabel!         // cash amount paid
    @IBOutlet weak var payment_cashTransferAmount: UILabel!  // cash transfer amount paid
    @IBOutlet weak var payment_tip: UILabel!              // bankcard amount paid
  
                                    
    
    //Bán hàng
    @IBOutlet weak var sale_total: UILabel!
    @IBOutlet weak var sale_cashAmount: UILabel!
    @IBOutlet weak var sale_bankCardAmount: UILabel!
    @IBOutlet weak var sale_cashTransferAmount: UILabel!
    @IBOutlet weak var sale_digitalWalletAmount: UILabel!
    @IBOutlet weak var sale_debtAmount: UILabel!
    @IBOutlet weak var sale_topUpCardAmount: UILabel!
    @IBOutlet weak var sale_tip: UILabel!
    @IBOutlet weak var view_of_save_btn: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.bind(view: self, router: router)
        validate()
        if let workingSession = self.workingSession{
            mapData(workingSessionValue: workingSession)
            
        }else{
                    
            self.workingSessionValue()
            self.checkWorkingSession()
        }
        
       
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @IBAction func actionBack(_ sender: Any) {
        
        if permissionUtils.Cashier && viewModel.checkWorkingSession.value.type == EXPIRED_SHIFT{
            logout()
        }else{
            viewModel.makePopViewController()
        }
        
    }
    
   
    @IBAction func actionCloseWorkingSession(_ sender: Any) {
        //CALL API CLOSED WORKING SESSION....
        var closeWorkingSessionRequest = CloseWorkingSessionRequest.init()
        closeWorkingSessionRequest.cash_value = setupRealAmount()
        closeWorkingSessionRequest.real_amount = getRealAmount()
        viewModel.closeWorkingSessionRequest.accept(closeWorkingSessionRequest)
        self.closeWorkingSession()
    }
    
    
    func setupRealAmount() -> [CashValue]{
        var cash_values = [CashValue]()
        //500
        if(textfield_money_500.text!.count > 0){
            var cashValue = CashValue()
            cashValue.value = 500000
            cashValue.quantity = Int(textfield_money_500.text ?? "0")!
            cash_values.append(cashValue)
        }else{
            var cashValue = CashValue()
            cashValue.value = 500000
            cashValue.quantity = 0
            cash_values.append(cashValue)
        }
        //200
        if(textfield_money_200.text!.count > 0){
            var cashValue = CashValue()
            cashValue.value = 200000
            cashValue.quantity = Int(textfield_money_200.text ?? "0")!
            cash_values.append(cashValue)
        }else{
            var cashValue = CashValue()
            cashValue.value = 200000
            cashValue.quantity = 0
            cash_values.append(cashValue)
        }
        //100
        if(textfield_money_100.text!.count > 0){
            var cashValue = CashValue()
            cashValue.value = 100000
            cashValue.quantity = Int(textfield_money_100.text ?? "0")!
            cash_values.append(cashValue)
        }else{
            var cashValue = CashValue()
            cashValue.value = 100000
            cashValue.quantity = 0
            cash_values.append(cashValue)
        }
        //50
        if(textfield_money_50.text!.count > 0){
            var cashValue = CashValue()
            cashValue.value = 50000
            cashValue.quantity = Int(textfield_money_50.text ?? "0")!
            cash_values.append(cashValue)
        }else{
            var cashValue = CashValue()
            cashValue.value = 50000
            cashValue.quantity = 0
            cash_values.append(cashValue)
        }
        
        //20
        if(textfield_money_20.text!.count > 0){
            var cashValue = CashValue()
            cashValue.value = 20000
            cashValue.quantity = Int(textfield_money_20.text ?? "0")!
            cash_values.append(cashValue)
        }else{
            var cashValue = CashValue()
            cashValue.value = 20000
            cashValue.quantity = 0
            cash_values.append(cashValue)
        }
        
        //10
        if(textfield_money_10.text!.count > 0){
            var cashValue = CashValue()
            cashValue.value = 10000
            cashValue.quantity = Int(textfield_money_10.text ?? "0")!
            cash_values.append(cashValue)
        }else{
            var cashValue = CashValue()
            cashValue.value = 10000
            cashValue.quantity = 0
            cash_values.append(cashValue)
        }
        //5
        if(textfield_money_5.text!.count > 0){
            var cashValue = CashValue()
            cashValue.value = 5000
            cashValue.quantity = Int(textfield_money_5.text ?? "0")!
            cash_values.append(cashValue)
        }else{
            var cashValue = CashValue()
            cashValue.value = 5000
            cashValue.quantity = 0
            cash_values.append(cashValue)
        }
        
        //2
        if(textfield_money_2.text!.count > 0){
            var cashValue = CashValue()
            cashValue.value = 2000
            cashValue.quantity = Int(textfield_money_2.text ?? "0")!
            cash_values.append(cashValue)
        }else{
            var cashValue = CashValue()
            cashValue.value = 2000
            cashValue.quantity = 0
            cash_values.append(cashValue)
        }
        
        //1
        if(textfield_money_1.text!.count > 0){
            var cashValue = CashValue()
            cashValue.value = 1000
            cashValue.quantity = Int(textfield_money_1.text ?? "0")!
            cash_values.append(cashValue)
        }else{
            var cashValue = CashValue()
            cashValue.value = 1000
            cashValue.quantity = 0
            cash_values.append(cashValue)
        }
       return cash_values
    }
    func getRealAmount()->Int{
        return Int(lbl_amout_500.text!.trim().replacingOccurrences(of: ",", with: ""))!
        + Int(lbl_amout_200.text!.trim().replacingOccurrences(of: ",", with: ""))!
        + Int(lbl_amout_100.text!.trim().replacingOccurrences(of: ",", with: ""))!
        + Int(lbl_amout_50.text!.trim().replacingOccurrences(of: ",", with: ""))!
        + Int(lbl_amout_20.text!.trim().replacingOccurrences(of: ",", with: ""))!
        + Int(lbl_amout_10.text!.trim().replacingOccurrences(of: ",", with: ""))!
        + Int(lbl_amout_5.text!.trim().replacingOccurrences(of: ",", with: ""))!
        + Int(lbl_amout_2.text!.trim().replacingOccurrences(of: ",", with: ""))!
        + Int(lbl_amout_1.text!.trim().replacingOccurrences(of: ",", with: ""))!
    }
    
}
