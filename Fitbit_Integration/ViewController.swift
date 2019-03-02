//
//  ViewController.swift
//  Fitbit_Integration
//
//  Created by Rahim Momin on 1/23/19.
//  Copyright © 2019 Momin. All rights reserved.
//

import UIKit
import OAuthSwift

class ViewController: OAuthViewController {
    // oauth swift object (retain)
    var oauthswift: OAuthSwift?
    
    lazy var internalWebViewController: WebViewController = {
        let controller = WebViewController()
        controller.delegate = self
        controller.viewDidLoad() // allow WebViewController to use this ViewController as parent to be presented
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func authorizeApp(_ sender: Any) {
        let oauthswift = OAuth2Swift(
            consumerKey:    "22DBS5",
            consumerSecret: "4ced2ce84746232997edb4a48c1c6d41",
            authorizeUrl:   "https://www.fitbit.com/oauth2/authorize",
            accessTokenUrl: "https://api.fitbit.com/oauth2/token",
            responseType:   "code"
        )
        self.oauthswift = oauthswift
        oauthswift.accessTokenBasicAuthentification = true
        //self.addChild(internalWebViewController)
        oauthswift.authorizeURLHandler = internalWebViewController
        let _ = oauthswift.authorize(
            //withCallbackURL: URL(string: "myapp://fitbit")!, scope: "profile weight", state: "state",
            withCallbackURL: URL(string: "myapp://fitbit")!, scope: "activity profile weight", state: "state",
            success: { credential, response, parameters in
                print ("success")
                //self.showTokenAlert(name: serviceParameters["name"], credential: credential)
                //self.testFitbit2(oauthswift)
        },
            failure: { error in
                print(error.description)
        })
    }
}

extension ViewController: OAuthWebViewControllerDelegate {
    func oauthWebViewControllerDidPresent() {
        
    }
    
    func oauthWebViewControllerDidDismiss() {
        
    }
    
    func oauthWebViewControllerWillAppear() {
        
    }
    
    func oauthWebViewControllerDidAppear() {
        
    }
    
    func oauthWebViewControllerWillDisappear() {
        
    }
    
    func oauthWebViewControllerDidDisappear() {
        // Ensure all listeners are removed if presented web view close
        oauthswift?.cancel()
    }
}

