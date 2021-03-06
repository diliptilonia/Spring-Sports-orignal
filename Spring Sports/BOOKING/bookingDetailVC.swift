//
//  bookingDetailVC.swift
//  Spring Sports
//
//  Created by Dilip Kumar on 03/10/18.
//  Copyright © 2018 Dilip Kumar. All rights reserved.
//

import UIKit
import Alamofire


class bookingDetailVC: UIViewController {
    
    var userID = ""
    var authentiction = String()
    
    // arrays for show date
    var id = ""
    var name = ""
    var emailID = ""
    var mobileNo = ""
    var ground = ""
    var date = ""
    var time = ""
    var Duration = ""
    
    var status = ""
    @IBOutlet weak var statusButtonOutlet: UIButton!
    @IBOutlet weak var approvedButtonOutlet: UIButton!
    @IBOutlet weak var approvedByLab: UILabel!
    
    
    var detailFromTable: [String] = []
    
    var number = ["1", "2", "3"]
    var userDetails = ["Name","Email-Id","Mobile","Ground","Date","Time","Duration"]
   
    override func viewWillAppear(_ animated: Bool) {
        approvedByLab.isHidden = true
        approvedButtonOutlet.isHidden = true
        if status == "cancelled" {
            statusButtonOutlet.isHidden = true
        } else if status == "approved" {
            statusButtonOutlet.isHidden = false
            statusButtonOutlet.setTitle("Cancel", for: .normal)

        } else  {
            statusButtonOutlet.setTitle("Cancel", for: .normal)
            approvedButtonOutlet.isHidden = false
            
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        userID = defaults.string(forKey: "userID")!
        
      
        detailFromTable.append(name)
        detailFromTable.append(emailID)
        detailFromTable.append(mobileNo)
        detailFromTable.append(ground)
        detailFromTable.append(date)
        detailFromTable.append(time)
        detailFromTable.append(Duration)
        print(detailFromTable)
//        statusButtonOutlet.setTitle(status, for: .normal)
        if  statusButtonOutlet.currentTitle == "Pending" {
            print("Button current title is Pending")
        }
        
        showStatus()

    }
    

    func showStatus() {
        let parameters = ["bid": id]
        Alamofire.request("\(apiUrl)" + "api/booking/view_booking_details/\(id)").responseJSON
            { response in
                
                let json: AnyObject
                do {
                    json = try JSONSerialization.jsonObject(with: response.data!, options: []) as AnyObject
                } catch {
                    print("Error in catch")
                    return
                }
//                print(json)
                guard let collectionData = json["data"] as? NSDictionary else {
                    print("Could not get route")
                    return
                }
                //                print(collectionData)
                
                
                guard let token = collectionData["auth_token"] as? NSString else {
                    print("Coun't get data")
                    return
                }
                print(token)
                self.authentiction = token as String
    }
    }
    
    @IBAction func approveButtonClicked(_ sender: UIButton) {
        let parameters = ["user_id": userID, "auth_token" : authentiction,
                          "booking_id" : id]
        print(parameters)
        Alamofire.request("\(apiUrl)" + "api/booking/approve_booking", method: .post, parameters: parameters).responseJSON
            { response in
                print("This is reponce in approvedButton \(response)")
                let json: AnyObject
                do {
                    json = try JSONSerialization.jsonObject(with: response.data!, options: []) as AnyObject
                } catch {
                    print("Error in catch")
                    return
                }
//                print(json)
                guard let didSuccess = json["success"] as? Int else {
                    print("Coun't get data")
                    return
                }
                print("Did success \(didSuccess)")
                if didSuccess == 1 {
                    let alert = UIAlertController(title: "Approved", message: "Approved successfully", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        switch action.style{
                        case .default:
                            print("default")
                            
                        case .cancel:
                            print("cancel")
                            
                        case .destructive:
                            print("destructive")
                            
                            
                        }}))
                    self.present(alert, animated: true, completion: nil)
                    print("Approved successed")
                    self.approvedButtonOutlet.isHidden = true
                } else {
                    print("Did not successed approved")
                }
                
        }
        
        
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        let parameters = ["user_id": userID, "auth_token" : authentiction,
            "booking_id" : id]
        print(parameters)
        Alamofire.request("\(apiUrl)" + "api/booking/cancel_booking", method: .post, parameters: parameters).responseJSON
            { response in
                print(response)
                let json: AnyObject
                do {
                    json = try JSONSerialization.jsonObject(with: response.data!, options: []) as AnyObject
                } catch {
                    print("Error in catch")
                    return
                }
//                                print(json)
    }
    }
    

}

extension bookingDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookingDetailCell", for: indexPath) as! detailVCCell
        cell.staticData.text = userDetails[indexPath.row]
        cell.dataFromTable.text = detailFromTable[indexPath.row]
        return cell
    }
    
    
}
