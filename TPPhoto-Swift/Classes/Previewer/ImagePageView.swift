//
//  ImagePageView.swift
//  TPPhoto-Swift
//
//  Created by Topredator on 2021/12/3.
//

import Foundation
import TPUIKit_Swift
import SDWebImage

@objcMembers class ImagePageView: BannerPageView {
    
    override func preparedForReuse() {
        super.preparedForReuse()
        scrollView.zoomScale = 1
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateImageViewIfNeeded()
    }
    
    public var imgUrl : String? {
        didSet {
            self.isUrl = true
            self.setupImgView()
        }
    }
    
    public var img : UIImage? {
        didSet {
            self.isUrl = false
            self.setupImgView()
        }
    }
    
    private var isUrl:Bool = false
    
    public lazy var singleTap : UITapGestureRecognizer = {
        let ges = UITapGestureRecognizer()
        ges.delaysTouchesBegan = true
        return ges
    }()
    
    private lazy var doubleTap : UITapGestureRecognizer = {
        let ges = UITapGestureRecognizer(target: self, action:#selector(handleDoubleTap))
        ges.delaysTouchesBegan = true
        ges.numberOfTouchesRequired = 2
        return ges
    }()
    
    private lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView.init(frame: CGRect.zero)
        scrollView.minimumZoomScale = 1
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.decelerationRate = UIScrollView.DecelerationRate.fast
        scrollView.delegate = self
        return scrollView
    }()
    
    private lazy var imageView : UIImageView = {
        let view = UIImageView(frame: CGRect.zero)
        view.contentMode = UIView.ContentMode.scaleAspectFit
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private var fitZoomScale : Double = 1
}
extension ImagePageView {
    private func setupSubViews(){
        self.addSubview(self.scrollView)
        self.scrollView.addSubview(self.imageView)
        self.scrollView.addGestureRecognizer(self.singleTap)
        self.scrollView.addGestureRecognizer(self.doubleTap)
        // 双击手势失败才会触发单击手势
        self.singleTap.require(toFail:self.doubleTap)
    }
    
    
    private func setupImgView (){
        imageView.isHidden = true
        if isUrl {
            imageView.sd_setImage(with: URL(string: imgUrl!)) { [weak self] (image, err, cacheType, imageUrl) in
                self?.imageView.isHidden = false
                if (image == nil) {
                    self?.imageView.image = Resource.image("picture_fail")
                    self?.updateImageViewIfNeeded()
                }
            }
        } else {
            imageView.image = img
            imageView.isHidden = false
            updateImageViewIfNeeded()
        }
        
    }
    
    private func updateImageViewIfNeeded (){
        if (!scrollView.frame.equalTo(bounds)) {
            scrollView.frame = bounds;
            scrollView.contentSize = bounds.size;
            imageView.frame = bounds;
        }
        if (imageView.image != nil) {
            let imageSize : CGSize = imageFitSize(imageView.image!)
            let boundsSize : CGSize = frame.size
            let scaledSize : CGSize = CKNarrowSize(imageSize, boundsSize)
            fitZoomScale = Double(imageSize.width/scaledSize.width)
            scrollView.maximumZoomScale = CGFloat(max(2, 2 * fitZoomScale))
        }
    }
    
    private func imageFitSize(_ image:UIImage)->CGSize {
        let imgWidth : CGFloat = round(imageView.image!.size.width * imageView.image!.scale / UIScreen.main.scale)
        let imgHeight : CGFloat = round(imageView.image!.size.height * imageView.image!.scale / UIScreen.main.scale)
        return CGSize(width: imgWidth, height: imgHeight)
    }
    
    private func CKNarrowSize(_ oSize:CGSize, _ mxSize:CGSize)->CGSize {
        var oldSize : CGSize = oSize
        let maxSize : CGSize = mxSize
        //长和宽都小于压缩大小，不压缩
        if (oldSize.height < maxSize.height && oldSize.width < maxSize.width) {
            return oldSize;
        }
        if (maxSize.height == 0) {
            oldSize.height = 0;
            oldSize.width = min(maxSize.width, oldSize.width)
        }
        
        let thumbnailScale : CGFloat = maxSize.width/maxSize.height;
        let scale : CGFloat = oldSize.width/oldSize.height;
        var newSize : CGSize = maxSize;
        if (scale > thumbnailScale) {
            newSize.width = maxSize.width;
            newSize.height = newSize.width/scale;
        } else {
            newSize.height = maxSize.height;
            newSize.width = newSize.height*scale;
        }
        return newSize;
    }
    
    @objc private func handleDoubleTap(){
        let minScale : CGFloat = scrollView.minimumZoomScale
        let fitScale : CGFloat = CGFloat(fitZoomScale) > minScale ? CGFloat(fitZoomScale) : 1.5
        if scrollView.minimumZoomScale  > fitScale {
            scrollView.setZoomScale(fitScale, animated: true)
        } else if scrollView.zoomScale < fitScale {
            scrollView.setZoomScale(fitScale, animated: true)
        } else {
            scrollView.setZoomScale(minScale, animated: true)
        }
    }
    
    
}

extension ImagePageView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
