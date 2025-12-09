//
//  PrinterUtils.swift
//  Techres - Order
//
//  Created by pham khanh huy on 31/03/2022.
//  Copyright © 2022 vn.techres.sale. All rights reserved.
//

import UIKit
import JonAlert


class PrinterUtils:NSObject {


    let POSPrinterUtility = CustomPOSPrinter.shared()
    let TSCPrinterUtility = TSCPrinter.shared()
    let BLEPrinterUtility = BLEPrinter.shared()
    let backGroundQueue = DispatchQueue.global(qos: .userInteractive)
    
    var workItems:[WIFIWorkItem] = []
    var tscWorkItem:TSCWorkItem? = nil
    
    var printTimer: Timer?
    var deleteTimer: Timer?
    
    
    static let shared: PrinterUtils = {
        let printerUtils = PrinterUtils()
        return printerUtils
    }()

    override init() {
        super.init()
        NotificationCenter.default.addObserver(self,selector:#selector(connectPrinterSuccessfully(_:)),name: NSNotification.Name(PRINTER_NOTIFI.BACKGROUND_CONNECT_SUCCESS),object: nil)
        NotificationCenter.default.addObserver(self,selector:#selector(connectPrinterFail(_:)),name: NSNotification.Name(PRINTER_NOTIFI.BACKGROUND_CONNECT_FAIL),object: nil)
        NotificationCenter.default.addObserver(self,selector:#selector(printSuccessFully(_:)),name: NSNotification.Name(PRINTER_NOTIFI.BACKGROUND_PRINT_SUCCESS),object: nil)
        NotificationCenter.default.addObserver(self,selector:#selector(printFail(_:)),name: NSNotification.Name(PRINTER_NOTIFI.BACKGROUND_PRINT_FAIL),object: nil)
        NotificationCenter.default.addObserver(self,selector:#selector(getUnconnectedPrinters(_:)),name: NSNotification.Name(PRINTER_NOTIFI.UNCONNECTED_PRINTERS),object: nil)
        
        
        
        NotificationCenter.default.addObserver(self,selector:#selector(connectPrinterSuccessfully(_:)),name: NSNotification.Name(PRINTER_NOTIFI.CONNECT_SUCCESS),object: nil)

        
        BLEPrinterUtility?.bleManager.delegate = self
    }
    
    deinit{
        printTimer?.invalidate()
        printTimer = nil
        
        deleteTimer?.invalidate()
        deleteTimer = nil
        NotificationCenter.default.removeObserver(self)
    }
    
  
   
}
