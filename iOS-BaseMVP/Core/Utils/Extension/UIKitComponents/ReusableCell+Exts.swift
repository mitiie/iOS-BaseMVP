//
//  ReusableCell+Exts.swift
//  iOS-BaseMVP
//
//  Created by mitie on 1/6/26.
//

import UIKit

// MARK: - UITableView Extension
extension UITableView {
    func registerNib<T: UITableViewCell>(for cellType: T.Type) {
        let identifier = String(describing: cellType)
        let nib = UINib(nibName: identifier, bundle: nil)
        register(nib, forCellReuseIdentifier: identifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T {
        let identifier = String(describing: cellType)
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Could not dequeue UITableViewCell with identifier: \(identifier)")
        }
        return cell
    }
}

// MARK: - UICollectionView Extension
extension UICollectionView {
    func registerNib<T: UICollectionViewCell>(for cellType: T.Type) {
        let identifier = String(describing: cellType)
        let nib = UINib(nibName: identifier, bundle: nil)
        register(nib, forCellWithReuseIdentifier: identifier)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T {
        let identifier = String(describing: cellType)
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Could not dequeue UICollectionViewCell with identifier: \(identifier)")
        }
        return cell
    }
}
