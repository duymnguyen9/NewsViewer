//
//  NibLoadable.swift
//  NewsViewer
//
//  Created by Duy Nguyen on 7/23/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import UIKit

// This protocol provide a cleaner way to load nib.
protocol NibLoadable where Self: UIView {
    
    func fromNib() -> UIView?
}

extension NibLoadable {
    @discardableResult
    func fromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nibName = String(describing: type(of: self))
        
        let contentView = bundle.loadNibNamed(nibName,
                                              owner: self,
            options: nil)?.first as! UIView
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.edges(to: self)
        
        return contentView
    }
}
