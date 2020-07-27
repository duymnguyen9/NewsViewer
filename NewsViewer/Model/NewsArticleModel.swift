//
//  NewsArticleModel.swift
//  NewsViewer
//
//  Created by Duy Nguyen on 7/16/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import Foundation
import UIKit


struct NewsArticleModel: Codable{
    let source: Source
    let author: String?
    let title: String
    var description: String?
    let url: String
    var urlToImage: String?
    let publishedAt: String
    var content: String?
}

struct NewsArticles: Codable{
    let articles: [NewsArticleModel]
}


struct Source: Codable {
    let id: String?
    let name: String
}

struct TestResults: Codable{
    let totalResults: Int
}


// MARK: - Convert NewsArticleModel to ViewModel
extension NewsArticleModel {
    func toNewsCardContentViewModel() -> NewsCardContentViewModel {
        let contentImage = getImageFromUrl(url: self.urlToImage)
        
        var newsTextContent = " "
        if let newsTextContentUnwrap = self.content {
            newsTextContent = newsTextContentUnwrap
        }
        
        return NewsCardContentViewModel(title: self.title,
                                        publication: self.source.name,
                                        image: contentImage!,
                                        summary: self.description!,
                                        textContent: newsTextContent)
    }
    
    private func getImageFromUrl(url: String?) -> UIImage?{
        if let data = try? Data(contentsOf: URL(string: url!)!){
            return UIImage(data: data)?.resize(toWidth: UIScreen.main.bounds.size.width * (1/GlobalConstants.cardHighlightedFactor))
        }
        else {
            print("Fail to get Image")
            return UIImage()
        }
    }
}
