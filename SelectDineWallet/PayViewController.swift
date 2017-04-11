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
    let baseUrl = "http://35.154.46.78:1337"
    
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
            transferToBank()
        }else if phoneFlag == 0{
            payUser()
        }else if phoneFlag == 2{
            addCredits()
        }
    }
    
    
    func addCredits(){
        if let number = phNumber.text , let amt = amount.text{
            let urlpath = "\(baseUrl)/payment/addMoneyToWalletFromAccount?id=\(prefs.value(forKey: "userID")!)&amount=\(amt)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let url = URL(string: urlpath!)
            if let jsonData = try? Data(contentsOf: url! as URL, options: []) {
            let readableJSON = JSON(data: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers, error: nil)
        //    if readableJSON.exists(){
            let status = readableJSON["status"].int! as Int
            
            if status == 9995{
                let alert = UIAlertController(title: "Error!", message: "User not found", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                    // perhaps use action.title here
                })
                self.present(alert, animated: true)
                
            }else if status == 9999{
                let alert = UIAlertController(title: "Error!", message: "Please check your data", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                    // perhaps use action.title here
                })
                self.present(alert, animated: true)
                
            }else if status == 9997{
                let alert = UIAlertController(title: "Success!", message: "Credits added!", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                    // perhaps use action.title here
                })
                self.present(alert, animated: true)
                
            }else{
                let alert = UIAlertController(title: "Error", message: "An error occured! Please try again later!", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                    // perhaps use action.title here
                })
                self.present(alert, animated: true)
            }
            }
            
        }else{
            let alert = UIAlertController(title: "Login", message: "Please enter an amount", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                // perhaps use action.title here
            })
            self.present(alert, animated: true)
        }
    
    }
    
    func transferToBank(){
        if let number = phNumber.text {
            let urlpath = "\(baseUrl)/payment/ifPayWithReceiversMobileNo?mobileNo=\(Int(number)!)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let url = URL(string: urlpath!)
            
            let jsonData = try? Data(contentsOf: url! as URL, options: [])
            let readableJSON = JSON(data: jsonData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers, error: nil)
            
            let status = readableJSON["status"].int! as Int
            let userid = readableJSON["userId"].string! as String
            
            if(status == 597){
                let urlpath = "\(baseUrl)/payment/paymentReceiveBegin?receiverId=\(userid)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                let url = URL(string: urlpath!)
                
                let jsonData = try? Data(contentsOf: url! as URL, options: [])
                let readableJSON = JSON(data: jsonData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers, error: nil)
                
                let status = readableJSON["status"].int! as Int
                let message = readableJSON["message"].string! as String
                print(status)
                print(message)
                
                if status == 5657{
                    let urlpath = "\(baseUrl)/payment/walletToBankTransfer?userId=\(userid)&amount=\(amount.text!)&reason=\(reason.text!)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    let url = URL(string: urlpath!)
                    
                    let jsonData = try? Data(contentsOf: url! as URL, options: [])
                    let readableJSON = JSON(data: jsonData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers, error: nil)
                    let status = readableJSON["status"].int! as Int
                    let message = readableJSON["message"].string! as String
                    print(status)
                    print(message)
                    
                    if status == 6602{
                        let alert = UIAlertController(title: "Error!", message: "\(message)", preferredStyle: .actionSheet)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                            // perhaps use action.title here
                        })
                        self.present(alert, animated: true)
                    }else if status == 611{
                        let alert = UIAlertController(title: "Error!", message: "\(message)", preferredStyle: .actionSheet)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                            // perhaps use action.title here
                        })
                        self.present(alert, animated: true)
                    }else if status == 613{
                        let alert = UIAlertController(title: "Error!", message: "\(message)", preferredStyle: .actionSheet)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                            // perhaps use action.title here
                        })
                        self.present(alert, animated: true)
                    }
                }else if status == 5655{
                    let alert = UIAlertController(title: "Error!", message: "Cannot find user", preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                    })
                    self.present(alert, animated: true)
                }
                
                
            }else{
                let alert = UIAlertController(title: "Error", message: "User not found", preferredStyle: .actionSheet)
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
   
    func payUser(){
        if let number = phNumber.text , let amt = amount.text {
            let reason = self.reason.text!
            if (number != "") && (amt != ""){
             let urlpath = "\(baseUrl)/payment/ifPayWithReceiversMobileNo?mobileNo=\(number)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let url = URL(string: urlpath!)
            let jsonData = try? Data(contentsOf: url! as URL, options: [])
            let readableJSON = JSON(data: jsonData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers, error: nil)
            let status = readableJSON["status"].int! as Int
            let userid = readableJSON["userId"].string! as String
            
            if(status == 597){
                let urlpath = "\(baseUrl)/payment/paymentReceiveBegin?receiverId=\(userid)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                let url = URL(string: urlpath!)
                let jsonData = try? Data(contentsOf: url! as URL, options: [])
                let readableJSON = JSON(data: jsonData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers, error: nil)
                
                let status = readableJSON["status"].int! as Int
                let message = readableJSON["message"].string! as String
                print(status)
                print(message)
                
                if status == 5657{
                    let urlpath = "\(baseUrl)/payment/walletToBankTransfer?userId=\(userid)&amount=\(amt)&reason=\(reason)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    let url = URL(string: urlpath!)
                    let jsonData = try? Data(contentsOf: url! as URL, options: [])
                    let readableJSON = JSON(data: jsonData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers, error: nil)
                    let status = readableJSON["status"].int! as Int
                    let message = readableJSON["message"].string! as String
                    print(status)
                    print(message)
                    
                    if status == 6602{
                        let alert = UIAlertController(title: "Error!", message: "\(message)", preferredStyle: .actionSheet)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                            // perhaps use action.title here
                        })
                        self.present(alert, animated: true)
                    }else if status == 611{
                        let alert = UIAlertController(title: "Error!", message: "\(message)", preferredStyle: .actionSheet)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                        })
                        self.present(alert, animated: true)
                    }else if status == 613{
                        let alert = UIAlertController(title: "Error!", message: "\(message)", preferredStyle: .actionSheet)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                        })
                        self.present(alert, animated: true)
                    }
                }else if status == 5655{
                    let alert = UIAlertController(title: "Error!", message: "Cannot find user", preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                    })
                    self.present(alert, animated: true)
                }
            }else{
                let alert = UIAlertController(title: "Error!", message: "Cannot find user", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                })
                self.present(alert, animated: true)
            }
        }else{
            let alert = UIAlertController(title: "Error!", message: "Please enter all the fields", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
            })
            self.present(alert, animated: true)
        }
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
