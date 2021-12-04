//
//  Resource.swift
//  TPPhoto-Swift
//
//  Created by Topredator on 2021/12/4.
//

import Foundation


/// 获取 本地图片
public struct Resource {
    static let bundle: Bundle = {
        let bundle = Bundle.init(path: Bundle.init(for: TPPhoto.self).path(forResource: "TPPhotoSwift", ofType: "bundle", inDirectory: nil)!)
       return bundle!
    }()
    /// 获取图片
    public static func image(_ name:String) -> UIImage? {
         UIImage.init(named: name, in: bundle, compatibleWith: nil)
    }
}
