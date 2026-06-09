//
//  UITextField+Exts.swift
//  SwiftCommon
//
//  Created by mitie on 13/02/2023.
//

import Foundation
import UIKit

extension UITextField {
    /// Set placeholder text and its color
    public func config(placeholder value: String, color: UIColor) {
        self.attributedPlaceholder = NSAttributedString(string: value, attributes: [ NSAttributedString.Key.foregroundColor : color])
    }
    
    public func configPlaceHolder(color: UIColor) {
        attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : color])
    }
}
