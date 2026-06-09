//
//  UIStoryboard+Exts.swift
//  SwiftCommon
//
//  Created by mitie on 13/02/2023.
//

import UIKit

extension UIStoryboard {
    public static func instantiateViewController(name: String, bundle: Bundle?, withIdentifier: String) -> Any {
        let storyboard: UIStoryboard = UIStoryboard(name: name, bundle: bundle)
        let controller = storyboard.instantiateViewController(withIdentifier: withIdentifier)
        return controller
    }
}
