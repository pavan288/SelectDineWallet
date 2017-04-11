//
//  PaymentView.swift
//  SelectDineWallet
//
//  Created by Pavan Powani on 03/04/17.
//  Copyright © 2017 Pavan Powani. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController {
    
    let prefs = UserDefaults.standard

    @IBOutlet var PayView: UIView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func viewDidLoad() {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Payment" {
            let destinationVC = segue.destination as! PayViewController
            let phoneNumber = prefs.value(forKey: "phone")
            destinationVC.defaultNumber = phoneNumber as! Int
            destinationVC.phoneFlag = 0
            
        }
    }

}
