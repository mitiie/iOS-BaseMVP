//
//  NSNumber+Exts.swift
//  SwiftCommon
//
//  Created by mitie on 15/02/2023.
//

import Foundation

extension NSNumber {
    
    public func formatNumber(decimalSeparator: String = ".", groupingSeparator: String = ",") -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.decimalSeparator = decimalSeparator
        numberFormatter.groupingSeparator = groupingSeparator
        if self.intValue < 1000000 {
            if let stringValue = numberFormatter.string(from: self) {
                return stringValue
            }
            return String(format: "%d", self.intValue)
        }
        if let stringValue = numberFormatter.string(from: self) {
            return String(format: "%@M", stringValue, self.doubleValue/1000000.0)
        }
        return String(format: "%.1fM", self.doubleValue/1000000.0)
    }
    
}
