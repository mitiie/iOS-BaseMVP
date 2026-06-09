//
//  PermissionType.swift
//  iOS-BaseMVP
//
//  Created by mitie on 12/1/26.
//

enum PermissionType: Hashable {
    case camera
    case microphone
    case photoLibrary
    case notification
    case attTracking
    
    var title: String {
        switch self {
        case .camera: "Camera Access".localize()
        case .microphone: "Microphone Access".localize()
        case .photoLibrary: "Photo Library Access".localize()
        case .notification: "Notification Access".localize()
        default: "Error".localize()
        }
    }
    
    var desc: String {
        switch self {
        case .camera: "Application needs permission to aceess Camera to take picture. Please grant the permisison in Settings".localize()
        case .microphone: "Application needs permission to aceess Microphone to record audio. Please grant the permisison in Settings".localize()
        case .photoLibrary: "Application needs permission to aceess Photo Library to pick photo. Please grant the permisison in Settings".localize()
        case .notification: "Application needs permission to aceess Notification to send alert. Please grant the permisison in Settings".localize()
        default: "Error".localize()
        }
    }
}
