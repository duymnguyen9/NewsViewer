//
//  CollectionViewCell.swift
//  NewsViewer
//
//  Created by Duy Nguyen on 7/16/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import UIKit

class CollectionViewCell: BaseCardCell {
    
    @IBOutlet weak var newsImage: UIImageView!
    
    @IBOutlet weak var newsSite: UILabel!
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var cardContent: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        
        
        cardContentSetup()
//        viewContentShadowSetup()
    }
    
    func setContent(_ data: NewsArticleModel){
        newsSite.text = data.source.name
        title.text = formattingTitle(data)
        setImageContent(data)
    }
    
    func setImageContent(_ data: NewsArticleModel){
        guard let urlString = data.urlToImage else { return }
        
        
        if let url = URL(string: urlString)
        {
            newsImage.image = UIImage(data: fetchImageData(url)!)
        }
    }
    
    
    func formattingTitle(_ data:  NewsArticleModel) -> String{
        
        guard let dashIndex = data.title.lastIndex(of: "-") else {
            print("title doesn't contain dash -> Display full title")
            return data.title
        }
        
        
        let newTitle = data.title.prefix(upTo: dashIndex)
        
        return String(newTitle)
    }

    
    func fetchImageData(_ url: URL) -> Data?{
        if let data = try? Data(contentsOf: url){
            return data
        }
        else { return nil}
        
    }
    
    func cardContentSetup(){
        cardContent.translatesAutoresizingMaskIntoConstraints = false
        cardContent.layer.cornerRadius = cornerRadius
        cardContent.layer.borderWidth = 1.0
        cardContent.layer.borderColor = UIColor.clear.cgColor
        cardContent.layer.masksToBounds = true
        cardContent.clipsToBounds = true
    }
}


// MARK: - Layout Attributes
extension CollectionViewCell {
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        return layoutAttributes
    }
}


