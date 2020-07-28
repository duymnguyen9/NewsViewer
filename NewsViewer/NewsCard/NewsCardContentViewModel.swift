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
    let publishedDate: String
    let author: String
    
    func highlightedImage() -> NewsCardContentViewModel {
        let scaledImage = image
//        let scaledImage = image.resizeHighlight(toHeight: image.size.width * GlobalConstants.cardHeightByWidthRatio)
        
        return NewsCardContentViewModel(title: title,
                                        publication: publication,
                                        image: scaledImage,
                                        summary: summary,
                                        textContent: textContent,
                                        publishedDate: publishedDate,
                                        author: author)
    }
}
