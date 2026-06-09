//
//  GlideUtils.swift
//  AIPhotoVideo
//
//  Created by Codex on 04/05/2026.
//

import Foundation
import UIKit
import CoreImage
import SDWebImage

protocol GlideImageResultRepresentable: AnyObject {
    var image: Any? { get }
    var bitmap: UIImage? { get set }
}

enum GlideUtils {
    private static let ciContext = CIContext()
    private static let defaultLoadOptions: SDWebImageOptions = [
        .retryFailed,
        .highPriority,
        .scaleDownLargeImages,
        .continueInBackground
    ]

    static func loadBitmap(path: Any) async -> UIImage? {
        await loadImage(
            from: path,
            options: defaultLoadOptions,
            context: [
                .storeCacheType: SDImageCacheType.disk.rawValue
            ]
        )
    }

    static func loadBitmapWithResize(uri: URL, newSize: Int) async -> UIImage? {
        await loadBitmapWithResize(model: uri, width: newSize, height: newSize)
    }

    static func loadBitmapWithResize(model: Any?, width: Int, height: Int) async -> UIImage? {
        guard let image = await loadImage(
            from: model,
            options: defaultLoadOptions,
            context: [
                .imageThumbnailPixelSize: CGSize(width: width, height: height),
                .storeCacheType: SDImageCacheType.disk.rawValue
            ]
        ) else {
            return nil
        }

        return image.scaledAndCenterCropped(to: CGSize(width: width, height: height))
    }

    static func preloadImageUris(_ uris: [URL]) {
        guard !uris.isEmpty else { return }

        SDWebImagePrefetcher.shared.prefetchURLs(
            uris,
            options: [.lowPriority],
            context: [.storeCacheType: SDImageCacheType.all.rawValue],
            progress: nil,
            completed: nil
        )
    }

    static func preloadImages(_ paths: [String]) {
        let urls = paths.compactMap { resolvedURL(from: $0) }
        preloadImageUris(urls)
    }

    static func preloadImage(
        _ imageURL: Any,
        onNextAction: (() -> Void)? = nil
    ) {
        Task {
            _ = await loadImage(
                from: imageURL,
                options: defaultLoadOptions,
                context: [.storeCacheType: SDImageCacheType.all.rawValue]
            )

            await MainActor.run {
                onNextAction?()
            }
        }
    }

    static func loadBitmapRealtimeAndCache(url: String) -> UIImage? {
        guard let resolvedURL = resolvedURL(from: url) else {
            return nil
        }

        let semaphore = DispatchSemaphore(value: 0)
        var result: UIImage?

        SDWebImageManager.shared.loadImage(
            with: resolvedURL,
            options: defaultLoadOptions,
            context: [
                .imageThumbnailPixelSize: CGSize(width: 420, height: 524),
                .storeCacheType: SDImageCacheType.all.rawValue
            ],
            progress: nil
        ) { image, _, error, _, _, _ in
            if let error = error {
                Common.showLog("Load realtime error: \(error.localizedDescription)")
            }
            result = image?.scaledAndCenterCropped(to: CGSize(width: 420, height: 524))
            semaphore.signal()
        }

        _ = semaphore.wait(timeout: .now() + 30)
        return result
    }

    static func loadBlurImageAndGetBitmap(
        imageSource: Any,
        blurRadius: Int = 16,
        sampling: Int = 1,
        width: Int,
        height: Int
    ) async -> UIImage? {
        guard let image = await loadImage(
            from: imageSource,
            options: defaultLoadOptions,
            context: [
                .imageThumbnailPixelSize: CGSize(width: width, height: height),
                .storeCacheType: SDImageCacheType.none.rawValue,
                .originalStoreCacheType: SDImageCacheType.none.rawValue
            ]
        ) else {
            return nil
        }

        let outputSize = CGSize(width: width, height: height)
        let cropped = image.scaledAndCenterCropped(to: outputSize)
        let effectiveRadius = CGFloat(max(1, blurRadius)) / CGFloat(max(1, sampling))
        return cropped?.applyingGaussianBlur(radius: effectiveRadius, context: ciContext)
    }

