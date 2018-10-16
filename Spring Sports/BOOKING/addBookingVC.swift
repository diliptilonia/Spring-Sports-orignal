//
//  ViewController.swift
//  PickerView3
//
//  Created by Dilip Kumar on 26/06/18.
//  Copyright © 2018 Dilip Kumar. All rights reserved.
//

import UIKit
import Alamofire
import iOSDropDown

class addBookingVC: UIViewController {
    
   
    var userID = ""
    var size: [Int] = []

    var customerNames: [String] = []
    var customerIDs: [String] = []
    var groundNames: [String] = []
    var groundIDs: [String] = []
    var times: [String] = []
    var durationList: [String] = ["30", "60", "90","120","150","180","210","240","270","300","330","360"]

    var itemList2 = ["Male", "Female"]
    
    var textFiledf: UITextField?
    var activData = [String]()
    
    @IBOutlet weak var customerNameTF: DropDown!
    @IBOutlet weak var duration: DropDown!
    @IBOutlet weak var timeTF: DropDown!
    
    
    @IBOutlet weak var groundNameTF: DropDown!
    @IBOutlet weak var txtDatePicker: UITextField!
    let datePicker = UIDatePicker()
    
    
    
    // Submit button params
    var user_id = String()
    var customer = String()
    var ground_name = String()
    var start_date = String()
    var timeslots = String()
    var duration_of_game = String()


    //    @IBOutlet weak var textField1: UITextField!
//    @IBOutlet weak var textField2: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.loadTimeSlot()

