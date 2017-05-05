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

class ViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate,UIScrollViewDelegate {

    @IBOutlet var homeScrollView: UIScrollView!
    let feature1 = ["image":"Accept-Money"]
    let feature2 = ["image":"Pay-Online"]
    @IBOutlet var featurePageControl: UIPageControl!
    let feature3 = ["image":"Pay-Online"]
    let feature4 = ["image":"Transfer-to-bank-1"]
    var featureArray = [Dictionary<String,String>]()
    
    @IBOutlet var GSignIn: UIView!
    let prefs = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signInSilently()
        fbButtonInit()
        
        featureArray = [feature1,feature2,feature3,feature4]
        homeScrollView.isPagingEnabled = true
        homeScrollView.contentSize = CGSize(width: 250 * CGFloat(featureArray.count), height: 225)
        homeScrollView.showsHorizontalScrollIndicator = false
        homeScrollView.delegate = self
        loadFeatures()
        
        if (prefs.value(forKey: "userID") != nil){
        presentHome()
        }
        
    }
    
    func loadFeatures(){
        for(index,feature) in featureArray.enumerated(){
            if let featureView = Bundle.main.loadNibNamed("LoginScroller", owner: self, options: nil)?.first as? LoginScrollView {
                featureView.coverImage.image = UIImage(named:feature["image"]!)
                homeScrollView.addSubview(featureView)
                featureView.frame.size.width = 250
                featureView.frame.origin.x = CGFloat(index) * 250
                
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.size.width
        featurePageControl.currentPage = Int(page)
    }
    
    func presentHome(){
        
            let appDelegate = UIApplication.shared.delegate! as! AppDelegate
            let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "Home")
            appDelegate.window?.rootViewController = initialViewController
            appDelegate.window?.makeKeyAndVisible()
        
    }
  
    
    
    func fbButtonInit(){
        let loginButton = FBSDKLoginButton(frame: CGRect(x: 90, y: 400, width: 200, height: 40))
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
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
}
    func dismissKeyboard()
    {
        view.endEditing(true)
    }
}

