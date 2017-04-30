//
//  SettingsViewController.swift
//  SelectDineWallet
//
//  Created by Pavan Powani on 29/04/17.
//  Copyright © 2017 Pavan Powani. All rights reserved.
//

import UIKit
import DatePickerDialog

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet var dateField: UITextField!
    @IBOutlet var genderPicker: UIPickerView!
    var gender:String! = "Male"
    var genders = ["Male","Female"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        genderPicker.delegate = self
        genderPicker.dataSource = self
        
        dateField.addTarget(self, action: #selector(myTargetFunction), for: .touchDown)

        // Do any additional setup after loading the view.
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
