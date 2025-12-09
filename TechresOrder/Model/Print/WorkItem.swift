//
//  WorkItem.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 29/06/2024.
//

import UIKit
import RealmSwift


struct TSCWorkItem {
    
    var objectId:ObjectId? = nil
    var orderId:Int = 0
    var printer:Printer? = nil
    var image:[UIImage] = []
    var islastItem:Bool = true
    var connectionWork:DispatchWorkItem
    var printWork:DispatchWorkItem
}




struct WIFIWorkItem {
    var objectId:ObjectId? = nil
    var orderId:Int = 0
    var image:UIImage? = nil
    var printer:Printer? = nil
    var printItems:[Food]? = nil
    var islastItem:Bool? = nil
    var connectionWork:DispatchWorkItem
    var printWork:DispatchWorkItem
    

    
}


struct BLEWorkItem {
    var id:UUID? = nil
    var connectionWork:DispatchWorkItem
    var printWork:DispatchWorkItem
    var image:[UIImage] = []

}
















