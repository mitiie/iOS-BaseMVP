//
//  Xib+Exts.swift.swift
//  iOS-BaseMVP
//
//  Created by mitie on 3/4/26.
//

import Foundation
import UIKit

protocol XibLoadable {
    static var xibName: String { get }
}

extension XibLoadable where Self: UIViewController {
    static var xibName: String {
        String(describing: self)
    }
}

extension UIViewController {
    static func initFromXib() -> Self {
        var name = String(describing: self)
        if let _ = Bundle.main.path(forResource: name, ofType: "nib") {
            return self.init(nibName: name, bundle: nil)
        } else {
            name = NSStringFromClass(superclass() ?? self)
            if name.contains(".") {
                let namesArray = name.components(separatedBy: ".")
                name = namesArray.last ?? name
            }
        }
        return self.init(nibName: name, bundle: nil)
    }
}

extension XibLoadable where Self: UIView {
    static var xibName: String {
        String(describing: self)
    }
    
    func loadNibContent() {
        guard let view = Bundle.main.loadNibNamed(Self.xibName, owner: self, options: nil)?.first as? UIView else {
            fatalError("Could not load view from nib with name: \(Self.xibName)")
        }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
}
