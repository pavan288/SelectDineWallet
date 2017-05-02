//
//  LoginViewController.swift
//  SelectDineWallet
//
//  Created by Pavan Powani on 24/03/17.
//  Copyright © 2017 Pavan Powani. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import SwiftyJSON

class LoginViewController: UIViewController {
 let firstScreen = ViewController()
    
    @IBOutlet var password: UITextField!
    @IBOutlet var username: UITextField!
    
    
    
    let prefs = UserDefaults.standard
    let baseUrl = "http://35.154.46.78:1337"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstScreen.fbButtonInit()
      self.hideKeyboard()
        // Do any additional setup after loading the view.
    }
    
    func parseJSON() -> Int{
        var status:Int! = 0
        let urlpath = "\(baseUrl)/user/login?email=\(username.text!)&password=\(password.text!)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: urlpath!)

        if let jsonData = try? Data(contentsOf: url! as URL, options: []){
        let readableJSON = JSON(data: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers, error: nil)
        
        let message = readableJSON["message"].string! as String
        status = readableJSON["status"].int! as Int
            if(status == 2006){
        let email = readableJSON["email"].string! as String
        let phone = readableJSON["mobile"].int! as Int
        let userID = readableJSON["userid"].string! as String
        let name = readableJSON["user"]["name"].string! as String
        prefs.set(userID, forKey: "userID")
        prefs.set(email, forKey: "email")
        prefs.set(phone, forKey: "phone")
        prefs.set(name, forKey: "name")
        print("\(status):\(message)")
            }
        let alert = UIAlertController(title: "Login", message: "\(message)", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
            // perhaps use action.title here
        })
    }
        return status
        
    }

    
    @IBAction func loginPressed(_ sender: Any) {
        let status = parseJSON()
        if(status==2006){
            let appDelegate = UIApplication.shared.delegate! as! AppDelegate
            
            let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "Home")
            appDelegate.window?.rootViewController = initialViewController
            appDelegate.window?.makeKeyAndVisible()
        }
        else{
         let alert = UIAlertController(title: "No connection!", message: "Please check your connection", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                
            }))
            self.present(alert, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
