//
//  WebViewController.swift
//  Fitbit_Integration
//
//  Created by Rahim Momin on 2/24/19.
//  Copyright © 2019 Momin. All rights reserved.
//

import Foundation
import WebKit
import OAuthSwift

class WebViewController : OAuthWebViewController {
    var targetURL: URL?
    let navBar = UINavigationBar()
    let wkWebView: WKWebView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        view.backgroundColor = .white
        view.addSubview(wkWebView)
        wkWebView.navigationDelegate = self
        wkWebView.translatesAutoresizingMaskIntoConstraints = false
        let guide = view.safeAreaLayoutGuide
        wkWebView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        wkWebView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        wkWebView.topAnchor.constraint(equalTo: navBar.bottomAnchor).isActive = true
        wkWebView.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
        
        //loadAddressURL()
    }
    
    override func handle(_ url: URL) {
        targetURL = url
        super.handle(url)
        self.loadAddressURL()
    }
    
    func setNavigationBar() {
        navBar.translatesAutoresizingMaskIntoConstraints = false
        //navBar.barTintColor = view.backgroundColor
        view.addSubview(navBar)
        
        let guide = view.safeAreaLayoutGuide
        navBar.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        navBar.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        navBar.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        navBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        let navItem = UINavigationItem(title: "")
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(done))
        navItem.rightBarButtonItem = doneItem
        navBar.setItems([navItem], animated: false)
    }
    
    @objc func done() {
        dismissWebViewController()
    }
    
    func loadAddressURL() {
        guard let url = targetURL else {
            return
        }
        let urlRequest = URLRequest(url: url)
        wkWebView.load(urlRequest)
    }
}

extension WebViewController : WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url , url.scheme == "myapp" {
            OAuthSwift.handle(url: url)
            decisionHandler(.cancel)
            
            dismissWebViewController()
            return
        }
        
        decisionHandler(.allow)
    }
}
