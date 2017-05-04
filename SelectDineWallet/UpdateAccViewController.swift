//
//  UpdateAccViewController.swift
//  SelectDineWallet
//
//  Created by Pavan Powani on 08/04/17.
//  Copyright © 2017 Pavan Powani. All rights reserved.
//

import UIKit
import SwiftyJSON

class UpdateAccViewController: UIViewController, IFSCDelegate {
    
    var userId: String! = ""
    let baseUrl = "http://35.154.46.78:1337"
    @IBOutlet var accNumber: UITextField!
    @IBOutlet var accHolderName: UITextField!
    @IBOutlet var ifscCode: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
self.hideKeyboard()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func userDidEnterDetails(info: String) {
        self.ifscCode.text = info
    }
    
    
    @IBAction func savePressed(_ sender: Any) {
        let urlpath = "\(baseUrl)/account/addAccountDetails?id=\(userId!)&accountNo=\(accNumber.text!)&ifscCode=\(ifscCode.text!)&accountHolderName=\(accHolderName.text!)&accessToken=accessToken".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: urlpath!)
        
        if let jsonData = try? Data(contentsOf: url! as URL, options: []){
            let readableJSON = JSON(data: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers, error: nil)
            let status = readableJSON["status"].int! as Int
            let message = readableJSON["message"].string! as String
            print(message)
            
            if status == 1112 || status == 1104{
                let alert = UIAlertController(title: "Success!", message: "\(message)", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                    // perhaps use action.title here
                })
                self.present(alert, animated: true)
            }else if status == 1108{
                let alert = UIAlertController(title: "Error!", message: "\(message)", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                    // perhaps use action.title here
                })
                self.present(alert, animated: true)
            }else if status == 1101{
                let alert = UIAlertController(title: "Error!", message: "\(message)", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                    // perhaps use action.title here
                })
                self.present(alert, animated: true)
            }
        }else{
            let alert = UIAlertController(title: "Error!", message: "Unable to connect to our servers right now", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                
            }))
            self.present(alert, animated: true)
        }
        
        }
    
    @IBAction func dismissVC(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
    


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ifsc" {
            let secondViewController = segue.destination as! IFSCViewController
            secondViewController.delegate = self
        }
    }
    

}
