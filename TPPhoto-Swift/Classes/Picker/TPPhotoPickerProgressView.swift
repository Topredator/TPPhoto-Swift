//
//  TPPhotoPickerProgressView.swift
//  TPPhoto-Swift
//
//  Created by Topredator on 2021/12/6.
//

import UIKit

class TPPhotoPickerProgressView: UIView {
    var progress = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.clear(rect)
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.width/2.0, y: rect.height/2.0))
        path.addArc(withCenter: CGPoint(x: rect.width/2.0, y: rect.height/2.0), radius: min(rect.width/2.0,rect.height/2.0), startAngle: CGFloat(-0.5 * Double.pi), endAngle: CGFloat((2.0 * progress - 0.5) * Double.pi), clockwise: true)
        path.close()
        ctx?.addPath(path.cgPath)
        ctx?.setFillColor(UIColor.white.withAlphaComponent(0.5).cgColor)
        ctx?.fillPath()
    }
}
