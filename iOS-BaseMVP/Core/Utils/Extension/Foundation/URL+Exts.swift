//
//  URL+Exts.swift
//  SwiftCommon
//
//  Created by mitie on 13/02/2023.
//

import UIKit
import Photos
import Foundation

extension URL {
    func thumbnailData() -> Data? {
        return thumbnailImage()?.jpegData(compressionQuality: 0.8)
    }
    
    func thumbnailImage() -> UIImage? {
        let asset: AVAsset = AVAsset(url: self)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTime(value: 1, timescale: 60) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch {
        }
        
        return nil
    }
    
    func appendingQueryItems(_ params: [String: Any]) -> URL {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)!
        components.queryItems = params.map {
            URLQueryItem(name: $0.key, value: "\($0.value)")
        }
        return components.url!
    }
    
    func getFirstFrame() -> UIImage? {
        let asset = AVAsset(url: self)
        
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        
        let firstTime = CMTime(seconds: 0, preferredTimescale: 600)
        
        do {
            let cgImage = try generator.copyCGImage(at: firstTime, actualTime: nil)
            return UIImage(cgImage: cgImage)
        } catch {
            print("❌ Error getting first frame:", error)
            return nil
        }
    }
    
    func getLastFrame() async -> UIImage? {
        let asset = AVAsset(url: self)

        do {
            let duration = try await asset.load(.duration)
            let seconds = CMTimeGetSeconds(duration)

            let lastTime = CMTime(
                seconds: max(seconds - 0.01, 0),
                preferredTimescale: 600
            )

            let generator = AVAssetImageGenerator(asset: asset)
            generator.appliesPreferredTrackTransform = true

            let cgImage = try generator.copyCGImage(
                at: lastTime,
                actualTime: nil
            )

            return UIImage(cgImage: cgImage)
        } catch {
            print("❌ Error getting last frame:", error)
            return nil
        }
    }
}
