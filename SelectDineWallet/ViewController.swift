//
//  ViewController.swift
//  SelectDineWallet
//
//  Created by Pavan Powani on 24/03/17.
//  Copyright © 2017 Pavan Powani. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn

class ViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        fbButtonInit()
        
        let googleButton = GIDSignInButton(frame: CGRect(x: 125, y: 500, width: 100, height: 50))
        view.addSubview(googleButton)
    }
    
    @IBAction func Gsignin(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
  
    
    
    func fbButtonInit(){
        let loginButton = FBSDKLoginButton(frame: CGRect(x: 105, y: 400, width: 200, height: 40))
        //loginButton.center = self.view.center
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
