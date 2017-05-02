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

    @IBOutlet var GSignIn: UIView!
    let prefs = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signInSilently()
        fbButtonInit()
        
        
        if (prefs.value(forKey: "userID") != nil){
        presentHome()
        }
        
    }
    func presentHome(){
        
            let appDelegate = UIApplication.shared.delegate! as! AppDelegate
            let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "Home")
            appDelegate.window?.rootViewController = initialViewController
            appDelegate.window?.makeKeyAndVisible()
        
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
        }else{
        print("Successfully logged in")
        presentHome()
    }
    }
   
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Successfully logged out")
    }
    //end of methods for facebook login
     
}
extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
}
    func dismissKeyboard()
    {
        view.endEditing(true)
    }
}

