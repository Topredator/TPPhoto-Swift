//
//  TPPhotoPickerVC.swift
//  TPPhoto-Swift
//
//  Created by Topredator on 2021/12/6.
//

import UIKit
import Photos
import SVProgressHUD

@objc public protocol TPPhotoPickerVCDelegate: AnyObject {
    func didFinish(_ vc: TPPhotoPickerVC, _ images: [UIImage])
}

@objcMembers public class TPPhotoPickerVC: UIViewController {
    
    public weak var delegate: TPPhotoPickerVCDelegate?
    
    private var originStatusBarStyle : UIStatusBarStyle = .default
    
    private lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 3

        let view = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.alwaysBounceVertical = true
        view.backgroundColor = .white
        view.contentInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        view.register(TPPhotoPickerCell.self, forCellWithReuseIdentifier: "cell")
        view.register(TPPhotoPickerCameraCell.self, forCellWithReuseIdentifier: "camera")
        if #available(iOS 11.0, *) {
            view.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        }
        return view
    }()
    
    private lazy var submitBtn : UIButton = {
        let btn = UIButton(frame:CGRect(x: 0, y: 0, width: 80, height: 30))
        btn.addTarget(self, action: #selector(submit), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        btn.isUserInteractionEnabled = false
        btn.setTitleColor(.gray, for: .normal)
        return btn
    }()
    
    private lazy var titleBtn : UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 30))
        btn.addTarget(self, action: #selector(pressSelectAlbums), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.setTitleColor(UIColor.tp.hex("0x333333"), for: .normal)
        return btn
    }()
    
    private lazy var albumView : TPPhotoPickerAlbumView = {
       let view = TPPhotoPickerAlbumView(frame: CGRect(x: 0, y: -self.view.bounds.size.height, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        return view
    }()
    
    private var showAlbumView:Bool = false {
        didSet {
            updateUI()
        }
    }
    
   private let dataSource = TPPhotoDataSource()
    
    public init(maxCount count: Int) {
        dataSource.maxCount = count
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = titleBtn
        navigationController?.navigationBar.isTranslucent = false
        let left = UIBarButtonItem(title: "取消", style: UIBarButtonItem.Style.plain, target: self, action: #selector(close))
        left.tintColor = UIColor.tp.hex("0x333333")
        navigationItem.leftBarButtonItem = left
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        view.addSubview(albumView)
        
        registObserver()
        
        TPPhotoAuth.albumAuth { [weak self] (status) in
            if status == .success {
                self?.start()
            } else {
                SVProgressHUD.showError(withStatus: "请开启相册权限")
            }
        }
    }
    
    private func start(){
        albumView.selectAlbumAction = {[weak self](album) in
            //选中当前相册
            self?.dataSource.selectAlbum(album)
            self?.changedSelectedAlbum()
            self?.pressSelectAlbums()
        }
        
        dataSource.loadAllAlbums()
        dataSource.selectAlbum(dataSource.albums!.first!)
        changedSelectedAlbum()
        
        updateUI()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
        updateSubmitBtnStyle()
        originStatusBarStyle = UIApplication.shared.statusBarStyle
        UIApplication.shared.statusBarStyle = .default
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = originStatusBarStyle
    }
    
    deinit {
        unregistObserver()
    }
}

extension TPPhotoPickerVC {
    private func changedSelectedAlbum() {
        dataSource.reloadAllPhotos()
        collectionView.reloadData()
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionView.ScrollPosition.top, animated: false)
    }
    
    private func updateSubmitBtnStyle() {
        submitBtn.setTitle("确定(\(dataSource.selectedPhotos.count)/\(dataSource.maxCount))", for: .normal)
        if dataSource.selectedPhotos.count == 0 {
            submitBtn.setTitleColor(.gray, for: .normal)
            submitBtn.isUserInteractionEnabled = false
        } else {
            submitBtn.setTitleColor(UIColor.tp.hex("0x298fed"), for: .normal)
            submitBtn.isUserInteractionEnabled = true
        }
    }
    
    private func updateTitleBtnStyle() {
        titleBtn.setTitle(dataSource.selectedAlbum?.localizedTitle, for: .normal)
        if showAlbumView {
            //展开状态
            titleBtn.setImage(Resource.image("listup"), for: .normal)
        } else {
            titleBtn.setImage(Resource.image("listdown"), for: .normal)
        }
    
        let space = CGFloat(2.0)
        titleBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -titleBtn.imageView!.bounds.size.width - space, bottom: 0, right: titleBtn.imageView!.bounds.size.width + space)
        titleBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: titleBtn.titleLabel!.bounds.size.width + space, bottom: 0, right: -titleBtn.titleLabel!.bounds.size.width - space)
    }
    
    private func updateUI(){
        if  !showAlbumView {
            //收起
            UIView.animate(withDuration: 0.2) {[weak self] in
                if let sself = self {
                    sself.albumView.frame = CGRect(x: 0, y:  -sself.view.bounds.size.height, width: sself.view.bounds.size.width, height: sself.view.bounds.size.height)
                }
            }
            let left = UIBarButtonItem(title: "取消", style: UIBarButtonItem.Style.plain, target: self, action: #selector(close))
            left.tintColor = UIColor.tp.hex("0x333333")
            navigationItem.leftBarButtonItem = left
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: submitBtn)
        } else {
            //展开
            albumView.albums = dataSource.albums
            UIView.animate(withDuration: 0.2) {[weak self] in
                if let sself = self {
                    sself.albumView.frame = CGRect(x: 0, y:  0, width: sself.view.bounds.size.width, height: sself.view.bounds.size.height)
                }
            }
            let left = UIBarButtonItem(image: Resource.image("close"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(pressSelectAlbums))
            left.tintColor = UIColor.tp.hex("0x333333")
            navigationItem.leftBarButtonItem = left
            navigationItem.rightBarButtonItem = nil
        }
        
        updateSubmitBtnStyle()
        updateTitleBtnStyle()
    }
}

