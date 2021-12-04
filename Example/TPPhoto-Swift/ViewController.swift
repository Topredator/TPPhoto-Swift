//
//  ViewController.swift
//  TPPhoto-Swift
//
//  Created by 周晓路 on 11/30/2021.
//  Copyright (c) 2021 周晓路. All rights reserved.
//

import UIKit
import TPPhoto_Swift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupSubviews()
    }
    func setupSubviews() {
//        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
//        [btn setTitle:@"打开相册" forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector(openAlbum) forControlEvents:UIControlEventTouchUpInside];
//        [btn setTitleColor:UIColor.redColor forState:UIControlStateNormal];
//        [self.view addSubview:btn];
        
        let btn2 = UIButton(frame: CGRect(x: 100, y: 300, width: 100, height: 100))
        btn2.setTitle("图片浏览", for: .normal)
        btn2.setTitleColor(.red, for: .normal)
        btn2.addTarget(self, action: #selector(showPreView), for: .touchUpInside)
        view.addSubview(btn2)
        
        let btn3 = UIButton(frame: CGRect(x: 100, y: 500, width: 100, height: 100))
        btn3.setTitle("UIImage查看", for: .normal)
        btn3.setTitleColor(.red, for: .normal)
        btn3.addTarget(self, action: #selector(showPreViewUIImage), for: .touchUpInside)
        view.addSubview(btn3)
    }
    
    
    @objc func showPreView() {
        let vc = TPPhotoPreviewerVC(showPhotos: [
            "http://t8.baidu.com/it/u=3571592872,3353494284&fm=79&app=86&size=h300&n=0&g=4n&f=jpeg?sec=1586334398&t=71446ce0e1b35bdc75a6221091e27ad4",
            "http://t7.baidu.com/it/u=3616242789,1098670747&fm=79&app=86&size=h300&n=0&g=4n&f=jpeg?sec=1586334398&t=559804ae941dcd257c9d3791fa6a3acb"
        ], atIndex: 1)
        present(vc, animated: true, completion: nil)
    }
    @objc func showPreViewUIImage() {
        let vc = TPPhotoPreviewerVC(showImgs: [
            UIImage(named: "1")!,
            UIImage(named: "2")!
        ], atIndex: 1)
        present(vc, animated: true, completion: nil)
    }
}

