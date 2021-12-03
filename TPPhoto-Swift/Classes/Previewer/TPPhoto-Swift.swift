//
//  TPPhoto-Swift.swift
//  TPPhoto-Swift
//
//  Created by Topredator on 2021/12/2.
//

import Foundation

public protocol TPPhotoPreviewerVCDelegate: AnyObject {
    func photoPreviewerVC(_ vc: TPPhotoPreviewerVC, _ counterTextAtPhotosIndex: Int) -> Void
}

@objcMembers public class TPPhotoPreviewerVC: UIViewController {
    
    public var urls: [String]!
    public var imgs: [UIImage]!
    private var isUrl: Bool = false
    public var currentIndex: Int = 0
    weak public var delegate: TPPhotoPreviewerVCDelegate?
    
    public init(showPhotos urls: [String]!, atIndex currentIndex: Int = 0) {
        var imgs = [String]()
        for url in urls {
            imgs.append(url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        }
        self.urls = urls
        self.currentIndex = currentIndex
        self.isUrl = true
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        modalTransitionStyle = .crossDissolve
        modalPresentationCapturesStatusBarAppearance = true
    }
    
    public init(showImgs imgs: [UIImage]!, atIndex currentIndex: Int = 0) {
        self.imgs = imgs
        self.currentIndex = currentIndex
        self.isUrl = false
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        modalTransitionStyle = .crossDissolve
        modalPresentationCapturesStatusBarAppearance = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    // MARK:  ------------- Private method --------------------
    /// 背景图
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    private lazy var scrollview: UIScrollView = {
        let scrollView = UIScrollView(frame: self.view.bounds)
        scrollView.isPagingEnabled = true
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 2
        return scrollView
    }()
    private lazy var counterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .white
        label.textAlignment = .center
        label.shadowOffset = CGSize(width: 1.0, height: 1.0)
        label.shadowColor = UIColor(white: 0, alpha: 0.7)
        return label
    }()
}

extension TPPhotoPreviewerVC {
    func setupSubviews() {
        view.backgroundColor = .clear
        view.addSubview(backgroundView)
        view.addSubview(scrollview)
        view.addSubview(counterLabel)
    }
}
