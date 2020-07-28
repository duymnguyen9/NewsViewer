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
    
    private var transition: CardTransition?
    
    var newsCardContentViewModels: Array<NewsCardContentViewModel> = Array<NewsCardContentViewModel>()
    
    //TESTING:
    var homeCellHeight: CGFloat = 0.0
    var homeCellWidth: CGFloat = 0.0
    
    // END TESTING
    
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
            
            viewModels.append(newsArticleModel.toNewsCardContentViewModel())
        }
        
        return viewModels
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
        
        let width = collectionView.bounds.size.width - 2 * GlobalConstants.cardHorizontalOffset
        let height: CGFloat = width * GlobalConstants.cardHeightByWidthRatio
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Get tapped cell location
        let cell = collectionView.cellForItem(at: indexPath) as! NewsCollectionViewCell
        
        // Freeze highlighted state (or else it will bounce back)
        cell.freezeAnimations()
        
        // Get current frame on screen
        let currentCellFrame = cell.layer.presentation()!.frame
        
        // Convert current frame to screen's coordinates
        let cardPresentationFrameOnScreen = cell.superview!.convert(currentCellFrame, to: nil)
        
        // Get card frame without transform in screen's coordinates (for the dismissing back later to original location)
        let cardFrameWithoutTransform = { () -> CGRect in
            let center = cell.center
            let size = cell.bounds.size
            let r = CGRect(
                x: center.x - size.width / 2,
                y: center.y - size.height / 2,
                width: size.width,
                height: size.height
            )
            return cell.superview!.convert(r, to: nil)
        }()
        
        let cardModel = newsCardContentViewModels[indexPath.row]
        
        // Set up card detail view controller
        let vc = storyboard!.instantiateViewController(withIdentifier: "cardDetailVc") as! CardDetailViewController
        vc.cardViewModel = cardModel.highlightedImage()
        vc.unhighlightedCardViewModel = cardModel
        
        let params = CardTransition.Params(fromCardFrame: cardPresentationFrameOnScreen,
                                           fromCardFrameWithoutTransform: cardFrameWithoutTransform,
                                           fromCell: cell)
        transition = CardTransition(params: params)
        vc.transitioningDelegate = transition
        
        // If 'modalPresentationStyle' is not ".fullscreen', this should be set to true to make status bar depends on presented vc.
        vc.modalPresentationCapturesStatusBarAppearance = false
        vc.modalPresentationStyle = .custom
        
        present(vc, animated: true, completion: { [unowned cell] in
            // Unfreeze
            cell.unfreezeAnimations()
        })
    }
}
