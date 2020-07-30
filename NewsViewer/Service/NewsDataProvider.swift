//
//  NewsDataProvider.swift
//  NewsViewer
//
//  Created by Duy Nguyen on 7/16/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import Foundation

enum NewsApiDataError: Error {
    case InvalidData
    case NoData
    case InvalidReponse
    case failedRequest
}

class NewsDataProvider {
    var newsData = [NewsArticleModel]()
    
    func fetchDataFromNewsAPI(){
        let urlString = "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=db1bdfe1ef824cf6b28d51524ab4dd95"
        
        if let url = URL(string: urlString){
            if let data = try? Data(contentsOf: url){
                newsData = parseNewsArticles(json: data)
                filterNewsData()
            }
        }
    }
    
    
    // Convert json data to NewsArticle
    func parseNewsArticles(json: Data) -> [NewsArticleModel]{
        let decoder = JSONDecoder()
        
        
        if let jsonNewsArticles = try? decoder.decode(NewsArticles.self, from: json){
            print("done decoding")
            return jsonNewsArticles.articles
        } else {
            print("fail decoding")
            return []
        }
    }
    
    
    func readLocalFile(){
        guard let mainUrl = Bundle.main.url(forResource: "TestData", withExtension: "json") else {
            print("mainUrl was not available")
            return
        }
        do {                        let data = try Data(contentsOf: mainUrl)
            newsData = parseNewsArticles(json: data)
            filterNewsData()
        } catch {
            print(error)
        }
    }
    
    func filterNewsData() {
        var filteredNewsData = [NewsArticleModel]()
        for model in newsData {
            if model.urlToImage != nil {
                filteredNewsData.append(model)
            }
        }
        newsData = filteredNewsData
    }
    

}
