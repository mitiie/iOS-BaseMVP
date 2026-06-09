//
//  CGValue+Exts.swift
//  iOS-BaseMVP
//
//  Created by mitie on 6/4/26.
//

import UIKit
import Foundation

extension CGRect {
    static func convertFromDict(_ json: [String: Any]) -> CGRect {
        guard let dict = json as? [String: CGFloat],
              let x = dict["x"],
              let y = dict["y"],
              let width = dict["width"],
              let height = dict["height"] else {
            return .zero
        }
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    var jsonObject: [String: CGFloat] {
        return [
            "x": origin.x,
            "y": origin.y,
            "width": size.width,
            "height": size.height
        ]
    }
}

extension CGPoint {
    static func convertFromDict(_ json: [String: Any]) -> CGPoint {
        guard let dict = json as? [String: CGFloat],
              let x = dict["x"],
              let y = dict["y"] else {
            return .zero
        }
        
        return CGPoint(x: x, y: y)
    }
    
    var jsonObject: [String: CGFloat] {
        return [
            "x": x,
            "y": y
        ]
    }
}

extension CGSize {
    static func convertFromDict(_ json: [String: Any]) -> CGSize {
        guard let dict = json as? [String: CGFloat],
              let width = dict["width"],
              let height = dict["height"] else {
            return .zero
        }
        
        return CGSize(width: width, height: height)
    }
    
    var jsonObject: [String: CGFloat] {
        return [
            "width": width,
            "height": height
        ]
    }
}

extension CGAffineTransform {
    static func convertFromDict(_ json: [String: Any]) -> CGAffineTransform {
        guard let dict = json as? [String: CGFloat],
              let a = dict["a"],
              let b = dict["b"],
              let c = dict["c"],
              let d = dict["d"],
              let tx = dict["tx"],
              let ty = dict["ty"]
        else {
            return .identity
        }
        
        return CGAffineTransform(a: a, b: b, c: c, d: d, tx: tx, ty: ty)
    }
    
    var jsonObject: [String: CGFloat] {
        return [
            "a": a,
            "b": b,
            "c": c,
            "d": d,
            "tx": tx,
            "ty": ty
        ]
    }
}
