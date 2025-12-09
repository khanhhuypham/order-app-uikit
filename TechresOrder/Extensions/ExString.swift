//
//  ExString.swift
//  ORDER
//
//  Created by Pham Khanh Huy on 05/07/2023.
//

import UIKit

extension String {
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }


    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
    
    //block Vietnamese
    var folded: String {
        return self.folding(options: .diacriticInsensitive, locale: nil)
                .replacingOccurrences(of: "đ", with: "d")
                .replacingOccurrences(of: "Đ", with: "D")
    }
    
    
    func width(withHeight constrainedHeight: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: constrainedHeight)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.width)
    }
    
    func height(withWidth constrainedWidth: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: constrainedWidth, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.height)
    }
    
    
    
}
