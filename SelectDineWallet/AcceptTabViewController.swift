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
    
    let prefs = UserDefaults.standard
    @IBOutlet var testImage: UIImageView!
    let baseUrl = "http://35.154.46.78:1337"
    var qrdata:String! = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        parseJSON()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func parseJSON(){
        let uid = prefs.string(forKey: "userID")
        if prefs.string(forKey: "qrcodestirng") == nil{
            if let urlpath = "\(baseUrl)/qrcode/generateqrcodeforios?id=58da840b398f3941387346b9"/*\(uid!)"*/.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
        let url = URL(string: urlpath)
        
                if let jsonData = try? Data(contentsOf: url! as URL, options: []){
        let readableJSON = JSON(data: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers, error: nil)
        
        qrdata = readableJSON["code"].string! as String
        prefs.set(qrdata, forKey: "qrCodeString")
        //print(qrdata!)
        
        
        let newurl = URL(string : qrdata)!
        // It Will turn Into Data
        let imageData : NSData = NSData.init(contentsOf: newurl as URL)!
        // Data Will Encode into Base64
        let str64 = imageData.base64EncodedData(options: .lineLength64Characters)
        // Now Base64 will Decode Here
        let data: NSData = NSData(base64Encoded: str64 , options: .ignoreUnknownCharacters)!
        // turn  Decoded String into Data
        let dataImage = UIImage(data: data as Data)
        // pass the data image to image View.:)
        testImage.image = dataImage
                }else{
                    if let existingQr = prefs.value(forKey: "qrCodeString"){
                     let newurl = URL(string : existingQr as! String)!
                    let imageData : NSData = NSData.init(contentsOf: newurl as URL)!
                    let str64 = imageData.base64EncodedData(options: .lineLength64Characters)
                    let data: NSData = NSData(base64Encoded: str64 , options: .ignoreUnknownCharacters)!
                    let dataImage = UIImage(data: data as Data)
            
                            testImage.image = dataImage
                }
                }
    }
}
}


}

