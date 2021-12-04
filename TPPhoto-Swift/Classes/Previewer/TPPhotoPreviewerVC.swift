//
//  TPPhoto-Swift.swift
//  TPPhoto-Swift
//
//  Created by Topredator on 2021/12/2.
//

import Foundation
import TPUIKit_Swift

@objc public protocol TPPhotoPreviewerVCDelegate: AnyObject {
    func photoPreviewerVC(_ vc: TPPhotoPreviewerVC, _ counterTextAtPhotosIndex: Int)
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
        setupSubviews()
        reload(currentIndex)
    }
    
    
    // MARK:  ------------- Private method --------------------
    /// 背景图
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    private lazy var banner: Banner = {
        let view = Banner(frame: self.view.bounds)
        view.pageControl.isHidden = true
        view.scrollView.minimumZoomScale = 1
        view.scrollView.maximumZoomScale = 2
        view.delegate = self
        return view
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
        view.addSubview(banner)
        view.addSubview(counterLabel)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        banner.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        counterLabel.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(UI.StatusBarHeight)
        }
    }
    private func reload(_ currentIndex: Int) {
        setupCounterLabelWithCurrentIndex(currentIndex)
        banner.reloadData(show: currentIndex)
    }
    private func reloadImgs(_ imgs: [UIImage]!, _ currentIndex: Int) {
        self.imgs = imgs
        setupCounterLabelWithCurrentIndex(currentIndex)
        banner.reloadData(show: currentIndex)
    }
    private func setupCounterLabelWithCurrentIndex(_ index: Int) {
        guard let delegate = self.delegate else {
            counterLabel.text = self.isUrl ? "\(index + 1)/\(urls.count)" : "\(index + 1)/\(imgs.count)"
            return
        }
        delegate.photoPreviewerVC(self, index)
    }
    
    @objc func dismissAction() {
        dismiss(animated: true, completion: nil)
    }
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    public override var prefersStatusBarHidden: Bool {
        true
    }
    public override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        .fade
    }
}


extension TPPhotoPreviewerVC: BannerDelegate {
    public func numberOfPages(_ banner: Banner) -> Int {
        return self.isUrl ? urls.count : imgs.count
    }
    
    public func viewForPageIndex(_ banner: Banner, at index: Int) -> BannerPageView {
        var pageView = banner.dequeueReusablePage(indentifier: "page") as? ImagePageView
        if pageView == nil {
            pageView = ImagePageView(reuseIdentifier: "page")
            pageView!.singleTap.addTarget(self, action: #selector(dismissAction))
        }
        if isUrl {
            pageView!.imgUrl = urls[index]
        } else {
            pageView!.img = imgs[index]
        }
        return pageView!
    }
    public func showPageView(_ banner: Banner, at index: Int) {
        setupCounterLabelWithCurrentIndex(index)
    }
}
