//
//  NewsCollectionViewCell.swift
//  NewsViewer
//
//  Created by Duy Nguyen on 7/23/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import UIKit

final class NewsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var newsCardContentView: NewsCardContentView!
    
    
    var disabledHighlightedAnimation = false

    func resetTransform() {
        transform = .identity
    }

    func freezeAnimations() {
        disabledHighlightedAnimation = true
        layer.removeAllAnimations()
    }

    func unfreezeAnimations() {
        disabledHighlightedAnimation = false
    }

    override func awakeFromNib() {
        backgroundColor = .clear
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = .init(width: 0, height: 4)
        layer.shadowRadius = 12
    }

    
    // MARK: - Animation when touch
    // Make it appears very responsive to touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animate(isHighlighted: true)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animate(isHighlighted: false)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animate(isHighlighted: false)
    }

    
    // this function transforms the collection view cell to scale down when touch,
    // and return to regular size when 
    private func animate(isHighlighted: Bool, completion: ((Bool) -> Void)?=nil) {
        if disabledHighlightedAnimation{
            return
        }
        
        let animationOptions: UIView.AnimationOptions = GlobalConstants.isEnabledAllowsUserInteractionWhileHighlightingCard ? [.allowUserInteraction] : []
        
        
        if isHighlighted {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: animationOptions, animations: {
                            self.transform = .init(scaleX: GlobalConstants.cardHighlightedFactor, y: GlobalConstants.cardHighlightedFactor)
            }, completion: completion)
        } else {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0,
                           options: animationOptions, animations: {
                            self.transform = .identity
            }, completion: completion)
        }
    }

    
}
