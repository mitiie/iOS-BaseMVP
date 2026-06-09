//
//  Utils.swift
//  iOS-BaseMVP
//
//  Created by mitie on 23/12/25.
//

import Foundation
import UIKit
import MBProgressHUD
import StoreKit
import SafariServices

final class Common {
    static var isIPAD: Bool { UIDevice.current.userInterfaceIdiom == .pad }
    static func scaledSpacing(based: CGFloat) -> CGFloat { Common.isIPAD ? based * 1.5 : based }

    static func sendNotification(_ notificationKey: NotificationKey, userInfo: [AnyHashable: Any]? = nil) {
        NotificationCenter.default.post(name: notificationKey.notificationName, object: nil, userInfo: userInfo)
    }
    
    static func performOnMainThread(_ closure: @escaping () -> Void) {
        if Thread.isMainThread {
            closure()
        } else {
            DispatchQueue.main.async {
                closure()
            }
        }
    }
    
    static func showLog(_ message: String) {
        #if DEBUG
        print(message)
        #endif
    }
    
    @MainActor static func showRateApp() {
        guard let scene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else { return }
        
        if #available(iOS 18.0, *) {
            AppStore.requestReview(in: scene)
        } else {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    static func showMBHUDLoading(on view: UIView? = nil) {
        DispatchQueue.main.async {
            guard let topVC = UIApplication.topController() else { return }
            MBProgressHUD.showAdded(to: view ?? topVC.view, animated: true)
        }
    }
    
    static func hideMBHUDLoading(on view: UIView? = nil) {
        DispatchQueue.main.async {
            guard let topVC = UIApplication.topController() else { return }
            MBProgressHUD.hide(for: view ?? topVC.view, animated: true)
        }
    }
    
    static func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    static func openWebBrowser(_ urlString: String) {
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    static func getCurrentWindow() -> UIWindow? {
        guard let window = UIApplication.shared
            .connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) else { return nil }
        return window
    }
    
    static func openSystemCamera(from vc: UIViewController, delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            let alert = UIAlertController(title: "Error".localize(), message: "Camera is not available".localize(), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK".localize(), style: .default))
            vc.present(alert, animated: true)
            return
        }
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = delegate
        picker.allowsEditing = false
        DispatchQueue.main.async {
            vc.present(picker, animated: true)
        }
    }
}
