//
//  ViewController.swift
//  Project4
//
//  Created by Ryordan Panter on 20/6/20.
//  Copyright © 2020 Ryordan Panter. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var progressView: UIProgressView!
    var websites = ["apple.com", "hackingwithswift.com"]
    var selectedWebsite: String?
    
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let url = URL(string: "https://" + selectedWebsite!)!
        webView.load(URLRequest(url: url))
        
        
        webView.allowsBackForwardNavigationGestures = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        // New UIProgressView Instance
        progressView = UIProgressView(progressViewStyle: .default)
        // UI ProgressView fill content fully
        progressView.sizeToFit()
        // Creates a new UIBarButtonItem using customView as it's parameter. Wrapped UIProgressView in a UIBarButton Item so that it can go into the bottom nav bar
        let progressButton = UIBarButtonItem(customView: progressView)
        
        
        // Nav Bar Bottom Buttons
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let goBack = UIBarButtonItem(title: "back", style: .plain, target: webView, action: #selector(webView.goBack))
        let goForward = UIBarButtonItem(title: "forward", style: .plain, target: webView, action: #selector(webView.goForward))
        // Nav Bar Bottom Buttons Array
        toolbarItems = [progressButton, spacer, goBack, goForward, refresh]
        // Nav Bar Bottom Displey?
        navigationController?.isToolbarHidden = false
        
        // Key Value Observer
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        
    }
    
    @objc func openTapped() {
        let ac = UIAlertController(title: "open Page", message: nil, preferredStyle: .actionSheet)
        
        // Loop through available websites
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    func openPage(action: UIAlertAction){
        guard let actionTitle = action.title else { return }
        guard let url = URL(string: "https://" + actionTitle) else { return }
        webView.load(URLRequest(url: url))
        
    }
    // Shows nav bar title once website has loaded
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
        }
        // Handles blocker or invalid website urls
        decisionHandler(.cancel)
        if let blockedHost = url?.host {
            print("Site blocked: \(blockedHost)")
            let ac = UIAlertController(title: "Blocked Website", message: blockedHost, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(ac, animated: true)
        }
        
        
    }
    


}

