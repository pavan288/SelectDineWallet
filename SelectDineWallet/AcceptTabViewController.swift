//
//  AcceptTabViewController.swift
//  SelectDineWallet
//
//  Created by Pavan Powani on 01/04/17.
//  Copyright © 2017 Pavan Powani. All rights reserved.
//

import UIKit
import SwiftyJSON

class AcceptTabViewController: UIViewController,UIWebViewDelegate {

    @IBOutlet var qrcode: UIWebView!
    
    let prefs = UserDefaults.standard
    
    var qrdata:String! = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        qrcode.delegate = self
        // Do any additional setup after loading the view.
        parseJSON()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func parseJSON(){
        let uid = prefs.string(forKey: "userID")
        let urlpath = "http://35.154.46.78:1337/qrcode/generateqrcode?id=\(uid!)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: urlpath!)
        
        let jsonData = try? Data(contentsOf: url! as URL, options: [])
        let readableJSON = JSON(data: jsonData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers, error: nil)
        
        qrdata = readableJSON["code"].string! as String
        
        qrcode.loadHTMLString(qrdata, baseURL: nil)
        
       
    }
    

    
}
