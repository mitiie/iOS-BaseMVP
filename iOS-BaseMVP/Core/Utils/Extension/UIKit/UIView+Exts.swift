//
//  UIView+Exts.swift
//  SwiftCommon
//
//  Created by mitie on 13/02/2023.
//

import UIKit

//MARK: - @IBInspectable -
extension UIView {
    @IBInspectable public var circleCorner: Bool {
      get {
        return min(bounds.size.height, bounds.size.width) / 2 == radius
      }
      set {
          radius = newValue ? min(bounds.size.height, bounds.size.width) / 2 : radius
      }
    }
    
    @IBInspectable public var radius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable public var brWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable public var brColor: UIColor {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
    
}

//MARK: - Functions - 
extension UIView {
    public func safeAreaInsets() -> UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return self.safeAreaInsets
        } else {
            return UIEdgeInsets.zero
        }
    }
    
    public func createFromNib(bundle: Bundle?) -> [Any]? {
        return bundle?.loadNibNamed(self.className, owner: self, options: nil)
    }
    
    public func drawRound(radius: CGFloat, masksToBounds: Bool = true) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = masksToBounds
    }
    
    public func drawBorder(radius: CGFloat, _ borderWidth: CGFloat, _ borderColor: UIColor) {
        self.drawRound(radius: radius)
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
    
    public func roundCorners(corners: UIRectCorner, _ radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    public func roundCornersFix(corners: UIRectCorner, _ radius: CGFloat, _ width: CGFloat) {
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: width, height: bounds.height), byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    public func addRoundShadow(bounds: CGRect? = nil,
                               radius: CGFloat,
                               corners: UIRectCorner,
                               backgroundColor: UIColor,
                               strokeColor: UIColor,
                               strokeWidth: CGFloat,
                               shadowOffset: CGSize,
                               shadowRadius: CGFloat,
                               shadowColor: UIColor,
                               shadowOpacity: Float) {
        
        if let shapeLayer = self.layer.sublayers?.first as? CAShapeLayer {
            shapeLayer.removeFromSuperlayer()
        }
        
        var rect = self.bounds
        if let bounds = bounds {
            rect = bounds
        }
        
        let shadowLayer: CAShapeLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius)).cgPath
        shadowLayer.fillColor = backgroundColor.cgColor
        shadowLayer.strokeColor = strokeColor.cgColor
        shadowLayer.lineWidth = strokeWidth
        
        shadowLayer.shadowColor = shadowColor.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = shadowOffset
        shadowLayer.shadowOpacity = shadowOpacity
        shadowLayer.shadowRadius = shadowRadius
        
        self.layer.insertSublayer(shadowLayer, at: 0)
        
    }
    
    public func addGradient(_ colors: [CGColor], _ startPoint: CGPoint, _ endPoint: CGPoint, cornerRadius: CGFloat) {
        if let layers = self.layer.sublayers {
            for layer in layers {
                layer.removeFromSuperlayer()
            }
        }
        
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.colors = colors
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.frame = self.bounds
        gradient.cornerRadius = cornerRadius
        self.layer.insertSublayer(gradient, at: 0)
        
    }
    
    func applyWhiteLinearGradient() {
        self.layer.sublayers?.filter { $0.name == "whiteGradient" }.forEach { $0.removeFromSuperlayer() }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        
        let colorTop = UIColor.white.withAlphaComponent(0.0).cgColor
        let colorBottom = UIColor.white.withAlphaComponent(1.0).cgColor
        
        gradientLayer.colors = [colorTop, colorBottom]
        
        gradientLayer.locations = [0.23, 0.75] as [NSNumber]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        gradientLayer.name = "whiteGradient"
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func addGradientBorder(name: String = "gradientBorder", in bounds: CGRect, with colors: [UIColor],
                           startPoint: CGPoint, endPoint: CGPoint, lineWidth: CGFloat, cornerRadius: CGFloat) {
        layer.sublayers?.removeAll(where: { $0.name == name })
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.name = name
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint

        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = lineWidth
        shapeLayer.path = UIBezierPath(
            roundedRect: bounds.insetBy(dx: lineWidth / 2, dy: lineWidth / 2),
            cornerRadius: cornerRadius
        ).cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor

        gradientLayer.mask = shapeLayer
        layer.addSublayer(gradientLayer)
    }
    
    func addDashedBorder(name: String = "dashBorder", borderRadius: CGFloat, borderWidth: CGFloat, borderColor: UIColor, lineDashPattern: [NSNumber] = [4, 2]) {
        layer.sublayers?.removeAll(where: { $0.name == name })

        let color = borderColor.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.bounds.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.name = name
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = borderWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = lineDashPattern
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: borderRadius).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
    
    public func addBlur(style: UIBlurEffect.Style) {
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)

        blurView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(blurView)

        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: self.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    public func addDropShadow(
        color: UIColor = UIColor(hex: 0x00F5FF),
        opacity: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 0,
        blur: CGFloat = 5,
        spread: CGFloat = 0
    ) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = CGSize(width: x, height: y)
        layer.shadowRadius = blur / 2.0
        
        if spread == 0 {
            layer.shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            layer.shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
    
    func removeShadow() {
        layer.shadowOpacity = 0
    }
    
    public func createOverlay(frame: CGRect, radius: CGFloat) -> UIView {
        // Step 1
        let overlayView = UIView(frame: frame)
        overlayView.backgroundColor = UIColor.white
        // Step 2
        let path = CGMutablePath()
        path.addArc(center: CGPoint(x: frame.width/2, y: frame.height/2),
                    radius: radius,
                    startAngle: 0.0,
                    endAngle: 2.0 * .pi,
                    clockwise: false)
        path.addRect(CGRect(origin: .zero, size: overlayView.frame.size))
        // Step 3
        let maskLayer = CAShapeLayer()
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.path = path
        // For Swift 4.0
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        // For Swift 4.2
        maskLayer.fillRule = .evenOdd
        // Step 4
        overlayView.layer.mask = maskLayer
        overlayView.clipsToBounds = true
        
        return overlayView
    }
    
    public func makeAScreenshot() -> UIImage? {
        
        // Begin context
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        
        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}

// MARK: - Keyboard helpers -
private var keyboardConstraintKey: UInt8 = 0

extension UIView {
    private var keyboardConstraint: NSLayoutConstraint? {
        get {
            objc_getAssociatedObject(self, &keyboardConstraintKey) as? NSLayoutConstraint
        }
        set {
            objc_setAssociatedObject(self, &keyboardConstraintKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func observeKeyboard(centerYConstraint: NSLayoutConstraint) {
        self.keyboardConstraint = centerYConstraint
        
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
    
    func removeKeyboardObserver() {
        self.keyboardConstraint = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func handleKeyboardShow(_ notification: Notification) {
        guard let constraint = keyboardConstraint,
              let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        else { return }
        
        let keyboardHeight = keyboardFrame.height
        let offset = keyboardHeight / 2
        
        constraint.constant = -offset
        
        UIView.animate(withDuration: duration) {
            self.layoutIfNeeded()
        }
    }
    
    @objc private func handleKeyboardHide(_ notification: Notification) {
        guard let constraint = keyboardConstraint,
              let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        else { return }
        
        constraint.constant = 0
        
        UIView.animate(withDuration: duration) {
            self.layoutIfNeeded()
        }
    }
}

extension UIView {
    func pinToEdges(of parent: UIView, insets: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: parent.topAnchor, constant: insets.top),
            leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: insets.left),
            trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -insets.right),
            bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -insets.bottom)
        ])
    }
}
