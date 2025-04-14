//
//  ChooseOptionViewModel.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 09/04/2025.
//

import UIKit
import RxRelay
import RxSwift
import RxDataSources


class ChooseOptionViewModel: NSObject {
    
    private(set) weak var view: ChooseOptionViewController?
    var item = BehaviorRelay<Food>(value: Food())
    
    public var sectionArray = BehaviorRelay<[SectionModel<FoodOptional,FoodAddition>]>(value:[
        SectionModel(model: FoodOptional(),items: [])
    ])

    func bind(view: ChooseOptionViewController){
        self.view = view
    }
   
    

    
    func setSection(section:SectionModel<FoodOptional,FoodAddition>,indexPath:IndexPath) {
    
        var sections = sectionArray.value
        sections[indexPath.section] = section
        self.sectionArray.accept(sections)

    }
    
    
}
