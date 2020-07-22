//
//  NewsHeaderCellView.swift
//  NewsViewer
//
//  Created by Duy Nguyen on 7/21/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import UIKit

class NewsHeaderCellView: UICollectionReusableView {
    @IBOutlet weak var dateText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setTodayDate()
        // Initialization code
    }
    
    func setTodayDate() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, LLLL dd"
        let nameOfMonth = dateFormatter.string(from: date).uppercased()
        
        
        
        dateText.text = nameOfMonth
    }
}
