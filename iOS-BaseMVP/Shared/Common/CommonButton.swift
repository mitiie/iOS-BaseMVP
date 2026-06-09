//
//  CommonButton.swift
//  iOS-BaseMVP
//
//  Created by mitie on 4/3/26.
//

import UIKit

class CommonButton: UIButton {
    
    @IBInspectable var size: CGFloat = 16.0 {
        didSet { applyStyle() }
    }
    
    @IBInspectable var weight: String = FontWeight.regular.rawValue {
        didSet { applyStyle() }
    }
    
    @IBInspectable var color: String = "text" {
        didSet {
            let appColor = AppColor(rawValue: color) ?? .neutral_700
            self.setTitleColor(appColor.color, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaultStyle()
        applyStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDefaultStyle()
        applyStyle()
    }
    
    func setupDefaultStyle() {}
    
    func applyStyle() {
        let _weight = FontWeight(rawValue: weight) ?? .regular
        let font    = UIFont.custom(size, _weight)
        
        if configuration != nil {
            configuration?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = font
                return outgoing
            }
        } else {
            titleLabel?.font = font
        }
    }
    
    @IBInspectable var contentPadding: Bool = false {
        didSet { invalidateIntrinsicContentSize() }
    }

    private let defaultPadding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)

    override var intrinsicContentSize: CGSize {
        guard contentPadding else { return super.intrinsicContentSize }
        let base = super.intrinsicContentSize
        return CGSize(
            width: base.width + defaultPadding.left + defaultPadding.right,
            height: base.height + defaultPadding.top + defaultPadding.bottom
        )
    }
}

final class PrimaryButton: CommonButton {
    
    var style: BaseButtonStyle = .primary {
        didSet { applyStyle() }
    }
    
    var isDisabled: Bool = false {
        didSet {
            self.alpha = isDisabled ? 0.2 : 1.0
            self.isUserInteractionEnabled = !isDisabled
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.height / 2
    }
    
    override func setupDefaultStyle() {
        self.color = AppColor.neutral_900.rawValue
        self.size = 20.0
        self.weight = FontWeight.medium.rawValue
    }
    
    func updateStyle(_ style: BaseButtonStyle) {
        self.style = style
    }
    
    override func applyStyle() {
        super.applyStyle()
        self.backgroundColor = style.backgroundColor
        self.layer.borderWidth = 1.0
        self.layer.borderColor = style.borderColor.cgColor
        self.circleCorner = true
    }
}
