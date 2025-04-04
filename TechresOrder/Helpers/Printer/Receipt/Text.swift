//
//  Text.swift
//  Printer
//
//  Created by gix on 2023/2/2.
//

import Foundation

extension String: ReceiptItem {
    public func assemblePrintableData(_ profile: PrinterProfile) -> [UInt8] {
        guard let data = data(using: profile.encoding) else {
            return []
        }
        
        return [UInt8](data) + Command.CursorPosition.lineFeed.value
    }
}

public struct KVItem: ReceiptItem {
    public let k: String
    public let v: String
    
    public init(_ k: String, _ v: String) {
        self.k = k
        self.v = v
    }
    
    public func assemblePrintableData(_ profile: PrinterProfile) -> [UInt8] {
        var num = profile.maxWidthDensity / profile.fontDensity
        let string = k + v
        
        if k.count > 30{ //xử lý trường hợp tên quá dài
            var wordBreak:Int = 0
            if let position = k.suffix(k.count - 30).firstIndex(of:Character(" ")){
                wordBreak = k.distance(from: k.startIndex, to:position) + 1
            }
            
            let str1 = String(k.prefix(wordBreak))
            let str2 = v
            let breakStr = String(k.suffix(k.count - wordBreak))
            let string = str1 + str2
            
            for c in string {
                if (c >= "\u{2E80}" && c <= "\u{FE4F}") || c == "\u{FFE5}" {
                    num -= 2
                } else {
                    num -= 1
                }
            }
            
            var contents = stride(from: 0, to: num, by: 1).map{ _ in " " }
            contents.insert(str1, at: 0)
            contents.append(str2)
            contents.append(breakStr)
            return contents.joined().assemblePrintableData(profile)
            
        }else{
            for c in string {
                if (c >= "\u{2E80}" && c <= "\u{FE4F}") || c == "\u{FFE5}" {
                    num -= 2
                } else {
                    num -= 1
                }
            }
            
            var contents = stride(from: 0, to: num, by: 1).map{ _ in " " }
          
            contents.insert(k, at: 0)
            contents.append(v)
            return contents.joined().assemblePrintableData(profile)
        }
        
    }
}

public protocol DividingProvider {
    func character(for current: Int, total: Int) -> Character
}

extension Character: DividingProvider {
    public func character(for current: Int, total: Int) -> Character {
        return self
    }
}

public struct Dividing: ReceiptItem {
    let provider: DividingProvider
    
    public static func `default`(provider: Character = Character("-")) -> Dividing {
        return Dividing(provider: provider)
    }
    
    public func assemblePrintableData(_ profile: PrinterProfile) -> [UInt8] {
        let num = profile.maxWidthDensity / profile.fontDensity
        let content = stride(from: 0, to: num, by: 1).map{String(provider.character(for: $0, total: num)) }.joined()
        dLog(content.count)
        return content.assemblePrintableData(profile)
    }
}

/// Any other Text template(s)
///
///
