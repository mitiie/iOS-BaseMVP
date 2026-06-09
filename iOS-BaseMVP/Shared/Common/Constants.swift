//
//  Constants.swift
//  iOS-BaseMVP
//
//  Created by mitie on 23/12/25.
//

import Foundation
import UIKit
import AVFoundation

//MARK: - Typealias -
typealias RefreshingCompletion                      =   () -> Void

//MARK: - Enums -
enum ViewState {
    case `default`
    case loading
    case empty
    case error
}

enum TabbarIndex: Int {
    case home, aiVideo, creation, aiTool, gallery
}

enum BaseButtonStyle: String {
    case primary, black, premium
    
    var backgroundColor: UIColor {
        switch self {
        case .primary:
            return AppColor.neutral_200.color
        case .black:
            return AppColor.neutral_900.color
        case .premium:
            return .clear
        }
    }
    
    var borderColor: UIColor {
        return UIColor.clear
    }
}

enum NotificationKey: String {
    case reloadData
    
    var notificationName: Notification.Name {
        Notification.Name(self.rawValue)
    }
}

//MARK: - Structs -
struct AppConfiguration {
    static let ALERT_MESSAGE_DURATION: Double       =   3.0
    static let HEIGHT_NAVIGATION_BAR: Double        =   64.0
    static let HEIGHT_TABBAR: Double                =   86.0
    static let DEEPLINK_SCHEME                      =   "iOS-BaseMVP"
    static let IMAGE_THUMBNAIL_SIZE: CGFloat        =   500.0
    static let IPAD_CONTENT_INSETS: UIEdgeInsets    =   UIEdgeInsets(top: 80, left: UIScreen.SCREEN_WIDTH * 0.15, bottom: 60, right: UIScreen.SCREEN_WIDTH * 0.15)
}

struct AppLinks {
    static let APP_STORE = "https://apps.apple.com/app/id6763209193"
    static let PRIVACY_POLICY = "https://sites.google.com/leansoft.io/helaai?usp=sharing"
    static let TERM_OF_USE = "https://sites.google.com/leansoft.io/hela-ai?usp=sharing"
}
