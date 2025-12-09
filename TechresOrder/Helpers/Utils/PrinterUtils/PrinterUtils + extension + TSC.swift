//
//  PrinterUtils + extension + PrintOrderOfFoodApp_onBackGround.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 23/08/2024.
//

import UIKit
import RealmSwift


extension PrinterUtils {
    
    func print(tscQueuedItem:TSCQueuedItem){

        setupWorkItem(tscQueuedItem:tscQueuedItem)
        
        backGroundQueue.async(execute: {
            if let tscWorkItem = self.tscWorkItem{
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3){
                    
                    tscWorkItem.connectionWork.perform()
                }
            }
        })
    }
    
    
    private func setupWorkItem(tscQueuedItem:TSCQueuedItem){
        
        let id = tscQueuedItem.id.stringValue
        let printer = tscQueuedItem.printer
        
        let connectionWork = DispatchWorkItem(block: { [self] in
            TSCPrinterUtility?.printMode = PRINT_MODE_(rawValue: tscQueuedItem.printMode.rawValue) ?? PRINT_MODE_.BACKGROUND_WITH_RETRY
            TSCPrinterUtility?.wifiConnect(tscQueuedItem.printer,id:["id":id,"isLastItem":true])
        })
        
        
        let printWork = DispatchWorkItem(block: { [self] in
            let images = tscQueuedItem.data.map{UIImage(data: $0) ?? UIImage()}
            printTSCData(printer:printer,id:id,images:images)
        })
        
        self.tscWorkItem = TSCWorkItem(objectId:tscQueuedItem.id,connectionWork: connectionWork, printWork: printWork)
    }
    
   
    
    func canncelTSCWorkItem(id:ObjectId,isErrorOccur:Bool){
        
        if let workItem = self.tscWorkItem{
            workItem.connectionWork.cancel()
            
            workItem.printWork.cancel()
            

            if workItem.connectionWork.isCancelled{
                TSCPrinterUtility?.wifiDisconnect()
            }
            
            if isErrorOccur{
                LocalDataBaseUtils.shared.UpdateRetryNumberOfTSCQueuedItem(id: id)
            }else{
                LocalDataBaseUtils.shared.UpdateTSCQueuedItemToFinish(id: workItem.objectId)
            }
            
            tscWorkItem = nil
        }

    }
    
    
    //=============================================================  PRINT TSC DATA  =====================================================================================================
    
    func printTSCData(printer:Printer,id:String,images:[UIImage]){
        
        var width:CGFloat = CGFloat(360)
        
        if printer.printer_paper_size == 60{
            width = CGFloat(430)
        }else if printer.printer_paper_size == 50{
            width = CGFloat(360)
        }else if printer.printer_paper_size == 40{
            width = CGFloat(300)
        }else{
            width = CGFloat(540)
        }
        
        
        var array:[UIImage] = []
        
        for img in images{
            
            let scaledRatio = width/img.size.width
            
            if let image = MediaUtils.resizeImage(image: img, targetSize:CGSize(width:width, height: img.size.height*scaledRatio)){
                array.append(image)
            }
        }

        let dictionaryItem:[String : Any] = ["id":id,"isLastItem": true]
        TSCPrinterUtility?.printPictures(array,withInfo: dictionaryItem)
    }

    
    func changeTextColorForTSCPrinter(printer:Printer,parentView:UIView,textColor:UIColor,bgColor:UIColor) {
     
        var fontSize:CGFloat = 22
        
        if printer.printer_paper_size == 60{
            fontSize = 25
        }else if printer.printer_paper_size == 50{
            fontSize = 25
        }else if printer.printer_paper_size == 40{
            fontSize = 25
        }else{
            fontSize = 12
        }
        
        parentView.backgroundColor = .white
        
        if parentView.subviews.count > 0{
            
            parentView.subviews.forEach{(view) in
                
                view.backgroundColor = bgColor
                
                if let label = view as? UILabel {
                    label.textColor = textColor
                   
                    switch label.tag{
                        case 1:
                            label.font = UIFont.systemFont(ofSize:fontSize,weight: .bold)

                        default:
                            label.font = UIFont.systemFont(ofSize:fontSize,weight:printer.printer_paper_size == 30 ? .semibold : .regular)
                    }
                }
                self.changeTextColorForTSCPrinter(printer:printer,parentView:view, textColor:textColor, bgColor:bgColor)
            }
        }
    }
    
    func getMaximumLineOfStampForTSCPrinter(printer:Printer) -> Int {
        var maximumLine = 0
        if printer.printer_paper_size == 60{
            maximumLine = 8
        }else if printer.printer_paper_size == 50{
            maximumLine = 7
        }else if printer.printer_paper_size == 40{
            maximumLine = 9
        }else{
            maximumLine = 9
        }
        return maximumLine
     
    }
    
    
}
