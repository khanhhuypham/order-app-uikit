//
//  ReceiptPrintFormatViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 18/07/2024.
//

import UIKit
import RxSwift
import RxRelay
class ReceiptPrintFormatViewModel: BaseViewModel {
    private(set) weak var view: ReceiptPrintFormatViewController?
    

    func bind(view: ReceiptPrintFormatViewController){
        self.view = view
    }
    
}
