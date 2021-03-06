//
//  TransactionViewController.swift
//  SelectDineWallet
//
//  Created by Pavan Powani on 05/05/17.
//  Copyright © 2017 Pavan Powani. All rights reserved.
//

import UIKit
import SwiftyJSON

class TransactionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let prefs = UserDefaults.standard
    @IBOutlet var segementedControl: UISegmentedControl!
    @IBOutlet var transactionTableView: UITableView!
    
    var walletAmt:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transactionTableView.dataSource = self
        transactionTableView.delegate = self
        // Do any additional setup after loading the view.
        prefs.set(walletAmt, forKey: "walletBalance")
        parseJSON()
    }
    var numberOfRows = 0
    let baseUrl = "http://35.154.46.78:1337"
    
    var extra:String!
    var date:String!
    var time:String!
    var transactionId:String!
    
    var allTransactions = [transactionModel]()
    var paidTransactions = [transactionModel]()
    var receivedTransactions = [transactionModel]()
    var addedTransactions = [transactionModel]()
    
    var segmentFlag = 0
    
    func stringToDate(date: String) -> Date {
        let formatter = DateFormatter()
        
        // Format 1
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let parsedDate = formatter.date(from: date) {
            return parsedDate
        }
        
        // Format 2
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:SSSZ"
        if let parsedDate = formatter.date(from: date) {
            return parsedDate
        }
        
        // Couldn't parsed with any format. Just get the date
        let splitedDate = date.components(separatedBy: "T")
        if splitedDate.count > 0 {
            formatter.dateFormat = "yyyy-MM-dd"
            if let parsedDate = formatter.date(from: splitedDate[0]) {
                return parsedDate
            }
        }
        // Nothing worked!
        return Date()
    }
    @IBAction func segmentChanged(_ sender: Any) {
        switch segementedControl.selectedSegmentIndex
        {
        case 0:
            segmentFlag = 0
            allTransactions.removeAll()
            parseJSON()
            transactionTableView.reloadData()
            break
        case 1:
            segmentFlag = 1
            paidTransactions.removeAll()
            parseJSON()
            transactionTableView.reloadData()
            break
        case 2:
            segmentFlag = 2
            receivedTransactions.removeAll()
            parseJSON()
            transactionTableView.reloadData()
            break
        case 3:
            segmentFlag = 3
            addedTransactions.removeAll()
            parseJSON()
            transactionTableView.reloadData()
            break
        default:
            break
        }
    }
    
 
    
    func parseJSON(){
        if let uid = prefs.string(forKey: "userID"){
            let urlpath = "\(baseUrl)/payment/paymenthistory?id=\(uid)&accessToken=accessToken".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let url = URL(string: urlpath!)
            
            if let jsonData = try? Data(contentsOf: url! as URL, options: []){
                let readableJSON = JSON(data: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers, error: nil)
                let status = readableJSON["status"].int! as Int
                numberOfRows = readableJSON["paymentHistory"].count
                
                if status == 621{
                    let items = readableJSON["paymentHistory"].array!
                  
                    for i in 0..<items.count{
                        let transaction = transactionModel(extra: "", transactionId: "", transactionAmt: 0, transactionTime: "", transactionDate: "")
                        
                        if items[i]["flag"] == 0{
                            transaction.extra = items[i]["extra"].string!
                            transaction.transactionAmt = items[i]["amount"].int!
                            transaction.transactionDate = items[i]["parsedDate"].string!
                            transaction.transactionId = items[i]["id"].string!
                            transaction.transactionTime = items[i]["parsedDate"].string!
                            walletAmt = walletAmt+items[i]["amount"].int!
                            allTransactions.append(transaction)
                        }
                        if items[i]["flag"] == 1{
                            transaction.extra = items[i]["extra"].string!
                            transaction.transactionAmt = items[i]["amount"].int!
                            transaction.transactionDate = items[i]["parsedDate"].string!
                            transaction.transactionId = items[i]["id"].string!
                            transaction.transactionTime = items[i]["parsedDate"].string!
                            walletAmt = walletAmt-items[i]["amount"].int!
                            paidTransactions.append(transaction)
                        }
                        if items[i]["flag"] == 2{
                            transaction.extra = items[i]["extra"].string!
                            transaction.transactionAmt = items[i]["amount"].int!
                            transaction.transactionDate = items[i]["parsedDate"].string!
                            transaction.transactionId = items[i]["id"].string!
                            transaction.transactionTime = items[i]["parsedDate"].string!
                            walletAmt = walletAmt+items[i]["amount"].int!
                            receivedTransactions.append(transaction)
                        }
                        if (items[i]["flag"] == 3)||(items[i]["flag"] == 0) {
                            transaction.extra = items[i]["extra"].string!
                            transaction.transactionAmt = items[i]["amount"].int!
                            transaction.transactionDate = items[i]["parsedDate"].string!
                            transaction.transactionId = items[i]["id"].string!
                            transaction.transactionTime = items[i]["parsedDate"].string!
                            walletAmt = walletAmt+items[i]["amount"].int!
                            addedTransactions.append(transaction)
                        }
                    }
                    prefs.set(walletAmt, forKey: "walletBalance")
                    
                }else{
                    print("Couldnt fetch transaction details")
                    let alert = UIAlertController(title: "Uh Oh!", message: "Couldnt fetch transaction details", preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                        
                    }))
                    self.present(alert, animated: true)
                }
            }else{
                print("could not parse JSON")
                let alert = UIAlertController(title: "No connection!", message: "Unable to connect to our servers, please try again later", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    
                }))
                self.present(alert, animated: true)
            }
        }else{
            print("could not fetch user")
            let alert = UIAlertController(title: "Oops!", message: "Have you signed up yet?", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                
            }))
            self.present(alert, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(segmentFlag==0){
            numberOfRows = allTransactions.count
        }else if segmentFlag == 1{
            numberOfRows = paidTransactions.count
        }else if segmentFlag == 2{
            numberOfRows = receivedTransactions.count
        }else if segmentFlag == 3{
            numberOfRows = addedTransactions.count
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = transactionTableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionTableViewCell
        if segmentFlag == 0{
            cell.extra.text = allTransactions[indexPath.row].extra
            cell.transactionAmt.text = String(allTransactions[indexPath.row].transactionAmt)
            cell.transactionDate.text = allTransactions[indexPath.row].transactionDate
            cell.transactionId.text = allTransactions[indexPath.row].transactionId
            cell.transactionTime.text = allTransactions[indexPath.row].transactionTime
            
            
        }else if segmentFlag == 1{
            cell.extra.text = paidTransactions[indexPath.row].extra
            cell.transactionAmt.text = String(paidTransactions[indexPath.row].transactionAmt)
            cell.transactionDate.text = paidTransactions[indexPath.row].transactionDate
            cell.transactionId.text = paidTransactions[indexPath.row].transactionId
            cell.transactionTime.text = paidTransactions[indexPath.row].transactionTime
            
        }else if segmentFlag == 2{
            cell.extra.text = receivedTransactions[indexPath.row].extra
            cell.transactionAmt.text = String(receivedTransactions[indexPath.row].transactionAmt)
            cell.transactionDate.text = receivedTransactions[indexPath.row].transactionDate
            cell.transactionId.text = receivedTransactions[indexPath.row].transactionId
            cell.transactionTime.text = receivedTransactions[indexPath.row].transactionTime
            
            
        }else if segmentFlag == 3{
            cell.extra.text = addedTransactions[indexPath.row].extra
            cell.transactionAmt.text = String(addedTransactions[indexPath.row].transactionAmt)
            cell.transactionDate.text = addedTransactions[indexPath.row].transactionDate
            cell.transactionId.text = addedTransactions[indexPath.row].transactionId
            cell.transactionTime.text = addedTransactions[indexPath.row].transactionTime
            
            
        }
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
