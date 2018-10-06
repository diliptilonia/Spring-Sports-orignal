//
//  ViewController.swift
//  PickerView3
//
//  Created by Dilip Kumar on 26/06/18.
//  Copyright © 2018 Dilip Kumar. All rights reserved.
//

import UIKit
import Alamofire

class addBookingVC: UIViewController, UIPickerViewDelegate, UITextFieldDelegate, UIPickerViewDataSource {
    
    var userID = ""

    var customerNames: [String] = []
    var itemList2 = ["Male", "Female"]
    
    var textFiledf: UITextField?
    var activData = [String]()
    
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    //    @IBOutlet weak var textField1: UITextField!
//    @IBOutlet weak var textField2: UITextField!
    var picker = UIPickerView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        picker.dataSource = self
        textField1.delegate = self
        textField2.delegate = self
        textField2.inputView = picker
        textField1.inputView = picker
        
        loadData()
        textField2.isUserInteractionEnabled = false

    }
    
   
    
    // Picker Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return activData.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textFiledf?.text = activData[row]
        textFiledf?.resignFirstResponder()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return activData[row]
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFiledf = textField
        if textFiledf == textField1 {
            activData = customerNames
            textField2.isUserInteractionEnabled = true
            
            loadGroundNames()
        } else if textFiledf == textField2 {
            activData = itemList2
        }
    }
    
    
    // Parsing Data
    func loadGroundNames() {
        let defaults = UserDefaults.standard
        userID = defaults.string(forKey: "userID")!
        
        let parameters = ["user_id" : Int(userID)]
        
        Alamofire.request("http://52.66.132.37/booking.springsportsacademy.com/api/booking/get_ground_list", method: .post, parameters: parameters).responseJSON
            { response in
                print(response.result)
                let json: AnyObject
                do {
                    json = try JSONSerialization.jsonObject(with: response.data!, options: []) as AnyObject
                } catch {
                    print("Error in catch")
                    return
                }
                                                print(json)
                guard let schoolsData = json["data"] as? NSDictionary else {
                    print("Coun't get data")
                    return
                }
                                                print(schoolsData)
//                for dic in schoolsData{
//                    var nameAndEmail: String = ""
//                    guard let name = dic["name"] as? NSString else { return }
//                    guard let email = dic["email"] as? NSString else { return }
//
//                    nameAndEmail = (name as String) + " " + (email as String)
//                    self.customerNames.append(nameAndEmail)
//                    print(nameAndEmail)
//                }
        }
        
    }
    
    
    func loadData() {
        let parameters = ["user_id" : 1]
        
        Alamofire.request("http://52.66.132.37/booking.springsportsacademy.com/api/booking/get_users_list", method: .post).responseJSON
            { response in
                print(response.result)
                let json: AnyObject
                do {
                    json = try JSONSerialization.jsonObject(with: response.data!, options: []) as AnyObject
                } catch {
                    print("Error in catch")
                    return
                }
                //                                print(json)
                guard let tableData = json["data"] as? [[String: Any]] else {
                    print("Coun't get data")
                    return
                }
                //                                print(tableData)
                for dic in tableData{
                    var nameAndEmail: String = ""
                    guard let name = dic["name"] as? NSString else { return }
                    guard let email = dic["email"] as? NSString else { return }
                    
                    nameAndEmail = (name as String) + " (" + (email as String) + ")"
                    self.customerNames.append(nameAndEmail)
//                    print(nameAndEmail)
                }
        }
        
    }
    
    
    
}



