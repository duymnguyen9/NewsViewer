//
//  NewsCardContentView.swift
//  NewsViewer
//
//  Created by Duy Nguyen on 7/23/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import UIKit

@IBDesignable final class NewsCardContentView: UIView, NibLoadable {
    
    var viewModel: NewsCardContentViewModel? {
        didSet {
            publicationLabel.text = viewModel?.publication
            titleLabel.text = viewModel?.title
            imageView.image = viewModel?.image
        }
    }
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var publicationLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var imageToTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var imageToLeadingAnchor: NSLayoutConstraint!
    
    @IBOutlet weak var imageToTrailingAnchor: NSLayoutConstraint!
    @IBOutlet weak var imageToBottomAnchor: NSLayoutConstraint!
    
    @IBInspectable var backgroundImage: UIImage? {
        get {
            return self.imageView.image
        }
        
        set(image) {
            self.imageView.image = image
        }
    }
    
    
    private func cardContentSetup() {
        // make the background image stays still at the center while animating
        imageView.contentMode = .center
        
        //        imageView.contentMode = .scaleToFill
        setFontState(isHighlighted: false)
    }
    
    
    // MARK: - Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fromNib()
        cardContentSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        fromNib()
        cardContentSetup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardContentSetup()
    }
    
    func setFontState(isHighlighted: Bool){
        if isHighlighted {
            titleLabel.font = UIFont.systemFont(ofSize: 25 * GlobalConstants.cardHighlightedFactor, weight: .bold)
            publicationLabel.font = UIFont.systemFont(ofSize: 18 * GlobalConstants.cardHighlightedFactor, weight: .semibold)
        } else {
            titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
            publicationLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        }
    }
}
