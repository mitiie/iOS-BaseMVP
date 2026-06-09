//
//  BaseServiceProtocol.swift
//  SmileyWallpaper
//
//  Created by mitie on 8/4/26.
//

import Foundation
import Combine

protocol BaseServiceProtocol {
    var loadingPublisher: AnyPublisher<Bool, Never> { get }
    var errorPublisher: AnyPublisher<String?, Never> { get }
}
