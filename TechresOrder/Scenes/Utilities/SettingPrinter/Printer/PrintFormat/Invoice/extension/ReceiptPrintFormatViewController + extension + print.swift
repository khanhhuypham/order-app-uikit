//
//  ReceiptPrintFormatViewController + extension + print.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 26/12/2023.
//

import UIKit

extension ReceiptPrintFormatViewController {
    
    func performWorkItem(printer:Printer){

        if let image = renderImage(){

            _ = LocalDataBaseUtils.shared.saveToLocalDataBase(
                order:self.order!,
                printer: printer,
                img: image,
                printItems: [],
                isLastItem: true,
                printMode: printMode
            )
        }
        
    }
  
    private func renderImage() -> UIImage?{
        guard let screenImg = MediaUtils.captureViewScreenshot(viewToCapture: contentView) else{
            return nil
        }
       
        let width = CGFloat(570)
        let scaledRatio = width/screenImg.size.width
	
        return MediaUtils.resizeImage(image: screenImg, targetSize:CGSize(width: screenImg.size.width*scaledRatio, height: screenImg.size.height*scaledRatio))
    }
    
    

}

 
