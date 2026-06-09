//
//  BaseController.swift
//  SmileyWallpaper
//
//  Created by mitie on 7/4/26.
//

import UIKit

class BaseController: UIViewController {
    var keyboardHeight: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppColor.background.color
        setupUI()
        bindingData()
    }
    
    func setupUI() {}
    
    func bindingData() {}
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func addKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc func handleKeyboardShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let _ = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        else { return }

        self.keyboardHeight = keyboardFrame.height
    }
    
    @objc func handleKeyboardHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let _ = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        else { return }

        self.keyboardHeight = 0.0
    }
    
    func showAlert(title: String, message: String, buttonTitle: String = "OK".localize(), completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let action = UIAlertAction(title: buttonTitle, style: .default) { _ in
                completion?()
            }
            alert.addAction(action)
            
            DispatchQueue.main.async {
                self.present(alert, animated: true)
            }
        }
    }
    
    deinit {
        self.removeKeyboardNotifications()
    }
}
