//
//  WalletTabViewController.swift
//  SelectDineWallet
//
//  Created by Pavan Powani on 05/04/17.
//  Copyright © 2017 Pavan Powani. All rights reserved.
//

import UIKit

class WalletTabViewController: UIViewController {
    
    let prefs = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "WalletBank" {
            let destinationVC = segue.destination as! PayViewController
            let phoneNumber = prefs.value(forKey: "phone")
            destinationVC.defaultNumber = phoneNumber as! Int!
            destinationVC.phoneFlag = 1
            
        }else if segue.identifier == "WalletCredits"{
            let destinationVC = segue.destination as! PayViewController
            let phoneNumber = prefs.value(forKey: "phone")
            destinationVC.defaultNumber = phoneNumber as! Int!
            destinationVC.phoneFlag = 1
    
        }

    }
}
