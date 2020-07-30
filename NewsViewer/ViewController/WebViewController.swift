//
//  WebViewController.swift
//  NewsViewer
//
//  Created by Duy Nguyen on 7/29/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    var webView: WKWebView!
    var progressView: UIProgressView!
    
    // TODO: Add URL from CardDetailViewController
    var url: URL!
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        url = URL(string: "https://hackingwithswift.com")!

        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
