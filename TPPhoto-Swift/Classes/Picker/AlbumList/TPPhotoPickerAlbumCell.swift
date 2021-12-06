//
//  TPPhotoPickerAlbumCell.swift
//  TPPhoto-Swift
//
//  Created by Topredator on 2021/12/6.
//

import UIKit
import SnapKit

class TPPhotoPickerAlbumCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var album: TPPhotoAlbum? {
        didSet {
            updateInfo()
        }
    }
    
    private var iView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor.tp.hex("0xdddddd")
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private var tLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 15)
        l.textColor = UIColor.tp.hex("0x333333")
        return l
    }()
    
    private var cLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 12)
        l.textColor = UIColor.tp.hex("0x999999")
        return l
    }()
    

    private var key : Int32 = -1
    private func createUI() {
        contentView.addSubview(iView)
        iView.snp.makeConstraints { (make) in
            make.width.height.equalTo(64)
            make.centerY.equalTo(contentView)
            make.left.equalTo(10)
        }
        
        contentView.addSubview(tLabel)
        tLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iView.snp.right).offset(10)
            make.height.equalTo(16)
            make.top.equalTo(contentView).offset(25)
            make.right.equalTo(contentView)
        }
        
        contentView.addSubview(cLabel)
        cLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iView.snp.right).offset(10)
            make.height.equalTo(14)
            make.bottom.equalTo(contentView).offset(-25)
            make.right.equalTo(contentView)
        }
    }
    
    private func updateInfo(){
        tLabel.text = album!.localizedTitle
        cLabel.text = "\(album!.assetsCount)"
        
        key = album!.coverImage(CGSize(width: 64, height: 64), nil, { [weak self](image, info) in
            DispatchQueue.main.async {
                if let cInfo = info {
                    let cKey = cInfo["PHImageResultRequestIDKey"] as! Int32
                    if (self?.key == cKey) {
                        self?.iView.image = image
                    }
                } else {
                    self?.key = -1
                }
            }
        })
    }
}
