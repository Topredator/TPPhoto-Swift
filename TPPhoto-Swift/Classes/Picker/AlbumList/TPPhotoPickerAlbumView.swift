//
//  TPPhotoPickerAlbumView.swift
//  TPPhoto-Swift
//
//  Created by Topredator on 2021/12/6.
//

import UIKit
import Photos
import SnapKit

class TPPhotoPickerAlbumView: UIView {
    var albums: [TPPhotoAlbum]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var selectAlbumAction: ((TPPhotoAlbum) -> Void)?
    
    private lazy var tableView: UITableView = {
        let t = UITableView(frame: .zero, style: .grouped)
        t.delegate = self
        t.dataSource = self
        t.register(TPPhotoPickerAlbumCell.self, forCellReuseIdentifier: "cell")
        if #available(iOS 11.0, *) {
            t.contentInsetAdjustmentBehavior = .never
        }
        return t
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TPPhotoPickerAlbumView {
    private func createUI(){
       self.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
}

extension TPPhotoPickerAlbumView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TPPhotoPickerAlbumCell
        cell.album = albums![indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let click = selectAlbumAction {
            click(albums![indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
}
