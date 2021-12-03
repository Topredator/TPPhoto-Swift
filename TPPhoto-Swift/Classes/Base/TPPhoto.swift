//
//  TPPhoto.swift
//  TPPhoto-Swift
//
//  Created by Topredator on 2021/11/30.
//

import Foundation
import Photos

public typealias TPPhotoDownloadIdent = Int32
public typealias TPPhotoDownloadProgressClosure = (Double, Error?, UnsafeMutablePointer<ObjCBool>, [AnyHashable: Any]?) -> Void
public typealias TPPhotoDownloadCompleteClosure = (UIImage?, [AnyHashable: Any]?) -> Void

@objcMembers public class TPPhoto: NSObject {
    public var asset: PHAsset
    public init(asset: PHAsset) {
        self.asset = asset
        super.init()
    }
    
    /// image height
    public var imageHeight: CGFloat {
        CGFloat(asset.pixelHeight)
    }
    /// image width
    public var imageWidth: CGFloat {
        CGFloat(asset.pixelWidth)
    }
    public var localIentifier: String {
        asset.localIdentifier
    }
    public func originalImage(_ progress: TPPhotoDownloadProgressClosure? = nil,
                              _ complete: @escaping TPPhotoDownloadCompleteClosure) -> TPPhotoDownloadIdent {
        asset.originSizeImage(progress, complete)
    }
    public func screenImage(_ progress: TPPhotoDownloadProgressClosure? = nil,
                            _ complete: @escaping TPPhotoDownloadCompleteClosure) -> TPPhotoDownloadIdent {
        asset.screenSizeImage(progress, complete)
    }
    public func customImage(_ size: CGSize,
                     _ mode: PHImageContentMode,
                     _ progress: TPPhotoDownloadProgressClosure? = nil,
                     _ complete: @escaping TPPhotoDownloadCompleteClosure) -> TPPhotoDownloadIdent {
        asset.fetchImage(size,
                         mode: mode,
                         progress,
                         complete)
    }
    public func exportImage(_ size: CGSize, _ progress: TPPhotoDownloadProgressClosure? = nil, _ complete: @escaping TPPhotoDownloadCompleteClosure) {
        asset.exportImage(size,
                          progress,
                          complete)
    }
}
