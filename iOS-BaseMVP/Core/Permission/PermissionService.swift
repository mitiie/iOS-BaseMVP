//
//  PermissionService.swift
//  iOS-BaseMVP
//
//  Created by mitie on 12/1/26.
//
import AVFoundation
import Foundation
import UserNotifications
import Photos
import UIKit
import AppTrackingTransparency
import AdSupport

protocol PermissionServiceProtocol {
    func checkPermission(_ type: PermissionType, showErrorAlert: Bool, completion: @escaping (_ isGranted: Bool) -> Void)
}

final class SystemPermissionService: PermissionServiceProtocol {
    func checkPermission(_ type: PermissionType, showErrorAlert: Bool, completion: @escaping (_ isGranted: Bool) -> Void) {
        Task {
            let status = await self.request(type)

            await MainActor.run {
                if status == .authorized {
                    completion(true)
                } else {
                    if showErrorAlert {
                        self.showPermissionErrorAlert(type: type)
                    }
                    completion(false)
                }
            }
        }
    }
    
    private func status(for type: PermissionType) async -> PermissionStatus {
        switch type {
        case .camera:
            return mapCameraStatus(AVCaptureDevice.authorizationStatus(for: .video))
            
        case .microphone:
            return mapMicrophoneStatus(AVCaptureDevice.authorizationStatus(for: .audio))

        case .photoLibrary:
            return mapPhotoStatus(PHPhotoLibrary.authorizationStatus(for: .readWrite))
            
        case .notification:
            let settings = await UNUserNotificationCenter.current().notificationSettings()
            return mapNotificationStatus(settings.authorizationStatus)
            
        case .attTracking:
            return mapATTTrackingStatus(ATTrackingManager.trackingAuthorizationStatus)

        }
    }
    
    private func request(_ type: PermissionType) async -> PermissionStatus {
        switch type {
        case .camera:
            let granted = await AVCaptureDevice.requestAccess(for: .video)
            return granted ? .authorized : .denied
            
        case .microphone:
            let granted = await AVCaptureDevice.requestAccess(for: .audio)
            return granted ? .authorized : .denied

        case .photoLibrary:
            let status = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
            return mapPhotoStatus(status)
            
        case .notification:
            let granted = try? await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .sound, .badge])
            return granted == true ? .authorized : .denied
            
        case .attTracking:
            let granted = await ATTrackingManager.requestTrackingAuthorization()
            return granted == .authorized ? .authorized : .denied
        }
    }
}

private extension SystemPermissionService {
    func mapCameraStatus(_ status: AVAuthorizationStatus) -> PermissionStatus {
        switch status {
        case .notDetermined: return .notDetermined
        case .authorized: return .authorized
        case .denied: return .denied
        case .restricted: return .restricted
        @unknown default: return .denied
        }
    }

    func mapPhotoStatus(_ status: PHAuthorizationStatus) -> PermissionStatus {
        switch status {
        case .notDetermined: return .notDetermined
        case .authorized, .limited: return .authorized
        case .denied: return .denied
        case .restricted: return .restricted
        @unknown default: return .denied
        }
    }

    func mapNotificationStatus(_ status: UNAuthorizationStatus) -> PermissionStatus {
        switch status {
        case .notDetermined: return .notDetermined
        case .authorized, .provisional: return .authorized
        case .denied: return .denied
        case .ephemeral: return .authorized
        @unknown default: return .denied
        }
    }
    
    func mapMicrophoneStatus(_ status: AVAuthorizationStatus) -> PermissionStatus {
        switch status {
        case .notDetermined: return .notDetermined
        case .authorized: return .authorized
        case .denied: return .denied
        case .restricted: return .restricted
        @unknown default: return .denied
        }
    }
    
    private func mapATTTrackingStatus(_ status: ATTrackingManager.AuthorizationStatus) -> PermissionStatus {
        switch status {
        case .notDetermined: return .notDetermined
        case .authorized: return .authorized
        case .denied: return .denied
        case .restricted: return .restricted
        @unknown default: return .denied
        }
    }
}

private extension SystemPermissionService {
    private func showPermissionErrorAlert(type: PermissionType) {
        guard let topVC = UIApplication.topController() else { return }
        let alertVC = UIAlertController(title: type.title, message: type.desc, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Cancel".localize(), style: .default, handler: { _ in
            DispatchQueue.main.async {
                alertVC.dismiss(animated: true)
            }
        }))
        alertVC.addAction(UIAlertAction(title: "Setting".localize(), style: .default, handler: { _ in
            DispatchQueue.main.async {
                alertVC.dismiss(animated: true)
            }
            Common.openSettings()
        }))
        DispatchQueue.main.async {
            topVC.present(alertVC, animated: true)
        }
    }
}
