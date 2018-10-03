//
//  BOOKING.swift
//  Spring Sports
//
//  Created by Dilip Kumar on 01/10/18.
//  Copyright © 2018 Dilip Kumar. All rights reserved.
//

import UIKit
import Alamofire

class BOOKING: BaseViewController {
    var number = ["1", "2", "3"]
    var bookedFor = ["Dilip", "Ajay"]
    var ground = ["Ground1", "ground2"]
    var status = ["approved", "Pending"]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addSlideMenuButton()
        loadData()
    }
    
    
    func loadData() {
        let parameters = ["user_id" : 1]
        
//        Alamofire.request("http://52.66.132.37/booking.springsportsacademy.com/api/booking", method: .post, parameters: parameters).responseJSON
//            { response in
//
//                let json: AnyObject
//                do {
//                    json = try JSONSerialization.jsonObject(with: response.data!, options: []) as AnyObject
//                } catch {
//                    print("Error in catch")
//                    return
//                }
//                print(json)
//                guard let collectionData = json["data"] as? NSDictionary else {
//                    print("Could not get route")
//                    return
//                }
//                                print(collectionData)
        
                // Here we getting the table data from JSON
//                guard let tableData = collectionData["booking_list"] as? [[String: Any]] else {
//                    print("Coun't get data")
//                    return
//                }
//                for dic in tableData{
//                    guard let bID = dic["name"] as? NSString else { return }
//                    guard let name = dic["ground"] as? NSString else { return }
//                    guard let bookingDate = dic["booking_date"] as? NSString else {return}
//                    guard let ducration = dic["status"] as? NSString else {return}
//
//                    self.b_id.append(bID as String)
//                    self.name.append(name as String)
//                    self.bookingDate.append(bookingDate as String)
//                    self.duration.append(ducration as String)
//
//
//                }
//                DispatchQueue.main.async {
//                    self.myTableView.reloadData()
//                    print("This is bIdData \(self.bIdData)")
//
//                }
                
        }
        
    }

  

//}

extension BOOKING: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("headerViewinBooking", owner: self, options: nil)?.first as! headerViewinBooking
        headerView.bookedFor.text = "Booked For"
        headerView.ground.text = "Ground"
        headerView.status.text = "Status"
        return headerView 
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookedFor.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookingCell", for: indexPath) as! bookingTableCell
//        cell.textLabel?.text = number[indexPath.row]
        
        
        cell.bookedFor.text = bookedFor[indexPath.row]
        cell.ground.text = ground[indexPath.row]
        cell.status.text = status[indexPath.row]
        return cell
    }
    
    
}
