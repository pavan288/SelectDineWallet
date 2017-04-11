//
//  IFSCViewController.swift
//  SelectDineWallet
//
//  Created by Pavan Powani on 08/04/17.
//  Copyright © 2017 Pavan Powani. All rights reserved.
//

import UIKit

class IFSCViewController: UIViewController {

    @IBOutlet var bankName: UITextField!
    @IBOutlet var stateName: UITextField!
    @IBOutlet var cityName: UITextField!
    @IBOutlet var branchName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

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
