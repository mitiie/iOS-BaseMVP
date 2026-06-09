//
//  UINavigation+Exts.swift
//  SwiftCommon
//
//  Created by mitie on 13/02/2023.
//

import UIKit

extension UINavigationController {
    public func pushTopViewController(_ viewController: UIViewController, animated: Bool) {
        var vcs = self.viewControllers
        while vcs.count > 1 {
            vcs.removeLast()
        }
        self.pushViewController(viewController, animated: animated)
        vcs.append(viewController)
        self.viewControllers = vcs
    }
    
    public func pushAndReplaceTopViewController(_ viewController: UIViewController, animated: Bool) {
        let topVC = self.topViewController
        self.pushViewController(viewController, animated: animated)
        var vcs = self.viewControllers
        if let topVC = topVC {
            if let index = vcs.firstIndex(of: topVC) {
                vcs.remove(at: index)
            }
        }
        self.viewControllers = vcs
    }
    
    public func pushMultiViewControllersAndReplaceTopViewController(_ viewControllers: [UIViewController], animated: Bool) {
        if let last = viewControllers.last {
            let topVC = self.topViewController
            self.pushViewController(last, animated: animated)
            var vcs = self.viewControllers
            if let topVC = topVC {
                if let index = vcs.firstIndex(of: topVC) {
                    vcs.remove(at: index)
                }
            }
            vcs.insert(contentsOf: viewControllers[0..<(viewControllers.count-1)], at: vcs.count-1)
            self.viewControllers = vcs
        }
    }
    
    public func pushMultiViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        if let last = viewControllers.last {
            self.pushViewController(last, animated: animated)
            var vcs = self.viewControllers
            vcs.insert(contentsOf: viewControllers[0..<(viewControllers.count-1)], at: vcs.count-1)
            self.viewControllers = vcs
        }
    }
    
    public func popToViewControllerBefore(viewController: UIViewController, animated: Bool) {
        let vcs = self.viewControllers
        let index: Int = vcs.firstIndex(of: viewController) ?? 0
        if index < vcs.count, index > 0 {
            let prevc = vcs[index - 1]
            self.popToViewController(prevc, animated: animated)
        }
    }
    
    public func popToViewController(atLevel: Int, animated: Bool) {
        let vcs = self.viewControllers
        if atLevel < vcs.count, atLevel >= 0 {
            let destVC = vcs[atLevel]
            self.popToViewController(destVC, animated: animated)
        }
    }
    
    public func popToViewController(downStep: Int, animated: Bool) {
        let vcs = self.viewControllers
        var level = vcs.count - downStep - 1
        if level < 0 {
            level = 0
        }
        if level < vcs.count {
            self.popToViewController(atLevel: level, animated: animated)
        }
    }
}
