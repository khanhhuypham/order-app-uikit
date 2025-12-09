//
//  BrandViewModel.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 16/01/2023.
//

import UIKit
import RxSwift
import RxRelay

class BranchViewModel: BaseViewModel {
    private(set) weak var view: BranchViewController?

   
    public var key_word : BehaviorRelay<String> = BehaviorRelay(value: "")
    public var status : BehaviorRelay<Int> = BehaviorRelay(value: -1)
    public var brand : BehaviorRelay<Brand> = BehaviorRelay(value: Brand())
    
    // MARK: - Variable -
    // listing data array observe by rxswift
    public var dataArray : BehaviorRelay<[Branch]> = BehaviorRelay(value: [])
    
    
    func bind(view: BranchViewController){
        self.view = view

    }
}
extension BranchViewModel{
    func getBranches() -> Observable<APIResponse> {
        return appServiceProvider.rx.request(.branches(brand_id: brand.value.id, status: ACTIVE))
               .filterSuccessfulStatusCodes()
               .mapJSON().asObservable()
               .showAPIErrorToast()
               .mapObject(type: APIResponse.self)
    }
    

}