      duration.optionArray = durationList
        getDuration()

        
        loadData()
//        loadTimeSlot()
        groundNameTF.isSearchEnable = false
        showDatePicker()


    }
    
    func getDuration() {
        // The list of array to display. Can be changed dynamically
        duration.optionArray = durationList
        //Its Id Values and its optional
        var size: [Int] = []
        for multiplier in 0..<(self.durationList.count) {
            size.append(multiplier)
        }
        self.customerNameTF.optionIds = self.size
        // The the Closure returns Selected Index and String
        duration.didSelect{(selectedText , index ,id) in
            print("Selected String: \(selectedText) \n index: \(index)")
            self.loadTimeSlot()

    }
    }
    
    
    // Date Picker
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        txtDatePicker.inputAccessoryView = toolbar
        txtDatePicker.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        
        var DatePickerView  : UIDatePicker = UIDatePicker()
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        txtDatePicker.text = dateFormatter.string(from: DatePickerView.date)
        
        
//        txtDatePicker.text = dateFormatter.string(from: datePicker.date)
        
     
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    
    // Parsing Data
 func loadData() {
        Alamofire.request("\(apiUrl)" + "api/booking/get_users_list", method: .post).responseJSON
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
                    
                    guard let userID = dic["user_id"] as? NSString else {return}
                    self.customerIDs.append(userID as String)
                    nameAndEmail = (name as String) + " (" + (email as String) + ")"
                    self.customerNames.append(nameAndEmail)
                    self.customerNameTF.optionArray = self.customerNames
                    for multiplier in 0..<(self.customerNames.count) {
                        self.size.append(multiplier)
                    }
                    self.customerNameTF.optionIds = self.size
                    
                    self.customerNameTF.didSelect{(selectedText , index ,id) in
                        print("Selected user: \(selectedText) \n index: \(index)")
                        self.groundNameTF.isSearchEnable = true
                        var idIndex = self.customerNames.index(of: "\(selectedText)")

                        self.loadGroundNames(idIndex ?? 0)
                        
                    }
//                    print(nameAndEmail)
                }
        }
        
    }
    
    
    
    
    // Load Ground Names
    func loadGroundNames(_ customerIdIndex: Int) {
        print("Customer id index \(customerIDs[customerIdIndex])")
        let defaults = UserDefaults.standard
        userID = defaults.string(forKey: "userID")!
        
        let parameters = ["user_id" : Int(userID)]
        
        Alamofire.request("\(apiUrl)" + "api/booking/get_ground_list", method: .post, parameters: parameters).responseJSON
            { response in
                print(response.result)
                let json: AnyObject
                do {
                    json = try JSONSerialization.jsonObject(with: response.data!, options: []) as AnyObject
                } catch {
                    print("Error in catch of load groundNames")
                    return
                }
                //                                                print(json)
                guard let schoolsData = json["data"] as? [[String: Any]] else {
                    print("Coun't get data")
                    return
                }
//                print(schoolsData)
                
                for dic in schoolsData{
                    var groundName: String = ""
                    var groundIDs: [String] = []
                    // g_Id for send in param
                    guard let g_ID = dic["g_id"] as? NSString else { return }
//                    print(g_ID)
                    guard let schoolCode = dic["ground_code"] as? NSString else { return }
                    guard let type = dic["type"] as? NSString else { return }
                    guard let size = dic["size"] as? NSString else { return }
                    guard let charge = dic["charge"] as? NSString else { return }
                    
                    groundName = (schoolCode as String) + " " + (type as String) + " " + (size as String) + " " + (charge as String)
                    self.groundNames.append(groundName)
                    groundIDs.append(g_ID as String)
//                    print(groundIDs[dic])
  
                }
                self.groundNameTF.optionArray = self.groundNames
                for multiplier in 0..<(self.groundNames.count) {
                    //                        let multiples = (multiplier * 6)
                    self.size.append(multiplier)
                }
                
                self.groundNameTF.optionIds = self.size
                self.groundNameTF.didSelect{(selectedText , index ,id) in
                    print("Selected String: \(selectedText) \n index: \(index)")
                    // self.groundNameTF.isSearchEnable = true
                    var idIndex = self.groundNames.index(of: "\(selectedText)")
//                    print(self.groundIDs[idIndex!])
//                    self.loadTimeSlot()
                }
        }
        
    }
    
    // Load Time Slot
    func loadTimeSlot() {
        print("Date is \(txtDatePicker.text)")
               let parameters = ["val": "\(txtDatePicker.text)",
                          "ground_name": "2",
                          "duration_of_game": "60"]
        
        Alamofire.request("\(apiUrl)" + "api/booking/get_selected_date_time", method: .post, parameters: parameters).responseJSON
            { response in
                print(response.result)
                let json: AnyObject
                do {
                    json = try JSONSerialization.jsonObject(with: response.data!, options: []) as AnyObject
                } catch {
                    print("Error in catch")
                    return
                }
                //                                print("This is time slot \(json)")
                guard let timeSlots = json["data"] as? NSDictionary else {
                    print("Coun't get data")
                    return
                }
                //                                print("timeSlots \(timeSlots)")
                var morningArray: [String] = ["Morning"]
                var afternoonArray: [String] = ["Afternoon"]
                var eveningArray: [String] = ["Evening"]
                guard let morning = timeSlots["morning"] as? NSArray else {
                    print("error in morninig")
                    return
                }
                for slots in morning {
                    for arrayData in slots as! [AnyObject] {
                        guard let tID = arrayData["t_id"] as? NSString else { return }
                        guard let time = arrayData["time"] as? NSString else { return }
                        morningArray.append(time as String)
                    }
                }
                
                guard let evening = timeSlots["evening"] as? NSArray else {
                    print("error in morninig")
                    return
                }
                for slots in evening {
                    for arrayData in slots as! [AnyObject] {
                        guard let tID = arrayData["t_id"] as? NSString else { return }
                        guard let time = arrayData["time"] as? NSString else { return }
                        eveningArray.append(time as String)
                    }
                }
                
                guard let afternoon = timeSlots["afternoon"] as? NSArray else {
                    print("error in morninig")
                    return
                }
                for slots in afternoon {
                    for arrayData in slots as! [AnyObject] {
                        guard let tID = arrayData["t_id"] as? NSString else { return }
                        guard let time = arrayData["time"] as? NSString else { return }
                        afternoonArray.append(time as String)
                    }
                }
                
                self.times = morningArray + afternoonArray + eveningArray
                print(self.times)
                
                self.timeTF.optionArray = self.times
                
                for multiplier in 0..<(self.times.count) {
                    self.size.append(multiplier)
                }
                self.customerNameTF.optionIds = self.size
                self.customerNameTF.didSelect{(selectedText , index ,id) in
                    
                    print("Selected String: \(selectedText) \n index: \(index)")
                    self.groundNameTF.isSearchEnable = true
//                    self.loadGroundNames(<#Int#>)
                }
                
                //                                for dic in timeSlots{
                //                                    var nameAndEmail: String = ""
                //                                    guard let tID = dic["t_id"] as? NSString else { return }
                //                                    guard let time = dic["time"] as? NSString else { return }
                //
                ////                                    nameAndEmail = (name as String) + " " + (email as String)
                //                                    self.customerNames.append(nameAndEmail)
                //                                    print(nameAndEmail)
                //                                }
        }
        
    }
  
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        userID = defaults.string(forKey: "userID")!
        let parameters = ["user_id": userID,
                          "customer": "625",
                          "ground_name": "2",
                          "start_date": "10/10/2018",
                          "timeslots": "4",
                          "duration_of_game": "60"]

        Alamofire.request("\(apiUrl)" + "api/booking/save_booking", method: .post, parameters: parameters).responseJSON
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
        }
    }
    
}



