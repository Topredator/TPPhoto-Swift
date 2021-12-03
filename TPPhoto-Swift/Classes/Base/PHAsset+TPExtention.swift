//
//  PHAsset+TPExtention.swift
//  TPPhoto-Swift
//
//  Created by Topredator on 2021/11/30.
//

import Foundation
import Photos

extension PHAsset {
    /// 原图
    public func originSizeImage(_ progress: PHAssetImageProgressHandler? = nil,
                                _ complete: @escaping (UIImage?, [AnyHashable: Any]?) -> Void) -> PHImageRequestID {
        fetchImage(CGSize(width: pixelWidth, height: pixelHeight),
                   mode: .aspectFill,
                   progress,
                   complete)
    }
    
    /// 屏幕大小图片
    public func screenSizeImage(_ progress: PHAssetImageProgressHandler? = nil, _ complete: @escaping (UIImage?, [AnyHashable: Any]?) -> Void) -> PHImageRequestID {
        fetchImage(UIScreen.main.bounds.size,
                   mode: .aspectFill,
                   progress,
                   complete)
    }
    /// 获取任意容器放得下的大小图
    public func fetchImage(_ targetSize: CGSize,
                    mode: PHImageContentMode,
                    _ progress: PHAssetImageProgressHandler?,
                    _ complete: @escaping (UIImage?, [AnyHashable: Any]?) -> Void) -> PHImageRequestID {
        let op = PHImageRequestOptions()
        op.isNetworkAccessAllowed = true
        op.resizeMode = .fast
        op.progressHandler = progress
        let screenScale = UIScreen.main.scale
        return PHCachingImageManager.default().requestImage(for: self,
                                                               targetSize: calculateSize(CGSize(width: targetSize.width * screenScale, height: targetSize.height * screenScale), CGSize(width: pixelWidth, height: pixelHeight)),
                                                               contentMode: mode,
                                                               options: op,
                                                               resultHandler: complete)
    }
    func exportImage(_ targetSize: CGSize,
                     _ progress: PHAssetImageProgressHandler? = nil,
                     _ complete: @escaping (UIImage?, [AnyHashable: Any]?) -> Void) {
        let op = PHImageRequestOptions()
        op.isNetworkAccessAllowed = true
        op.resizeMode = .exact
        op.progressHandler = progress
        op.isSynchronous = true
        DispatchQueue.global().async {
            let screenScale = UIScreen.main.scale
            PHCachingImageManager.default().requestImage(for: self,
                                                            targetSize: self.calculateSize(CGSize(width: targetSize.width * screenScale, height: targetSize.height * screenScale), CGSize(width: self.pixelWidth, height: self.pixelHeight)),
                                                            contentMode: .aspectFill,
                                                            options: op,
                                                            resultHandler: complete)
        }
    }
    /// 计算合适尺寸
    private func calculateSize(_ boundingSize: CGSize, _ forSize: CGSize) -> CGSize {
        let scaleRate = max(CGFloat(forSize.width) / boundingSize.width, CGFloat(forSize.height) / boundingSize.height)
        guard scaleRate >= 1 else {
            return forSize
        }
        return CGSize(width: CGFloat(forSize.width) / scaleRate, height: CGFloat(forSize.height) / scaleRate)
    }
    
}
