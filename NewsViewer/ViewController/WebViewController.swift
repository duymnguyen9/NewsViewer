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
    
    var url: URL!
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

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
