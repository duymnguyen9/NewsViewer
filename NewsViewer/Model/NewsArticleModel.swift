//
//  NewsArticleModel.swift
//  NewsViewer
//
//  Created by Duy Nguyen on 7/16/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import Foundation


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
