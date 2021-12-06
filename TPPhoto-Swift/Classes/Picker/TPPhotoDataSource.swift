//
//  TPPhotoDataSource.swift
//  TPPhoto-Swift
//
//  Created by Topredator on 2021/12/6.
//

import Foundation
import Photos
class TPPhotoDataSource: NSObject {
    var albums: [TPPhotoAlbum]?
    var selectedAlbum: TPPhotoAlbum?
    
    var photos = [TPPhoto]()
    var selectedPhotos = [TPPhoto]()
    var maxCount: Int = 0
    
    /// 加载所有相册
    func loadAllAlbums() {
        var arr = [TPPhotoAlbum]()
        
        let smartAlbum = PHAssetCollection.fetchAssetCollections(with: .smartAlbum,
                                                                 subtype: .albumRegular,
                                                                 options: nil)
        arr += transAllAlbums(smartAlbum)
        
        let userAlbum = PHAssetCollection.fetchAssetCollections(with: .album,
                                                                subtype: .albumRegular,
                                                                options: nil)
        arr += transAllAlbums(userAlbum)
        albums = moveAllPhotosToTop(arr)
    }
    
    func transAllAlbums(_ albums: PHFetchResult<PHAssetCollection>) -> [TPPhotoAlbum] {
        var arr = [TPPhotoAlbum]()
        albums.enumerateObjects { (collection, index, stop) in
            arr.append(TPPhotoAlbum(collection: collection))
        }
        return arr
    }
    
    /// 选择相册
    func selectAlbum(_ album: TPPhotoAlbum) {
        if let doAlbums = albums {
            for inAlbum in doAlbums {
                if inAlbum.localIdentifier == album.localIdentifier {
                    selectedAlbum = inAlbum
                    selectedPhotos.removeAll()
                    break
                }
            }
        }
    }
    
    func reloadAllPhotos() {
        photos = selectedAlbum?.photos ?? [TPPhoto]()
    }
    
    func updateSelectedPhotos(_ photo: TPPhoto,
                              _ selected: Bool,
                              _ complete: ([TPPhoto]) -> Void) {
        if selected && selectedPhotos.count >= maxCount {
            print("最多选择\(maxCount)张")
            return
        }
        //先拷贝一份原有数组
        var reloadSelectedPhotos = selectedPhotos
        if selected {
            //如果选中 就加一个新的
            selectedPhotos.append(photo)
            //再拷贝一份新的数组
            reloadSelectedPhotos = selectedPhotos
        } else {
            //如果没取消选中 就移除这个对象
            var idx = -1
            for (index,p) in selectedPhotos.enumerated() {
                if p.localIdentifier == photo.localIdentifier {
                    idx = index
                }
            }
            if idx != -1 {
                selectedPhotos.remove(at: idx)
            }
        }
        complete(reloadSelectedPhotos)
    }
    
    
    //查询图片选中的顺序index
    func selectedIndexOfPhoto(_ photo: TPPhoto) -> Int? {
        for (index, p) in selectedPhotos.enumerated() {
            if p.localIdentifier == photo.localIdentifier {
                return index
            }
        }
        return nil
    }
    
    //导出选中的全部图片
    func exportAllSelectedPhotos(_ progress: ((Float)->Void)?,
                                 _ completeClosure:@escaping ([UIImage]) -> Void) -> Void {
        let group = DispatchGroup()
        var finishedCount = 0
        var imgs = [UIImage]()
        progress?(0.0)
        
        let queue = DispatchQueue(label: "com.xtwx.xtpp")
        for photo in selectedPhotos {
            group.enter()
            let sem = DispatchSemaphore(value: 0)
            queue.async {
                photo.exportImage(CGSize(width: photo.imageWidth, height: photo.imageHeight), nil) {
                    [weak self] (image, info) in
                    finishedCount = finishedCount + 1
                    if progress != nil && self != nil{
                        progress!(Float(finishedCount)/Float(self!.selectedPhotos.count))
                    }
                    if let fImg = image {
                        imgs.append(fImg)
                    }
                    sem.signal()
                    group.leave()
                }
                sem.wait()
            }   
        }
        group.notify(queue: DispatchQueue.main) {
            completeClosure(imgs)
        }
    }
    
    /// 把 '全部照片' 相册 移动到最上面
    private func moveAllPhotosToTop(_ list: [TPPhotoAlbum]) -> [TPPhotoAlbum] {
        var finalList = [TPPhotoAlbum]()
        var allPhotoIndex = -1
        
        for (index, album) in list.enumerated() {
            if album.albumCollection.assetCollectionSubtype == .smartAlbumUserLibrary {
                allPhotoIndex = index
            } else {
                finalList.append(album)
            }
        }
        finalList.insert(list[allPhotoIndex], at: 0)
        return finalList
    }

}
