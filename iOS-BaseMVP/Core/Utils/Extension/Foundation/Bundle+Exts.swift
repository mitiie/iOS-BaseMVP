//
//  Bundle+Exts.swift
//  SwiftCommon
//
//  Created by mitie on 13/02/2023.
//

import Foundation

extension Bundle {
    public static func custom(from identifier: String) -> Bundle? {
        let bundle = Bundle.init(identifier: identifier)
        return bundle
    }
    
    public var buildNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    public var versionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}

extension NSObject {
    public var className: String {
        return String(describing: type(of: self)).components(separatedBy: ".").last ?? ""
    }
    
    public class var className: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
}

