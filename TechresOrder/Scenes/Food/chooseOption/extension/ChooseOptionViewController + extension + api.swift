//
//  ChooseOptionViewController + extension + api.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 09/06/2025.
//

import UIKit
import ObjectMapper
import RxSwift
import RxRelay

extension ChooseOptionViewController{
    
    func notes(){
        viewModel.notes().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
              
                if let notes  = Mapper<Note>().mapArray(JSONObject: response.data){
    
                    self.tagListView.addTags(notes.map{$0.content})
                    
                    self.height_of_tagListView.constant = self.tagListView.intrinsicContentSize.height

                }
            }else{
                dLog(response.message)
            }
        }).disposed(by: rxbag)
        
    }
    
    func notesByFood(){
        viewModel.notesByFood().subscribe(onNext: { (response) in
            if(response.code == RRHTTPStatusCode.ok.rawValue){
             
                if let notes  = Mapper<Note>().mapArray(JSONObject: response.data){
                    self.tagListView.addTags(notes.map{$0.note})
                    self.height_of_tagListView.constant = self.tagListView.intrinsicContentSize.height
                }
            }
        }).disposed(by: rxbag)

    }
}
