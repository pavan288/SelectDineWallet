//
//  ProfileTabViewController.swift
//  SelectDineWallet
//
//  Created by Pavan Powani on 03/04/17.
//  Copyright © 2017 Pavan Powani. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn

class ProfileTabViewController: UIViewController{
    
    let prefs = UserDefaults.standard
    @IBOutlet var phone: UILabel!
    @IBOutlet var name: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       if let profilePhone = prefs.value(forKey: "phone") as! Int?,
        let profileName = prefs.value(forKey: "name") as! String?{
        phone.text = String(describing: profilePhone)
        name.text = profileName}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        prefs.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        
        let googleLoginManager = GIDSignIn()
        googleLoginManager.signOut()
        
        let vc:UIViewController? = self.storyboard?.instantiateViewController(withIdentifier: "ViewController")
        self.present(vc!, animated: true, completion: nil)
    }


  

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "UpdateAccount" {
            let destinationVC = segue.destination as! UpdateAccViewController
            let userId = prefs.value(forKey: "userID")
            destinationVC.userId = userId as! String
           
        }
    }
    

}
