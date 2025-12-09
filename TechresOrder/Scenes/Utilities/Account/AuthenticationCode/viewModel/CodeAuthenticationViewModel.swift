//
//  CodeAuthenticationViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 13/8/25.
//

import UIKit
import RxRelay
class CodeAuthenticationViewModel: NSObject {
    
    private(set) weak var view: CodeAuthenticationViewController?
    

    public var dataArray : BehaviorRelay<[AuthenticationToken]> = BehaviorRelay(value: [])
   
    

    func bind(view: CodeAuthenticationViewController){
        self.view = view

    }
    
  
    

}
