//
//  CommonLabel.swift
//  DIYWallpaper
//
//  Created by mitie on 4/3/26.
//

import UIKit
import Foundation

class CommonLabel: UILabel {
    @IBInspectable var size: CGFloat = 16.0 {
        didSet { updateStyle() }
    }
    
    @IBInspectable var weight: String = FontWeight.regular.rawValue {
        didSet { updateStyle() }
    }
    
    @IBInspectable var color: String = AppColor.neutral_700.rawValue {
        didSet { updateStyle() }
    }
    
    @IBInspectable var colorAlpha: CGFloat = 1.0 {
        didSet { updateStyle() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        updateStyle()
    }
    
    func updateStyle() {
        let _weight = FontWeight(rawValue: weight) ?? .regular
        let _color = AppColor(rawValue: color) ?? .neutral_700
        self.font = UIFont.custom(size, _weight)
        self.textColor = _color.color.withAlphaComponent(colorAlpha)
    }
}
