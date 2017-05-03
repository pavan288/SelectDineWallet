//
//  SettingsViewController.swift
//  SelectDineWallet
//
//  Created by Pavan Powani on 29/04/17.
//  Copyright © 2017 Pavan Powani. All rights reserved.
//

import UIKit
import DatePickerDialog
import SwiftyJSON

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet var dateField: UITextField!
    @IBOutlet var genderPicker: UIPickerView!
    var gender:String! = "Male"
    var genders = ["Male","Female"]
    let baseUrl = "http://35.154.46.78:1337"
    let prefs = UserDefaults.standard
    
    
    @IBOutlet var username: UITextField!
    @IBOutlet var userEmail: UITextField!
    @IBOutlet var userPhone: UITextField!
    
    @IBOutlet var pancard: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        genderPicker.delegate = self
        genderPicker.dataSource = self
        
        dateField.addTarget(self, action: #selector(myTargetFunction), for: .editingDidBegin )

        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismissVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func myTargetFunction(textField: UITextField) {
        // user touch field
     DatePickerDialog().show(title: "DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date ) {
     (date) -> Void in
     let dateformater = DateFormatter()
     dateformater.dateFormat = "dd-MM-YYYY"
     let selectedDate = dateformater.string(from: date!)
     self.dateField.text = "\(selectedDate)"
     }

    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == dateField{
            DatePickerDialog().show(title: "DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date ) {
                (date) -> Void in
                let dateformater = DateFormatter()
                dateformater.dateFormat = "dd-MM-YYYY"
                let selectedDate = dateformater.string(from: date!)
                self.dateField.text = "\(selectedDate)"
            }

        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        gender = genders[row]
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    @IBAction func savePressed(_ sender: Any) {
        let uid = prefs.value(forKey: "userID")
        let urlpath = "\(baseUrl)/user/updateUserProfile?name=\(username.text!)&email=\(userEmail.text!)&mobileNo=\(userPhone.text!)&panCard=\(pancard.text!)&gender=\(gender!)&dob=\(dateField.text!)&id=\(uid!)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let url = URL(string: urlpath!)
        
        if let jsonData = try? Data(contentsOf: url! as URL, options: []){
            let readableJSON = JSON(data: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers, error: nil)
            let status = readableJSON["status"].int! as Int
           
            
            if status == 788{
                let alert = UIAlertController(title: "Success!", message: "Profile Successfully updated!", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    
                }))
                self.present(alert, animated: true)
                
            }else{
                print("There was an error updating the details")
            }
            
        }else{
            let alert = UIAlertController(title: "No connection!", message: "Please check your connection", preferredStyle: .actionSheet)
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
