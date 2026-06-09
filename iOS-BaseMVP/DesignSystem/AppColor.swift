//
//  AppColor.swift
//  iOS-BaseMVP
//
//  Created by mitie on 9/2/26.
//

import SwiftUI
import UIKit

enum AppColor: String {
    case primary_950
    case primary_900
    case primary_800
    case primary_700
    case primary_600
    case primary_500
    case primary_400
    case primary_300
    case primary_200
    case primary_100
    case primary_50
    
    case neutral_950
    case neutral_900
    case neutral_800
    case neutral_700
    case neutral_600
    case neutral_500
    case neutral_400
    case neutral_300
    case neutral_200
    case neutral_100
    case neutral_50
    
    case success
    case error
    case warning
    case black
    
    case background
    
    var color: UIColor {
        switch self {
        case .primary_950:
            UIColor(hex: 0x180E3B)
        case .primary_900:
            UIColor(hex: 0x2C196B)
        case .primary_800:
            UIColor(hex: 0x3A218C)
        case .primary_700:
            UIColor(hex: 0x4B2BB5)
        case .primary_600:
            UIColor(hex: 0x6037E8)
        case .primary_500:
            UIColor(hex: 0x6A3CFF)
        case .primary_400:
            UIColor(hex: 0x8763FF)
        case .primary_300:
            UIColor(hex: 0x9B7CFF)
        case .primary_200:
            UIColor(hex: 0xBAA5FF)
        case .primary_100:
            UIColor(hex: 0xD1C3FF)
        case .primary_50:
            UIColor(hex: 0xF0ECFF)
        case .neutral_950:
            UIColor(hex: 0x0A0A0B)
        case .neutral_900:
            UIColor(hex: 0x232325)
        case .neutral_800:
            UIColor(hex: 0x3B3B3F)
        case .neutral_700:
            UIColor(hex: 0x545459)
        case .neutral_600:
            UIColor(hex: 0x6D6D74)
        case .neutral_500:
            UIColor(hex: 0x87878E)
        case .neutral_400:
            UIColor(hex: 0xA0A0A6)
        case .neutral_300:
            UIColor(hex: 0xD5D5D8)
        case .neutral_200:
            UIColor(hex: 0xEFEFF0)
        case .neutral_100:
            UIColor(hex: 0xFAFAFA)
        case .neutral_50:
            UIColor(hex: 0xFFFFFF)
        case .success:
            UIColor(hex: 0x00CC2C)
        case .error:
            UIColor(hex: 0xFF0000)
        case .warning:
            UIColor(hex: 0xFFD500)
        case .black:
            UIColor.black
        case .background:
            UIColor.white
        }
    }
}

// MARK: - Gradient
extension AppColor {
    static let progressGradientColors: [UIColor] = [
        AppColor.neutral_200.color, AppColor.neutral_200.color
    ]
    
    static let premiumGradientColors: [UIColor] = [
        UIColor(hex: 0x8FDEFF), UIColor(hex: 0x864AFF), UIColor(hex: 0xFF4CDE)
    ]
    
    static let popupGradientColors: [UIColor] = [
        UIColor(white: 1.0, alpha: 0.2), UIColor(white: 1.0, alpha: 0), UIColor(white: 1.0, alpha: 0.1)
    ]
}
