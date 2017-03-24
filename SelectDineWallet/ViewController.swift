//
//  ViewController.swift
//  SelectDineWallet
//
//  Created by Pavan Powani on 24/03/17.
//  Copyright © 2017 Pavan Powani. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = FBSDKLoginButton()
        loginButton.center = self.view.center
        view.addSubview(loginButton)
        loginButton.delegate = self
    }

    //methods for facebook login
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil{
            print("Error logging in:\(error)")
            return
        }
        print("Successfully logged in")
    }
   
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Successfully logged out")
    }
    //end of methods for facebook login

}

