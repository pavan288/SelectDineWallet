//
//  FeedbackViewController.swift
//  SelectDineWallet
//
//  Created by Pavan Powani on 30/04/17.
//  Copyright © 2017 Pavan Powani. All rights reserved.
//

import UIKit
import SwiftyJSON

class FeedbackViewController: UIViewController {

    
    @IBOutlet var feedbackText: UITextView!
    let baseUrl = "http://35.154.46.78:1337"
    let prefs = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissVC(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendPressed(_ sender: Any) {
        let uid = prefs.value(forKey: "userID")
        let urlpath = "\(baseUrl)/feedback/createFeedback?id=\(String(describing: uid))&feedback=\(feedbackText.text!)&accessToken=accessToken".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: urlpath!)
        
        if let jsonData = try? Data(contentsOf: url! as URL, options: []){
            let readableJSON = JSON(data: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers, error: nil)
            
            let status = readableJSON["status"].int! as Int
            
            if(status == 332){
                let alert = UIAlertController(title: "Success!", message: "Succesfully sent feedback", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                    // perhaps use action.title here
                })
                self.present(alert, animated: true)
            }else{
                let alert = UIAlertController(title: "Error!", message: "Could not send feedack", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                    // perhaps use action.title here
                })
                self.present(alert, animated: true)
            }
        }else{
            print("could not connect")
            
            let alert = UIAlertController(title: "Error!", message: "Unable to connect to our server", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                
            }))
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
