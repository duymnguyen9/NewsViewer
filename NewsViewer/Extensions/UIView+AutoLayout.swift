//
//  UIView+AutoLayout.swift
//  NewsViewer
//
//  Created by Duy Nguyen on 7/23/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import UIKit

extension UIView {
    ///Constrain 4 edges of 'self' to specified 'view'.
    func edges(to view: UIView, top: CGFloat=0, left: CGFloat=0, bottom: CGFloat=0, right: CGFloat=0) {
        NSLayoutConstraint.activate([
            self.leftAnchor.constraint(equalTo: view.leftAnchor, constant: left),
            self.rightAnchor.constraint(equalTo: view.rightAnchor, constant: right),
            self.topAnchor.constraint(equalTo: view.topAnchor, constant: top),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom)
        ])
    }
}

extension UIImage {
    /// Resize UIImage to new width keeping the image's aspect ratio.

    
    func resize(screenWidth: CGFloat) -> UIImage {
        let image = self
        var scaledSize = CGSize.init()
        let expectedHeight = screenWidth / GlobalConstants.aspectRatioNewsImage
        
        // If Width >= height, scale down to screen height to screen width and vice versa
        if image.size.width / image.size.height >= GlobalConstants.aspectRatioNewsImage {
            
            let oldHeight  = image.size.height
            let scaledFactor = expectedHeight / oldHeight
            
            let newWidth = image.size.width * scaledFactor
            let newHeight = oldHeight * scaledFactor
            
            scaledSize = CGSize(width:newWidth, height:newHeight)
        } else {
            print("smaller than aspect ratio")
            let oldWidth = image.size.width
            let scaleFactor = screenWidth / oldWidth
            
            let newHeight = image.size.height * scaleFactor
            let newWidth = oldWidth * scaleFactor
            
            scaledSize = CGSize(width:newWidth, height:newHeight)
        }
        
        UIGraphicsBeginImageContextWithOptions(scaledSize, true, image.scale)
        image.draw(in: CGRect(x: 0, y: 0, width: scaledSize.width, height: scaledSize.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }
    
    
    private func getScaleSize(expectedHeight: CGFloat, imageSize: CGSize){
        
    }
    
}
