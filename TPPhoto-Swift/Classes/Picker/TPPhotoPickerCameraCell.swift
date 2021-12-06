//
//  TPPhotoPickerCaneraCell.swift
//  TPPhoto-Swift
//
//  Created by Topredator on 2021/12/6.
//

import UIKit
import TPFoundation_Swift
import SnapKit

class TPPhotoPickerCameraCell: UICollectionViewCell {
    private lazy var iView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor.tp.hex("0xf4f4f4")
        view.image = Resource.image("camera")
        view.contentMode = .center
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func createUI() {
        contentView.addSubview(iView)
        iView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
