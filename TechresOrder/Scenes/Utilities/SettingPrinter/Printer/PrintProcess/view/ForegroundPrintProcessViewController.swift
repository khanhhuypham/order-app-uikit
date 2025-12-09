//
//  ForegroundPrintProcessViewController.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 11/9/25.
//

import UIKit

class ForegroundPrintProcessViewController: UIViewController {
    
    
    @IBOutlet weak var progressView: UIView!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var lbl_already_printed_number: UILabel!

    var printers:[Printer] = []
    
    let POSPrinterUtility = CustomPOSPrinter.shared()
    let TSCPrinterUtility = TSCPrinter.shared()
    let BLEPrinterUtility = BLEPrinter.shared()
  
    var progressBarTimer: Timer!
    var progressPercent: Float = 0.0
    var viewModel = ForegroundPrintProcessViewModel()
    var completeHandler:(()->Void)? = nil

    let textColor:UIColor = .systemGray4
    //================================================================

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.bind(view: self)
        firstSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        PrinterUtils.shared.stopPrintBackGround()
        
        for POSWorkItem in LocalDataBaseUtils.shared.getForegroundPOSQueuedItem() {
            setupPOSWorkItem(item: POSWorkItem)
        }
        
        for TSCWorkItem in LocalDataBaseUtils.shared.getForegroundTSCQueuedItem() {
            setupTSCWorkItem(item: TSCWorkItem)
        }
        dLog(LocalDataBaseUtils.shared.getForegroundPOSQueuedItem().count)
        dLog(LocalDataBaseUtils.shared.getForegroundPOSQueuedItem())
        
        dLog(LocalDataBaseUtils.shared.getForegroundTSCQueuedItem().count)
        dLog(LocalDataBaseUtils.shared.getForegroundTSCQueuedItem())
        
        viewModel.calculatePrintNumber()
        
        if let posWorkItem = viewModel.POSWorkItems.value.first{
            posWorkItem.connectionWork.perform()
        }

        if let TSCEWorkItem = viewModel.TSCWorkItems.value.first{
            TSCEWorkItem.connectionWork.perform()
        }
        
        if let BLEWorkItem = viewModel.BLEWorkItem.value {
            BLEWorkItem.connectionWork.perform()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        POSPrinterUtility?.wifiDisconnect()
        TSCPrinterUtility?.wifiDisconnect()
        BLEPrinterUtility?.bleManager.disconnectRootPeripheral()
        NotificationCenter.default.removeObserver(self)
        PrinterUtils.shared.performPrintBackGround()
    
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if !viewModel.unconnectedPrinters.value.isEmpty{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: PRINTER_NOTIFI.UNCONNECTED_PRINTERS),object: viewModel.unconnectedPrinters.value)
        }
    }
        
    @IBAction func actionBack(_ sender: Any) {
        dismiss(animated: true)
    }


}
