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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstScreen.fbButtonInit()
      
        // Do any additional setup after loading the view.
    }
    
    func parseJSON() -> Int{
        
        let urlpath = "http://35.154.46.78:1337/user/login?email=\(username.text!)&password=\(password.text!)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: urlpath!)

        let jsonData = try? Data(contentsOf: url! as URL, options: [])
        let readableJSON = JSON(data: jsonData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers, error: nil)
        
        let message = readableJSON["message"].string! as String
        let status = readableJSON["status"].int! as Int
        print("\(status):\(message)")
        let alert = UIAlertController(title: "Login", message: "\(message)", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
            // perhaps use action.title here
        })
     /*   self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // your code here
            alert.dismiss(animated: true, completion: nil)
        }*/
        
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
