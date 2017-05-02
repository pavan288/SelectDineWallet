//
//  IFSCViewController.swift
//  SelectDineWallet
//
//  Created by Pavan Powani on 08/04/17.
//  Copyright © 2017 Pavan Powani. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol IFSCDelegate: class {
    func userDidEnterDetails(info: String)
}

class IFSCViewController: UIViewController, BankEnteredDelegate, StateEnteredDelegate, CityEnteredDelegate, BranchEnteredDelegate {

    @IBOutlet var branchButton: UIButton!
    @IBOutlet var cityButton: UIButton!
    @IBOutlet var stateButton: UIButton!
    @IBOutlet var bankName: UITextField!
    @IBOutlet var stateName: UITextField!
    @IBOutlet var cityName: UITextField!
    @IBOutlet var branchName: UITextField!
    let prefs = UserDefaults.standard
    let baseUrl = "http://35.154.46.78:1337"
    weak var delegate: IFSCDelegate? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setBankName(name: "")
        setStateName(name: "")
        setCityName(name: "")
        setBranchName(name: "")
        
        stateName.isUserInteractionEnabled = false
        cityName.isUserInteractionEnabled = false
        branchName.isUserInteractionEnabled = false
        
        stateButton.isEnabled = false
        cityButton.isEnabled = false
        branchButton.isEnabled = false
        
        self.hideKeyboard()
        
        // Do any additional setup after loading the view.
    }

    func setBankName(name: String){
        self.bankName.text = name
    }
    func setStateName(name: String){
        self.stateName.text = name
    }
    func setCityName(name: String){
        self.cityName.text = name
    }
    func setBranchName(name: String){
        self.branchName.text = name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissVC(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showBanks" {
            let secondViewController = segue.destination as! BanksTableViewController
            secondViewController.delegate = self
        }else if segue.identifier == "showStates" {
            let secondViewController = segue.destination as! StateTableView
            secondViewController.delegate = self
            secondViewController.test = bankName.text!
        }else if segue.identifier == "showCities" {
            let secondViewController = segue.destination as! CityTableView
            secondViewController.delegate = self
            secondViewController.test = bankName.text!
            secondViewController.test1 = stateName.text!
            
        }else if segue.identifier == "showBranches" {
            let secondViewController = segue.destination as! BranchTableView
            secondViewController.delegate = self
            secondViewController.test = bankName.text!
            secondViewController.test1 = stateName.text!
            secondViewController.test3 = cityName.text!
        }
        
    }
    
    func userDidEnterBank(info: String) {
        self.bankName.text = info
        stateButton.isEnabled = true
    }
    func userDidEnterState(info: String) {
        self.stateName.text = info
        cityButton.isEnabled = true
    }
    func userDidEnterCity(info: String) {
        self.cityName.text = info
        branchButton.isEnabled = true
    }
    func userDidEnterBranch(info: String) {
        self.branchName.text = info
        parseJSON()
        
    }
    
    
    func parseJSON(){
        if let bank = bankName.text , let state = stateName.text, let city = cityName.text, let branch = branchName.text{
            let urlpath = "\(baseUrl)/banks/getAllBanksByNameStateAndBranch?bankName=\(bank)&state=\(state)&city=\(city)&branchName=\(branch)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let url = URL(string: urlpath!)
            if let jsonData = try? Data(contentsOf: url! as URL, options: []) {
                let readableJSON = JSON(data: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers, error: nil)
                //    if readableJSON.exists(){
                let status = readableJSON["status"].int! as Int
                let ifsc = readableJSON["banks"][0]["ifsc"].string! as String
                print(ifsc)
                delegate?.userDidEnterDetails(info: ifsc)
            }else{
                print("check internet")
            }
        }else{
            print("Enter all the fields")
        }
    }
    

}
