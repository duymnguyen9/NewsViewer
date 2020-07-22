//
//  ViewController.swift
//  NewsViewer
//
//  Created by Duy Nguyen on 7/16/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import UIKit

final class ViewController: UICollectionViewController {
    // MARK: - Properties
    var dataSource = [NewsArticleModel]()
    var collectionViewCells = [UICollectionViewCell]()
    
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 20.0, right: 0.0)
    let headerHeight: CGFloat = 100.0
    
    
    let collectionCellSpaceHeight = CGFloat(440.0)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "newsCell")
                
        collectionView.register(UINib(nibName: "NewsHeaderCellView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "newsHeaderCellView")
        
        let dataService = NewsDataProvider()
        //        dataService.fetchDataFromNewsAPI()
        dataService.readLocalFile()
        dataSource = dataService.newsData
    }
    
}

// MARK: - UICollectionViewDataSource
extension ViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
            if let newsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "newsCell", for: indexPath) as? CollectionViewCell {
                newsCell.setContent(dataSource[indexPath.row])
                cell = newsCell
            }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                   withReuseIdentifier: "newsHeaderCellView",
                                                                                   for: indexPath) as? NewsHeaderCellView else
            {
                fatalError("Invalid view type")
            }
            return headerView
        default:
            assert(false, "Invalid element type")
        }
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView( _ collectionView: UICollectionView,
                         layout collectionViewLayout: UICollectionViewLayout,
                         sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = view.frame.width - sectionInsets.left - sectionInsets.right
        return CGSize(width: itemWidth, height: collectionCellSpaceHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: headerHeight)
    }
}
