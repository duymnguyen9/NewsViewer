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
            newsTextContent = newsTextContentUnwrap + newsTextContentUnwrap
        } else {
            newsTextContent = self.description! + self.description!
        }
        
        var newsTitle = self.title
        if let dashIndex = newsTitle.lastIndex(of: "-") {
            newsTitle = String(newsTitle.prefix(upTo: dashIndex))
        }
        
        var newsAuthor = " "
        if let authorFromJson = self.author {
            newsAuthor = "By: " + authorFromJson
        }
        
        let publishedDate = getPublishedDate()
        
        return NewsCardContentViewModel(title: newsTitle,
                                        publication: self.source.name,
                                        image: contentImage!,
                                        summary: self.description!,
                                        textContent: newsTextContent,
                                        publishedDate: publishedDate,
                                        author: newsAuthor,
                                        url: url)
    }
    
    private func getImageFromUrl(url: String?) -> UIImage?{
        if let data = try? Data(contentsOf: URL(string: url!)!){
            return UIImage(data: data)?.resize(screenWidth: UIScreen.main.bounds.size.width)

        }
        else {
            print("Fail to get Image")
            return UIImage()
        }
    }
    
    private func getPublishedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from:self.publishedAt)!
        
        
        let interval = Calendar.current.dateComponents([.year, .month, .day], from: date, to: Date())

        if let year = interval.year, year > 0 {
            return year == 1 ? "\(year)" + " " + "year ago" :
                "\(year)" + " " + "years ago"
        } else if let month = interval.month, month > 0 {
            return month == 1 ? "\(month)" + " " + "month ago" :
                "\(month)" + " " + "months ago"
        } else if let day = interval.day, day > 0 {
            return day == 1 ? "\(day)" + " " + "day ago" :
                "\(day)" + " " + "days ago"
        } else if let hour = interval.hour, hour > 0 {
            return hour == 1 ? "\(hour)" + " " + "hour ago" :
            "\(hour)" + " " + "hours ago"
        }
            else {
            return "a moment ago"

        }
    }
}
