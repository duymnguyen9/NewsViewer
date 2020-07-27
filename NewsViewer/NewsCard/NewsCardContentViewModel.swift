//
//  NewsCardContentViewModel.swift
//  NewsViewer
//
//  Created by Duy Nguyen on 7/23/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import UIKit

struct NewsCardContentViewModel {
    let title: String
    let publication: String
    let image: UIImage
    let summary: String
    let textContent: String
    
    func highlightedImage() -> NewsCardContentViewModel {
        let scaledImage = image.resize(toWidth: image.size.width * GlobalConstants.cardHighlightedFactor)
        
        return NewsCardContentViewModel(title: title,
                                        publication: publication,
                                        image: scaledImage,
                                        summary: summary,
                                        textContent: textContent)
    }
}