    static func loadImageAndGetBitmap(
        imageSource: Any,
        width: Int,
        height: Int
    ) async -> UIImage? {
        guard let image = await loadImage(
            from: imageSource,
            options: defaultLoadOptions,
            context: [
                .imageThumbnailPixelSize: CGSize(width: width, height: height),
                .storeCacheType: SDImageCacheType.none.rawValue,
                .originalStoreCacheType: SDImageCacheType.none.rawValue
            ]
        ) else {
            return nil
        }

        return image.scaledAndCenterCropped(to: CGSize(width: width, height: height))
    }

    static func preloadImageWithGlide<Result: GlideImageResultRepresentable>(
        imageResult: Result
    ) async -> Bool {
        guard let source = imageResult.image else {
            return false
        }

        guard let image = await loadImage(
            from: source,
            options: defaultLoadOptions,
            context: [.storeCacheType: SDImageCacheType.all.rawValue]
        ) else {
            return false
        }

        imageResult.bitmap = image
        return true
    }

    private static func loadImage(
        from source: Any?,
        options: SDWebImageOptions? = nil,
        context: [SDWebImageContextOption: Any] = [:]
    ) async -> UIImage? {
        if let image = source as? UIImage {
            return image
        }

        if let data = source as? Data {
            return UIImage(data: data)
        }

        guard let url = resolvedURL(from: source) else {
            return nil
        }

        let resolvedOptions = options ?? defaultLoadOptions

        return await withCheckedContinuation { continuation in
            SDWebImageManager.shared.loadImage(
                with: url,
                options: resolvedOptions,
                context: context,
                progress: nil
            ) { image, _, error, _, _, _ in
                print("Downloading error: \(String(describing: error?.localizedDescription))")
                continuation.resume(returning: image)
            }
        }
    }

    private static func resolvedURL(from source: Any?) -> URL? {
        switch source {
        case let url as URL:
            return url
        case let nsURL as NSURL:
            return nsURL as URL
        case let string as String:
            return resolvedURL(from: string)
        case let string as NSString:
            return resolvedURL(from: string as String)
        default:
            return nil
        }
    }

    private static func resolvedURL(from path: String) -> URL? {
        guard !path.isEmpty else { return nil }

        if let remoteURL = URL(string: path), remoteURL.scheme != nil {
            return remoteURL
        }

        return URL(fileURLWithPath: path)
    }
}

private extension UIImage {
    func scaledAndCenterCropped(to targetSize: CGSize) -> UIImage? {
        guard targetSize.width > 0, targetSize.height > 0 else {
            return self
        }

        guard size.width > 0, size.height > 0 else {
            return nil
        }

        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        let scale = max(widthRatio, heightRatio)
        let scaledSize = CGSize(width: size.width * scale, height: size.height * scale)
        let origin = CGPoint(
            x: (targetSize.width - scaledSize.width) / 2.0,
            y: (targetSize.height - scaledSize.height) / 2.0
        )

        let format = UIGraphicsImageRendererFormat.default()
        format.scale = 1
        format.opaque = false

        return UIGraphicsImageRenderer(size: targetSize, format: format).image { _ in
            draw(in: CGRect(origin: origin, size: scaledSize))
        }
    }

    func applyingGaussianBlur(radius: CGFloat, context: CIContext) -> UIImage? {
        guard radius > 0 else {
            return self
        }

        guard let inputImage = CIImage(image: self),
              let filter = CIFilter(name: "CIGaussianBlur") else {
            return self
        }

        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(radius, forKey: kCIInputRadiusKey)

        guard let outputImage = filter.outputImage?.cropped(to: inputImage.extent),
              let cgImage = context.createCGImage(outputImage, from: inputImage.extent) else {
            return self
        }

        return UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
    }
}
