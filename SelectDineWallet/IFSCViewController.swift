//
//  IFSCViewController.swift
//  SelectDineWallet
//
//  Created by Pavan Powani on 08/04/17.
//  Copyright © 2017 Pavan Powani. All rights reserved.
//

import UIKit

class IFSCViewController: UIViewController, DataEnteredDelegate, StateEnteredDelegate, CityEnteredDelegate, BranchEnteredDelegate {

    @IBOutlet var branchButton: UIButton!
    @IBOutlet var cityButton: UIButton!
    @IBOutlet var stateButton: UIButton!
    @IBOutlet var bankName: UITextField!
    @IBOutlet var stateName: UITextField!
    @IBOutlet var cityName: UITextField!
    @IBOutlet var branchName: UITextField!
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
    }
    

}
