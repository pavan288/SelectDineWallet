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
import SwiftyJSON

class ViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate, GIDSignInDelegate, UIScrollViewDelegate {

    @IBOutlet var homeScrollView: UIScrollView!
    let feature1 = ["image":"Accept-Money"]
    let feature2 = ["image":"Pay-Online"]
    @IBOutlet var featurePageControl: UIPageControl!
    let feature3 = ["image":"Pay-Online"]
    let feature4 = ["image":"Transfer-to-bank-1"]
    var featureArray = [Dictionary<String,String>]()
    var dict : [String : AnyObject]!
    var avatarUrl: String! = ""
    var name: String! = ""
    
    @IBOutlet var GSignIn: UIView!
    let prefs = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self

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

    //google sign in methods
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            if user.profile.hasImage{
                let imageUrl = user.profile.imageURL(withDimension: 200)
                print(" image url: ", imageUrl?.absoluteString)
                self.avatarUrl = imageUrl?.absoluteString
            }
             print("Welcome: ,\(userId!), \(fullName!), \(avatarUrl!), \(email!)")
//            print(user.profile.imageURL)
            
            self.prefs.set(self.avatarUrl!, forKey: "avatar")
            self.prefs.set(email, forKey: "socialEmail")
            self.name = fullName! as? String
            
            let loginStatus:Int = self.parseJSON()
            if loginStatus==1{
                self.presentHome()
                print("Successfully logged in via google")
            }else{
                let alert = UIAlertController(title: "Oops!", message: "Error logging in", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    
                }))
                self.present(alert, animated: true, completion: nil)
                
            }
            
            // ...
        } else {
            print("\(error.localizedDescription)")
        }
    }
       
    
    
    // Finished disconnecting |user| from the app successfully if |error| is |nil|.
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user: GIDGoogleUser!, withError error: NSError!){
        
    }
    
    //end of gogle sign in
    
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
            FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"first_name, last_name, picture.type(large),email"]).start { (connection, result, error) -> Void in
                
                if (error == nil){
                    self.dict = result as! [String : AnyObject]
                   
                    print(self.dict)
                 /*   for (key, value) in self.dict {
                        print("\(key) -> \(value)")
                    }
                     print((self.dict["picture"]!["data"]!! as! [String : AnyObject])["url"]!)*/
                    
                    self.avatarUrl = ((self.dict["picture"]!["data"]!! as! [String : AnyObject])["url"]! as? String)!

                    self.prefs.set(self.avatarUrl, forKey: "avatar")
                    self.prefs.set(self.dict["email"], forKey: "socialEmail")
                    self.name = self.dict["first_name"]! as? String
                    
                    let loginStatus:Int = self.parseJSON()
                    if loginStatus==1{
                        self.presentHome()
                        print("Successfully logged in")
                    }else{
                        let alert = UIAlertController(title: "Oops!", message: "Error logging in", preferredStyle: .actionSheet)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                            
                        }))
                        self.present(alert, animated: true, completion: nil)
                        
                    }

                    
                }
            
        
    }
    }
    }
   
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Successfully logged out")
    }
    //end of methods for facebook login
    
    func parseJSON() -> Int{
        let socialEmail:String! = self.prefs.value(forKey: "socialEmail") as! String!
        
        var status:Int = 0
        
        let urlpath = "http://35.154.46.78:1337/user/social?email=\(socialEmail!)&name=\(name!)&avatarUrl=\(avatarUrl!))".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: urlpath!)
        
        if let jsonData = try? Data(contentsOf: url! as URL, options: []){
            let readableJSON = JSON(data: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers, error: nil)
            
            _ = readableJSON["message"].string! as String
             status = readableJSON["status"].int! as Int
            
            let email = readableJSON["user"]["email"].string! as String
//            let phone = readableJSON["user"]["mobileNo"].int! as Int
            let userID = readableJSON["user"]["id"].string! as String
            let name = readableJSON["user"]["name"].string! as String
            
            if (status == 1){
                
                let alert = UIAlertController(title: "Important!", message: "Please enter your phone number", preferredStyle: .alert)
                alert.addTextField(configurationHandler: { (textfield) in
                    textfield.placeholder = "Phone number"
                })
                alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) in
                    let textField = alert.textFields![0] as UITextField
                    let number = Int(textField.text!)
                    self.prefs.set(number, forKey: "phone")
                    
                }))
                
                self.present(alert, animated: true, completion: { 
                    self.prefs.set(name, forKey: "name")
                    self.prefs.set(email, forKey: "email")
                    self.prefs.set(userID, forKey: "userID")

                })
                
                
            }else{
               let alert = UIAlertController(title: "Oops!", message: "Error logging in", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    
                }))
                self.present(alert, animated: true, completion: nil)
                
            }
        }
    return status
    }
    
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

