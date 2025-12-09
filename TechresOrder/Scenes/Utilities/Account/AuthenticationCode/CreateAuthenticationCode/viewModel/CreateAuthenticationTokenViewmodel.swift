//
//  CreateAuthenticationTokenViewmodel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 13/8/25.
//

import UIKit
import RxRelay
class CreateAuthenticationTokenViewmodel: NSObject {

    private(set) weak var view: CreateAuthenticationTokenViewController?
    

    public var dataArray : BehaviorRelay<[AuthenticationToken]> = BehaviorRelay(value: [])
   
    

    func bind(view: CreateAuthenticationTokenViewController){
        self.view = view

    }
    
  
}
