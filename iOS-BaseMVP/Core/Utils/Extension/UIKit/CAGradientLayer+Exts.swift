//
//  CAGradientLayer+Exts.swift
//  iOS-BaseMVP
//
//  Created by mitie on 6/4/26.
//

import UIKit

extension CAGradientLayer {
    static func horizontal(colors: [UIColor]) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.colors      = colors.map(\.cgColor)
        layer.startPoint  = CGPoint(x: 0, y: 0.5)
        layer.endPoint    = CGPoint(x: 1, y: 0.5)
        return layer
    }
}
