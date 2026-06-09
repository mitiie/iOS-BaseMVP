//
//  AppFont.swift
//  iOS-BaseMVP
//
//  Created by mitie on 9/2/26.
//

import Foundation
import UIKit

internal struct FontConvertible {
    internal let name: String
    internal let family: String
    internal let path: String
    
#if os(macOS)
    internal typealias Font = NSFont
#elseif os(iOS) || os(tvOS) || os(watchOS)
    internal typealias Font = UIFont
#endif
    
    internal func font(size: CGFloat) -> Font {
        guard let font = Font(font: self, size: size) else {
            fatalError("Unable to initialize font '\(name)' (\(family))")
        }
        return font
    }
    
    internal func register() {
        // swiftlint:disable:next conditional_returns_on_newline
        guard let url = url else { return }
        CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
    }
    
    fileprivate var url: URL? {
        // swiftlint:disable:next implicit_return
        return Bundle.main.url(forResource: path, withExtension: nil)
    }
}

internal extension FontConvertible.Font {
    convenience init?(font: FontConvertible, size: CGFloat) {
#if os(iOS) || os(tvOS) || os(watchOS)
        if !UIFont.fontNames(forFamilyName: font.family).contains(font.name) {
            font.register()
        }
#elseif os(macOS)
        if let url = font.url, CTFontManagerGetScopeForURL(url as CFURL) == .none {
            font.register()
        }
#endif
        
        self.init(name: font.name, size: size)
    }
}

struct UrbanistFonts {
    static let black = FontConvertible(name: "Urbanist-Black", family: "Urbanist", path: "Urbanist-Black.ttf")
    static let bold = FontConvertible(name: "Urbanist-Bold", family: "Urbanist", path: "Urbanist-Bold.ttf")
    static let light = FontConvertible(name: "Urbanist-Light", family: "Urbanist", path: "Urbanist-Light.ttf")
    static let medium = FontConvertible(name: "Urbanist-Medium", family: "Urbanist", path: "Urbanist-Medium.ttf")
    static let regular = FontConvertible(name: "Urbanist-Regular", family: "Urbanist", path: "Urbanist-Regular.ttf")
    static let semibold = FontConvertible(name: "Urbanist-SemiBold", family: "Urbanist", path: "Urbanist-SemiBold.ttf")
}

struct FuturehistoryDemo {
    static let regular = FontConvertible(name: "Futurehistorydemo", family: "Futurehistorydemo", path: "Futurehistorydemo.ttf")
}

enum FontWeight: String {
    case black, bold, light, medium, regular, semibold
    case fhdemo
    
    var fontName: String {
        switch self {
        case .black:
            return UrbanistFonts.black.name
        case .bold:
            return UrbanistFonts.bold.name
        case .light:
            return UrbanistFonts.light.name
        case .medium:
            return UrbanistFonts.medium.name
        case .regular:
            return UrbanistFonts.regular.name
        case .semibold:
            return UrbanistFonts.semibold.name
        case .fhdemo:
            return FuturehistoryDemo.regular.name
        }
    }
}

extension UIFont {
    static func custom(_ size: CGFloat, _ weight: FontWeight) -> UIFont {
        let scale: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 1.2 : 1.0
        let pointSize = CGFloat(size) * scale
        return UIFont(name: weight.fontName, size: pointSize) ?? UIFont.systemFont(ofSize: pointSize)
    }
}
