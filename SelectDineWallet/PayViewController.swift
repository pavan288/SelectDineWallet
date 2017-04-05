//
//  PayViewController.swift
//  SelectDineWallet
//
//  Created by Pavan Powani on 04/04/17.
//  Copyright © 2017 Pavan Powani. All rights reserved.
//

import UIKit
import SwiftyJSON

class PayViewController: UIViewController {

    var defaultNumber:Int!
    var phoneFlag:Int = 0
    @IBOutlet var phNumber: UITextField!
    @IBOutlet var amount: UITextField!
    @IBOutlet var reason: UITextField!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if phoneFlag == 0{
            return
        }else{
            phNumber.text = String(defaultNumber!)
            phNumber.isUserInteractionEnabled = false
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
