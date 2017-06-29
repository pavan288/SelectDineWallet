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
    
    var params : PUMRequestParams = PUMRequestParams.shared()
    var utils : Utils = Utils()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if phoneFlag == 0{
            return
        }else{
            if (defaultNumber != nil){
            phNumber.text = String(defaultNumber!)
            phNumber.isUserInteractionEnabled = false
            }
        }
        
        // Do any additional setup after loading the view.
        self.hideKeyboard()
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
    
    func showAlertViewWithTitle(title : String,message:String) -> Void {
        let alertController : UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("OK Pressed")
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func startPayment() -> Void {
        if((amount.text) != nil){
            if (Double(amount.text!)! > 1000000.00) {
                showAlertViewWithTitle(title: "Amount Exceeding the limit", message: "1000000")
                return
            }
            params.amount = amount.text;
        }
        //PUMEnvironment.test for test environment and PUMEnvironment.production for live environment.
        params.environment = PUMEnvironment.test;
        params.firstname = "";
        params.key = "kgJ4kDdQ";
        params.merchantid = "4945381";  //Merchant merchantid
        params.logo_url = ""; //Merchant logo_url
        params.productinfo = "Product Info";
        params.email = "";  //user email
        params.phone = ""; //user phone
        params.txnid = utils.getRandomString(2);  //set your correct transaction id here
        params.surl = "https://www.payumoney.com/mobileapp/payumoney/success.php";
        params.furl = "https://www.payumoney.com/mobileapp/payumoney/failure.php";
        
        //Below parameters are optional. It is to store any information you would like to save in PayU Database regarding trasnsaction. If you do not intend to store any additional info, set below params as empty strings.
        
        params.udf1 = "";
        params.udf2 = "";
        params.udf3 = "";
        params.udf4 = "";
        params.udf5 = "";
        params.udf6 = "";
        params.udf7 = "";
        params.udf8 = "";
        params.udf9 = "";
        params.udf10 = "";
        //We strictly recommend that you calculate hash on your server end. Just so that you can quickly see demo app working, we are providing a means to do it here. Once again, this should be avoided.
        if(params.environment == PUMEnvironment.production){
            calculateHashFromServer()
        }
        else{
            calculateHashFromServer()
        }
        // assign delegate for payment callback.
        params.delegate = self;
    }
    
    func startPaymentFlow() -> Void {
        let paymentVC : PUMMainVController = PUMMainVController()
        var paymentNavController : UINavigationController;
        paymentNavController = UINavigationController(rootViewController: paymentVC);
        self.present(paymentNavController, animated: true, completion: nil)
    }
    
    func transactionCompleted(withResponse response : NSDictionary,errorDescription error:NSError) -> Void {
        self.dismiss(animated: true){
            self.showAlertViewWithTitle(title: "Message", message: "congrats! Payment is Successful")
        }
    }
    
    
    func transactinFailed(withResponse response : NSDictionary,errorDescription error:NSError) -> Void {
        self.dismiss(animated: true){
            self.showAlertViewWithTitle(title: "Message", message: "Oops!!! Payment Failed")
        }
    }
    
    func prepareHashBody()->NSString{
        return "key=\(params.key!)&amount=\(params.amount!)&txnid=\(params.txnid!)&productinfo=\(params.productinfo!)&email=\(params.email!)&firstname=\(params.firstname!)" as NSString;
    }
    
    func calculateHashFromServer(){
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let url = URL(string: "https://test.payumoney.com/payment/op/v1/calculateHashForTest")!
        var request = URLRequest(url: url)
        request.httpBody = prepareHashBody().data(using: String.Encoding.utf8.rawValue)
        request.httpMethod = "POST"
        
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]{
                        //Implement your logic
                        print(json)
                        let status : NSNumber = json["status"] as! NSNumber
                        if(status.intValue == 0)
                        {
                            self.params.hashValue = json["result"] as! String!
                            OperationQueue.main.addOperation {
                                self.startPaymentFlow()
                            }
                        }
                        else{
                            OperationQueue.main.addOperation {
                                self.showAlertViewWithTitle(title: "Message", message: json["message"] as! String)
                            }
                        }
                    }
                } catch {
                    print("error in JSONSerialization")
                }
            }
        })
        task.resume()
    }

    
    
    func addCredits(){
        if let number = phNumber.text , let amt = amount.text{
            let urlpath = "\(baseUrl)/payment/addMoneyToWalletFromAccount?id=\(prefs.value(forKey: "userID")!)&amount=\(amt)&accessToken=accessToken".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
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
            }else{
                let alert = UIAlertController(title: "Oops!", message: "Please check your connection!", preferredStyle: .actionSheet)
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
    
    func transferToBank(){
        if let number = phNumber.text {
            let urlpath = "\(baseUrl)/payment/ifPayWithReceiversMobileNo?mobileNo=\(Int(number)!)&accessToken=accessToken".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let url = URL(string: urlpath!)
            
            if let jsonData = try? Data(contentsOf: url! as URL, options: []){
            let readableJSON = JSON(data: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers, error: nil)
            
            let status = readableJSON["status"].int! as Int
            let userid = readableJSON["userId"].string! as String
            
            if(status == 597){
                let urlpath = "\(baseUrl)/payment/paymentReceiveBegin?receiverId=\(userid)&accessToken=accessToken".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                let url = URL(string: urlpath!)
                
                if let jsonData = try? Data(contentsOf: url! as URL, options: []){
                let readableJSON = JSON(data: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers, error: nil)
                
                let status = readableJSON["status"].int! as Int
                let message = readableJSON["message"].string! as String
                print(status)
                print(message)
                
                if status == 5657{
                    let urlpath = "\(baseUrl)/payment/walletToBankTransfer?userId=\(userid)&amount=\(amount.text!)&reason=\(reason.text!)&accessToken=accessToken".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
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
                
                }
            }else{
                let alert = UIAlertController(title: "Error", message: "User not found", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                    // perhaps use action.title here
                })
                self.present(alert, animated: true)

            }
            }else{
                let alert = UIAlertController(title: "Oops!", message: "Please check your connection!", preferredStyle: .actionSheet)
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
             let urlpath = "\(baseUrl)/payment/ifPayWithReceiversMobileNo?mobileNo=\(number)&accessToken=accessToken".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let url = URL(string: urlpath!)
              if let jsonData = try? Data(contentsOf: url! as URL, options: []){
            let readableJSON = JSON(data: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers, error: nil)
            let status = readableJSON["status"].int! as Int
            let userid = readableJSON["userId"].string! as String
            
            if(status == 597){
                let urlpath = "\(baseUrl)/payment/paymentReceiveBegin?receiverId=\(userid)&accessToken=accessToken".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                let url = URL(string: urlpath!)
                let jsonData = try? Data(contentsOf: url! as URL, options: [])
                let readableJSON = JSON(data: jsonData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers, error: nil)
                
                let status = readableJSON["status"].int! as Int
                let message = readableJSON["message"].string! as String
                print(status)
                print(message)
                
                if status == 5657{
                    let urlpath = "\(baseUrl)/payment/walletToBankTransfer?userId=\(userid)&amount=\(amt)&reason=\(reason)&accessToken=accessToken".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
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
                let alert = UIAlertController(title: "Oops!", message: "Please check your connection!", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                    // perhaps use action.title here
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
