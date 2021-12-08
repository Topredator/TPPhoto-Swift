# TPPhoto-Swift

[![CI Status](https://img.shields.io/travis/周晓路/TPPhoto-Swift.svg?style=flat)](https://travis-ci.org/周晓路/TPPhoto-Swift)
[![Version](https://img.shields.io/cocoapods/v/TPPhoto-Swift.svg?style=flat)](https://cocoapods.org/pods/TPPhoto-Swift)
[![License](https://img.shields.io/cocoapods/l/TPPhoto-Swift.svg?style=flat)](https://cocoapods.org/pods/TPPhoto-Swift)
[![Platform](https://img.shields.io/cocoapods/p/TPPhoto-Swift.svg?style=flat)](https://cocoapods.org/pods/TPPhoto-Swift)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

TPPhoto-Swift is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'TPPhoto-Swift'
```

## Author

周晓路, luyanggold@163.com

## Used

```swift
// 1、打开相册，选中多图
let vc = TPPhotoPickerVC(maxCount: 9)
vc.delegate = self
let navi = UINavigationController(rootViewController: vc)
present(navi, animated: true, completion: nil)

// 代理的回调函数是选中的图片
extension ViewController: TPPhotoPickerVCDelegate {
  func didFinish(_ vc: TPPhotoPickerVC, _ images: [UIImage]) {
        print("\(images)")
    }
}


/* 2、浏览网络图片，初始化使用传入url列表形式,
	atIndex参数 所标识展示的下标
*/
 let vc = TPPhotoPreviewerVC(showPhotos: [
   "url1地址",
   "url2地址",
   "url3地址"
 ], atIndex: 0)
present(vc, animated: true, completion: nil)

/*
	3、展示本地图片数组,初始化传入的参数为 图片数组 [Image],
atIndex参数 表示所展示图片的下标
*/
let vc = TPPhotoPreviewerVC(showImgs: [
  UIImage(named: "1xx"),
	UIImage(named: "2xx"),
  UIImage(named: "3xx")
])
present(vc, animated: true, completion: nil)
```
