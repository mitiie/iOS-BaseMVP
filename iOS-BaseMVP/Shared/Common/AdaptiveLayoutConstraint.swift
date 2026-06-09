//
//  AdaptiveLayoutConstraint.swift
//  AIPhotoVideo
//
//  Created by mitie on 1/6/26.
//

import UIKit

final class AdaptivePopupLayoutConstraint: NSLayoutConstraint {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        guard Common.isIPAD else { return }
        
        constant = AppConfiguration.IPAD_CONTENT_INSETS.left
    }
    
}
