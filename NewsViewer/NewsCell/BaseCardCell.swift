//
//  BaseCardCell.swift
//  NewsViewer
//
//  Created by Duy Nguyen on 7/17/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import UIKit

class BaseCardCell: UICollectionViewCell {
    
    private static let kInnerMargin: CGFloat = 20.0
    
    private weak var shadowView: UIView?
    
    private var isPressed: Bool = false
    
    let cornerRadius: CGFloat = 20.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureShadow()
    }
    
    
    // MARK: - Shadow
    
    func configureShadow(){
        // Remove shadowView if exist
        self.shadowView?.removeFromSuperview()
        let shadowView = UIView(frame: CGRect(x: BaseCardCell.kInnerMargin,
                                              y: BaseCardCell.kInnerMargin - 5.0,
                                              width: bounds.width - (2 * BaseCardCell.kInnerMargin),
                                              height: bounds.height - (2 * BaseCardCell.kInnerMargin)))
        insertSubview(shadowView, at: 0)
        
        
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowRadius = 10.0
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = .zero
        shadowView.layer.shadowOpacity = 0.35

        let shadowBox = CGRect(x: shadowView.bounds.minX,
                               y: shadowView.bounds.minY,
                               width: shadowView.bounds.width,
                               height: shadowView.bounds.height)
        shadowView.layer.shadowPath = UIBezierPath(roundedRect: shadowBox,
                                                         cornerRadius: cornerRadius).cgPath
        self.shadowView = shadowView
    }
    
    // MARK: - Gesture Recognizer
    

}
