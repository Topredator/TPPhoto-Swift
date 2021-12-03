//
//  TPPhotoAuth.swift
//  TPPhoto-Swift
//
//  Created by Topredator on 2021/11/30.
//

import Foundation
import Photos
import AVFoundation

public enum TPPhotoAuthState: Int {
    case denied = 0
    case success = 1
}

@objcMembers public class TPPhotoAuth: NSObject {
    
    /// 相册权限请求
    public class func albumAuth(_ complete: @escaping (TPPhotoAuthState) -> Void) {
        let currentState = PHPhotoLibrary.authorizationStatus()
        switch currentState {
        case .authorized:
            complete(.success)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    switch status {
                    case .authorized:
                        complete(.success)
                    default:
                        complete(.denied)
                    }
                }
            }
        default:
            complete(.denied)
        }
    }
    
    /// 相机权限请求
    public class func cameraAuth(_ complete: @escaping (TPPhotoAuthState) -> Void) {
        let currentState = AVCaptureDevice.authorizationStatus(for: .video)
        switch currentState {
        case .authorized:
            complete(.success)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                DispatchQueue.main.async {
                    complete(success ? .success : .denied)
                }
            }
        default:
            complete(.denied)
        }
    }
    
}
