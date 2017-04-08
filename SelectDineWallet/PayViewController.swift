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
    let prefs = UserDefaults.standard
    
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

    @IBAction func confirmPressed(_ sender: UIButton) {
        if phoneFlag == 1{
            payUser()
        }else if phoneFlag == 0{
            
        receivePayment()
    }
    }
    
    func payUser(){
        if let number = phNumber.text {
            let urlpath = "http://35.154.46.78:1337/payment/ifPayWithReceiversMobileNo?mobileNo=\(Int(number)!)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let url = URL(string: urlpath!)
            
            let jsonData = try? Data(contentsOf: url! as URL, options: [])
            let readableJSON = JSON(data: jsonData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers, error: nil)
            
            let status = readableJSON["status"].int! as Int
            let userid = readableJSON["userId"].string! as String
            
            if(status == 597){
                let urlpath = "http://35.154.46.78:1337/payment/paymentReceiveBegin?receiverId=\(userid)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                let url = URL(string: urlpath!)
                
                let jsonData = try? Data(contentsOf: url! as URL, options: [])
                let readableJSON = JSON(data: jsonData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers, error: nil)
                
                let status = readableJSON["status"].int! as Int
                let message = readableJSON["message"].string! as String
                print(status)
                print(message)
            }else{
                let alert = UIAlertController(title: "Login", message: "Cannot find user", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                    // perhaps use action.title here
                })
                self.present(alert, animated: true)

            }
        }else{
            let alert = UIAlertController(title: "Login", message: "Please enter an amount", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                // perhaps use action.title here
            })
            self.present(alert, animated: true)
        }
    }
   
    func receivePayment(){
        if let amt = Int(amount.text!){
        let urlpath = "http://35.154.46.78:1337/payment/walletToBankTransfer?userId=\(prefs.value(forKey: "userID"))&amount=\(amt)&reason=".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: urlpath!)
        
        let jsonData = try? Data(contentsOf: url! as URL, options: [])
        let readableJSON = JSON(data: jsonData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers, error: nil)
        
        let message = readableJSON["message"].string! as String
        
        print(prefs.value(forKey: "userID")!)
        print(message)
        }else{
            let alert = UIAlertController(title: "Login", message: "Please enter an amount", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                // perhaps use action.title here
            })
            self.present(alert, animated: true)
        }
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
