//
//  UIButton+Exts.swift
//  SwiftCommon
//
//  Created by mitie on 13/02/2023.
//

import UIKit

extension UIButton {
    
    public func changeTint(_ image: UIImage?, _ tintColor: UIColor) {
        let imageTint = image?.withRenderingMode(.alwaysTemplate)
        self.setImage(imageTint, for: .normal)
        self.tintColor = tintColor
    }
    
}
