//
//  MathUtils.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 24/01/2024.
//

import UIKit

class MathUtils: NSObject {
    static func isInteger(number: Double) -> Bool {
        return floor(number) == number
    }
    
    static func isInteger(number: Float) -> Bool {
        return floor(number) == number
    }

    
 
    
    static func convertToMoney(integer:Int? = nil,float:Float? = nil, double:Double? = nil , unit_name :String = "") -> String{
        let number = NumberFormatter()
        number.usesGroupingSeparator = true
        number.groupingSeparator = ","
        number.groupingSize = 3
        return ""
        
    }
    
    

    
    static func convertStringToDoubleString(str:String) -> String{
        
        var result = str.replacingOccurrences(of: ",", with: ".")
        
        
        if let firstDot = result.firstIndex(of: ".") {

            let index = result.index(firstDot, offsetBy: 1)

            for i in result.indices[index..<result.endIndex] {
                if result[i] == "."{
                    result.remove(at: i)
                }
            }
            
        }
        
        
        if let lastDot = result.lastIndex(where: {$0 == "."}){

            if result[lastDot...].count > 3 {
                let index = str.index(lastDot, offsetBy: 3)
                result.removeSubrange(index..<result.endIndex)
            }
            
        }
        
        return result
    }
        
    

    

    
    
}
