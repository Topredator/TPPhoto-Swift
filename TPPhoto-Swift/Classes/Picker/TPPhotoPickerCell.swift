//
//  TPPhotoPickerCell.swift
//  TPPhoto-Swift
//
//  Created by Topredator on 2021/12/6.
//

import UIKit
import Photos
import SnapKit

protocol TPPhotoPickerCellWrap: AnyObject {
    func didSelected(_ photo: TPPhoto, _ selected: Bool)
}

class TPPhotoPickerCell: UICollectionViewCell {
    weak var delegate: TPPhotoPickerCellWrap?
    var photo: TPPhoto? {
        didSet {
            loadImage()
        }
    }
    var selectedIndex: Int? {
        didSet {
            resetPickedStyle()
        }
    }
    
    private var key: Int32 = -1
    
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var selecteBtn:UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(didSelect), for: UIControl.Event.touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.layer.cornerRadius = 13
        return btn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TPPhotoPickerCell {
    private func createUI (){
        contentView.backgroundColor = .white
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        contentView.addSubview(selecteBtn)
        selecteBtn.snp_makeConstraints { make in
            make.width.height.equalTo(26)
            make.top.equalTo(5)
            make.right.equalTo(contentView).offset(-5)
        }
    }
    
    private func loadImage(){
        let op = PHImageRequestOptions()
        op.isNetworkAccessAllowed = true
        
        key = photo!.customImage(contentView.bounds.size, PHImageContentMode.aspectFit, nil, {
            [weak self] (image, info) in
            DispatchQueue.main.async {
                if let cInfo = info {
                    let cKey = cInfo["PHImageResultRequestIDKey"] as! Int32
                    if (self?.key == cKey) {
                        self?.imageView.image = image
                    }
                } else {
                    self?.key = -1
                }
            }
        })

    }
    
    private func resetPickedStyle() {
        if selectedIndex != nil {
            selecteBtn.setTitle(String(selectedIndex! + 1), for: .normal)
            selecteBtn.setImage(nil, for: .normal)
            selecteBtn.backgroundColor = UIColor.tp.hex("0x298fed")
        } else {
            selecteBtn.setTitle(nil, for: UIControl.State.normal)
            selecteBtn.setImage(Resource.image("unselected"), for: .normal)
            selecteBtn.backgroundColor = .clear
        }
    }
    
    @objc private func didSelect () {
        delegate?.didSelected(photo!, selectedIndex == nil)
    }
}
