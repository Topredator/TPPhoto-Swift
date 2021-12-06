//
//  TPPhotoAlbum.swift
//  TPPhoto-Swift
//
//  Created by Topredator on 2021/12/6.
//


import UIKit
import Photos

@objcMembers public class TPPhotoAlbum: NSObject {
    public init(collection: PHAssetCollection){
        albumCollection = collection
        super.init()
    }
    
    public var albumCollection: PHAssetCollection
    
    public var localIdentifier: String {
        albumCollection.localIdentifier
    }
    
    public var localizedTitle: String? {
        albumCollection.localizedTitle
    }
    
    public var assetsCount: Int {
        PHAsset.fetchAssets(in: albumCollection, options: nil).count
    }
    
    public var photos: [TPPhoto] {
        get {
            if cachedPhotos != nil {
                return cachedPhotos!
            }
            let op = PHFetchOptions()
            op.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            
            //获取当前相册中的全部图片
            let res = PHAsset.fetchAssets(in: albumCollection, options: op)
            var arr = [TPPhoto]()
            res.enumerateObjects { (asset, index, stop) in
                arr.append(TPPhoto(asset: asset))
            }
            if arr.count > 0 {
                cachedPhotos = arr
            }
           
            return arr
        }
    }
    
    private var cachedPhotos: [TPPhoto]?
    
    public func coverImage(_ targetSize: CGSize,
                           _ progress: TPPhotoDownloadProgressClosure?,
                           _ complete: @escaping TPPhotoDownloadCompleteClosure) -> TPPhotoDownloadIdent {
        let photos = self.photos
        if photos.count != 0 {
            return photos.first!.customImage(targetSize, .aspectFit, progress, complete)
        }
        return -1
    }
}

