//
//  HomeViewController.swift
//  NewsViewer
//
//  Created by Duy Nguyen on 7/23/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var newsCardContentViewModels: Array<NewsCardContentViewModel> = Array<NewsCardContentViewModel>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Make it responds to highlight state faster
        collectionView.delaysContentTouches = false

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            print("setting layout")
            layout.minimumLineSpacing = 20
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = .init(top: 20, left: 0, bottom: 64, right: 0)
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.clipsToBounds = false
        collectionView.register(UINib(nibName: "\(NewsCollectionViewCell.self)", bundle: nil), forCellWithReuseIdentifier: "newsCard")
        
        
        
        newsCardContentViewModels = getTestData()
        print("models count: \(newsCardContentViewModels.count)")
    }

    
    
    func getTestData() -> Array<NewsCardContentViewModel> {
        let dataService = NewsDataProvider()
        //        dataService.fetchDataFromNewsAPI()
        dataService.readLocalFile()
        return getNewsCardContentViewModels(data: dataService.newsData)
        
    }
    
    private func getNewsCardContentViewModels(data: Array<NewsArticleModel>) -> Array<NewsCardContentViewModel> {
        var viewModels = Array<NewsCardContentViewModel>()
        
        // TODO: Change Range back to data
        for newsArticleModel1 in 0...4 {
            let newsArticleModel = data[newsArticleModel1]
            
            print("resize image")
            let contentImage = getImageFromUrl(url: newsArticleModel.urlToImage)
            
            var newsTextContent = " "
            if let newsTextContentUnwrap = newsArticleModel.content {
                newsTextContent = newsTextContentUnwrap
            }
            
            viewModels.append(NewsCardContentViewModel(title: newsArticleModel.title,
                                                       publication: newsArticleModel.source.name,
                                                       image: contentImage!,
                                                       summary: newsArticleModel.description!,
                                                       textContent: newsTextContent))
        }
        
        return viewModels
    }
    
    private func getImageFromUrl(url: String?) -> UIImage?{
        if let data = try? Data(contentsOf: URL(string: url!)!){
            print("Got images!")
            print("width: \(UIScreen.main.bounds.size.width * (1/GlobalConstants.cardHighlightedFactor))")
            return UIImage(data: data)?.resize(toWidth: UIScreen.main.bounds.size.width * (1/GlobalConstants.cardHighlightedFactor))
        }
        else {
            print("Fail to get Image")
            return UIImage()
        }
    }
}


// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "newsCard", for: indexPath)
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // Number of items in section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsCardContentViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! NewsCollectionViewCell
        cell.newsCardContentView?.viewModel = newsCardContentViewModels[indexPath.row]
    }
    
    
}


// MARK: - UICollectioNViewDelegateFlowLayout
extension HomeViewController {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cardHorizontalOffset: CGFloat = 20
        let cardHeightByWidthRatio: CGFloat = 1.1
        let width = collectionView.bounds.size.width - 2 * cardHorizontalOffset
        let height: CGFloat = width * cardHeightByWidthRatio
        print("got width from sizeForItemat")
        print("width: \(width)")
        return CGSize(width: width, height: height)
    }
}
