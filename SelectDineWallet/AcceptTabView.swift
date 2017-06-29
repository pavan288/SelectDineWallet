//
//  AcceptTabView.swift
//  SelectDineWallet
//
//  Created by Pavan Powani on 01/04/17.
//  Copyright © 2017 Pavan Powani. All rights reserved.
//

import UIKit
import SwiftyJSON

class AcceptTabView: UIViewController {

    @IBOutlet var qrcode: UIImageView!
    
    var first = LoginViewController()
    
    
    override func viewDidLoad() {
        parseJSON()
    }
    
    
    func parseJSON(){
    let qrcode = first.userID
    let urlpath = "http://35.154.46.78:1337/qrcode/generateqrcode?id=58da840b398f3941387346b9".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    let url = URL(string: urlpath!)
    
    let jsonData = try? Data(contentsOf: url! as URL, options: [])
    let readableJSON = JSON(data: jsonData! as Data, options: JSONSerialization.ReadingOptions.mutableContainers, error: nil)
        
        print(qrcode)
        
    
    }

}
