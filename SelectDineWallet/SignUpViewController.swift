//
//  SignUpViewController.swift
//  SelectDineWallet
//
//  Created by Pavan Powani on 26/03/17.
//  Copyright © 2017 Pavan Powani. All rights reserved.
//

import UIKit
import SwiftyJSON

class SignUpViewController: UIViewController {

    @IBOutlet var name: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var phone: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func parseJSON(){
        
        let mobile = Int(phone.text!)

        let urlpath = "http://35.154.46.78:1337/user/signup?name=\(name.text!)&email=\(email.text!)&password=\(password.text!)&mobileNo=\(mobile!)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: urlpath!)
        
        //print(url)
//            let url = URL(string: "http: //35.154.46.78:1337/user/signup?name=abc&email=abc.xyz.com&password=123456&mobileNo=9988776655")
            let jsonData = try? Data(contentsOf: url! as URL, options: [])
            let readableJSON = JSON(data: jsonData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers, error: nil)
        
        let message = readableJSON["message"].string! as String
        let status = readableJSON["status"].int! as Int
        print("\(status):\(message)")
        
        let alert = UIAlertController(title: "Sign Up", message: "\(message)", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
            // perhaps use action.title here
        })
        self.present(alert, animated: true)
            
    }
    
    @IBAction func SignUpPressed(_ sender: Any) {
            parseJSON()
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
