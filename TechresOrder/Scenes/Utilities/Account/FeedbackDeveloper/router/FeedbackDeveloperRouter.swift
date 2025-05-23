//
//  FeedbackDeveloperRouter.swift
//  TechresOrder
//
//  Created by Kelvin on 12/02/2023.
//

import UIKit

class FeedbackDeveloperRouter {
    var viewController: UIViewController{
        return createViewController()
    }
    
    private var sourceView:UIViewController?
    
    private func createViewController()-> UIViewController {
        let view = FeedbackDeveloperViewController(nibName: "FeedbackDeveloperViewController", bundle: Bundle.main)
        return view
    }
    
    func setSourceView(_ sourceView:UIViewController?){
        guard let view = sourceView else {fatalError("Error Desconocido")}
        self.sourceView = view
    }
    func navigateToPopViewController(){
        sourceView?.navigationController?.popViewController(animated: true)
    }
}
