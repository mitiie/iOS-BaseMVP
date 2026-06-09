//
//  SDWebImageHelper.swift
//  AIPhotoVideo
//
//  Created by Codex on 28/05/2026.
//

import UIKit
import SDWebImage
import SDWebImageWebPCoder

enum SDWebImageHelper {
    static let defaultImageLoadOptions: SDWebImageOptions = [
        .retryFailed,
        .highPriority,
        .scaleDownLargeImages,
        .continueInBackground
    ]
    
    static let animatedImageLoadOptions: SDWebImageOptions = [
        .scaleDownLargeImages,
        .continueInBackground,
        .avoidAutoSetImage
    ]
    
    static func configure(
        maxMemoryCost: UInt = 100 * 1024 * 1024,
        maxMemoryCount: UInt = 100,
        shouldUseWeakMemoryCache: Bool = false
    ) {
        SDImageCodersManager.shared.addCoder(SDImageWebPCoder.shared)
        SDImageCache.shared.config.maxMemoryCost = maxMemoryCost
        SDImageCache.shared.config.maxMemoryCount = maxMemoryCount
        SDImageCache.shared.config.shouldUseWeakMemoryCache = shouldUseWeakMemoryCache
    }
    
    static func configureAnimatedImageView(
        _ imageView: SDAnimatedImageView,
        shouldIncrementalLoad: Bool = false,
        clearBufferWhenStopped: Bool = true,
        runLoopMode: RunLoop.Mode = .default
    ) {
        imageView.shouldIncrementalLoad = shouldIncrementalLoad
        imageView.clearBufferWhenStopped = clearBufferWhenStopped
        imageView.runLoopMode = runLoopMode
        imageView.maxBufferSize = 1
    }
    
    static func cancelAndClear(_ imageView: SDAnimatedImageView) {
        imageView.sd_cancelCurrentImageLoad()
        imageView.stopAnimating()
        imageView.image = nil
    }
    
    static func loadAnimatedImage(
        into imageView: SDAnimatedImageView,
        url: URL?,
        placeholderImage: UIImage? = nil,
        targetSize: CGSize? = nil,
        scale: CGFloat = UIScreen.main.scale,
        options: SDWebImageOptions = animatedImageLoadOptions,
        context: [SDWebImageContextOption: Any] = [:],
        cacheType: SDImageCacheType = .disk,
        shouldCancelCurrentLoad: Bool = true,
        shouldSetImageAutomatically: Bool = true,
        completion: ((UIImage?, Error?, URL?) -> Void)? = nil
    ) {
        guard let url else {
            cancelAndClear(imageView)
            completion?(nil, nil, nil)
            return
        }
        
        if shouldCancelCurrentLoad {
            imageView.sd_cancelCurrentImageLoad()
        }
        
        var resolvedContext = context
        if let targetSize {
            resolvedContext[.imageThumbnailPixelSize] = CGSize(
                width: targetSize.width * scale,
                height: targetSize.height * scale
            )
        }
        resolvedContext[.storeCacheType] = cacheType.rawValue
        
        imageView.sd_setImage(
            with: url,
            placeholderImage: placeholderImage,
            options: options,
            context: resolvedContext,
            progress: nil
        ) { [weak imageView] image, error, _, imageURL in
            DispatchQueue.main.async {
                guard let imageView else { return }
                if shouldSetImageAutomatically {
                    imageView.image = image
                }
                completion?(image, error, imageURL)
            }
        }
    }
}
