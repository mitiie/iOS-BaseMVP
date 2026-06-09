//
//  String+Exts.swift
//  SwiftCommon
//
//  Created by mitie on 13/02/2023.
//

import UIKit

extension String {
    
    public var length: Int {
        return count
    }
    
    public var isNumeric: Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }
    
    public var hasWhitespace: Bool {
        guard !isEmpty else { return true }
        
        let whitespaceChars = NSCharacterSet.whitespacesAndNewlines
        
        return self.unicodeScalars
            .filter { whitespaceChars.contains($0) }
            .count > 0
    }
    
    public subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    public subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
    public func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    public func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }
    
    public func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }
    
    public func width(maxHeight: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: maxHeight)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    public func height(maxWidth: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    public func encodeUrl() -> String? {
        return self.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
    }
    
    public func decodeUrl() -> String? {
        return self.removingPercentEncoding
    }
    
    public func upperFirstCharacter() -> String {
        if self.isEmpty {
            return self
        }
        let first = self.substring(to: 1)
        let others = self.substring(from: 1)
        return "\(first.uppercased())\(others.lowercased())"
    }
    
    public func upperAlphasCharacter() -> String {
        if self.isEmpty {
            return self
        }
        let comps = self.condensingWhitespace().components(separatedBy: " ")
        return comps.map({ $0.upperFirstCharacter() }).joined(separator: " ")
    }
    
    public func condensingWhitespace() -> String {
        return self.components(separatedBy: .whitespacesAndNewlines).filter({ !$0.isEmpty }).joined(separator: " ")
    }
    
    public func contains(_ string: String) -> Bool {
        return range(of: string, options: [.literal, .caseInsensitive, .diacriticInsensitive]) != nil
    }
    
    public func contains(_ strings: [String]) -> Bool {
        guard strings.count > 0 else {
            return false
        }
        var allContained = true
        for string in strings {
            allContained = allContained && contains(string)
        }
        return allContained
    }
}

//MARK: - Convert to number -
extension String {
    public var intValue: Int {
        return Int((self as NSString).intValue)
    }
    
    public var floatValue: CGFloat {
        return CGFloat((self as NSString).floatValue)
    }
    
    public var doubleValue: Double {
        return Double((self as NSString).doubleValue)
    }
}

extension RangeExpression where Bound == String.Index  {
    public func nsRange<S: StringProtocol>(in string: S) -> NSRange { .init(self, in: string) }
}

extension String {
    public func getRangesExist(from: String, _ ranges: [NSRange]?, _ lastRange: NSRange?) -> [NSRange]? {
        var values: [NSRange] = []
        if let ranges = ranges {
            values.append(contentsOf: ranges)
        }
        if var range = self.range(of: from)?.nsRange(in: self) {
            if range.location != NSNotFound {
                if (range.location + range.length) > self.count {
                    range.location = self.count - range.length
                }

                let toIndex = range.location + range.length
                let newString = self.substring(from: toIndex > self.count ? self.count : toIndex)

                if let lastRange = lastRange {
                    range.location += (lastRange.location + lastRange.length)
                }
                values.append(range)

                return newString.getRangesExist(from: from, values, range)
            }
        }
        return values
    }
}

extension String {
    var toDictionary: [String: Any]? {
        guard let data = self.data(using: .utf8) else { return nil }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            return json as? [String: Any]
        } catch {
            print("JSON parse error:", error)
            return nil
        }
    }
}

extension Dictionary {
    var toString: String? {
        guard JSONSerialization.isValidJSONObject(self) else { return nil }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: [])
            return String(data: data, encoding: .utf8)
        } catch {
            print("JSON stringify error:", error)
            return nil
        }
    }
}