extension TPPhotoPickerVC {
    @objc private func close(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func submit(){
        dataSource.exportAllSelectedPhotos({ (progress) in
            print("正在导出\(progress)")
            DispatchQueue.main.async {
                self.navigationController?.view.isUserInteractionEnabled = false
                SVProgressHUD.showProgress(progress, status: "正在处理图片")
            }
        }) {[weak self] (images) in
            self?.navigationController?.view.isUserInteractionEnabled = true
            SVProgressHUD.dismiss()
            if self?.delegate != nil {
                self?.delegate!.didFinish(self!, images)
            }
            self?.close()
        }
    }
    @objc private func pressSelectAlbums(){
        showAlbumView = !showAlbumView
    }
}

extension TPPhotoPickerVC: TPPhotoPickerCellWrap {
    //选择了图片
    internal func didSelected(_ photo: TPPhoto, _ selected: Bool) {
        if selected  && dataSource.selectedPhotos.count >= dataSource.maxCount {
            print("最多选择9张图")
        }
        dataSource.updateSelectedPhotos(photo, selected) { (handledPhotos) in
            reloadUpdatedCell(handledPhotos)
            updateSubmitBtnStyle()
        }
    }
    
    //刷新目标Cell
    private func reloadUpdatedCell(_ photos: [TPPhoto]) {
        for cell in collectionView.visibleCells {
            if let tCell = cell as? TPPhotoPickerCell {
                for p in photos {
                    if p.localIdentifier == tCell.photo!.localIdentifier {
                        //通过setter方法直接刷新这个cell选中样式
                        tCell.selectedIndex = dataSource.selectedIndexOfPhoto(p)
                    }
                }
            }
        }
    }
    
}

//MARK:-列表部分
extension TPPhotoPickerVC : UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.photos.count + 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            //相机
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "camera", for: indexPath)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TPPhotoPickerCell
            cell.photo = dataSource.photos[indexPath.row - 1]
            cell.delegate = self
            cell.selectedIndex = dataSource.selectedIndexOfPhoto(dataSource.photos[indexPath.row - 1])
            return cell
        }
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = floor((view.bounds.size.width - 3.0 * 5)/4.0)
        return CGSize(width: width, height: width)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            print("点击了相机，去拍照")
            openCamera()
        } else {
            print("点击了图片,去放大选择器")
            didSelected(dataSource.photos[indexPath.row - 1], dataSource.selectedIndexOfPhoto(dataSource.photos[indexPath.row - 1]) == nil ? true : false)
        }
        
    }
    
    
}

extension TPPhotoPickerVC: PHPhotoLibraryChangeObserver {
    
    private func registObserver() {
        PHPhotoLibrary.shared().register(self)
    }
    private func unregistObserver() {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    //PHPhotoLibraryChangeObserver
    public func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.async { [weak self] in
            self?.start()
        }
    }
}

extension TPPhotoPickerVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func openCamera () {
        let cam = UIImagePickerController()
        cam.delegate = self
        cam.sourceType = .camera
        self.present(cam, animated: true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.init(string: UIImagePickerControllerOriginalImage)] as? UIImage {
            // 获取图片
            delegate?.didFinish(self, [image])
        }
        picker.dismiss(animated: true, completion: nil)
        close()
    }
    

}
