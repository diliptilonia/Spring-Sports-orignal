//
//  BOOKING.swift
//  Spring Sports
//
//  Created by Dilip Kumar on 01/10/18.
//  Copyright © 2018 Dilip Kumar. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class BOOKING: BaseViewController {
    var number = ["1", "2", "3"]
    var bookedFor: [String] = []
    var ground: [String] = []
    var status: [String] = []
    
    // Detail View Arrays
    var b_IDs: [String] = []
    var emailIDs: [String] = []
    var mobileNos: [String] = []
    var dates: [String] = []
    var times: [String] = []
    var Duration: [String] = []

    @IBOutlet weak var mytable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addSlideMenuButton()
        self.loadData()
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show()
    }
    
    
    func loadData() {
        let parameters = ["user_id" : 1]
        
        Alamofire.request("http://52.66.132.37/booking.springsportsacademy.com/api/booking", method: .post).responseJSON
            { response in
                print(response.result)
                let json: AnyObject
                do {
                    json = try JSONSerialization.jsonObject(with: response.data!, options: []) as AnyObject
                } catch {
                    print("Error in catch")
                    return
                }
//                print(json)
                
//                guard let collectionData = json["data"] as? NSDictionary else {
//                    print("Could not get route")
//                    return
//                }
        
//                 Here we getting the table data from JSON
                guard let tableData = json["data"] as? [[String: Any]] else {
                    print("Coun't get data")
                    return
                }
//                print(tableData)
                for dic in tableData{
                    var groundName: String = ""
                    guard let bID = dic["name"] as? NSString else { return }
                    
                    // Ground Name array
                    guard let groundCode = dic["school_name"] as? NSString else { return }
                    guard let type = dic["type"] as? NSString else { return }
                    guard let size = dic["size"] as? NSString else { return }
                    groundName = (groundCode as String) + " " + (type as String) + " " + (size as String)
                    
//                    guard let bookingDate = dic["booking_date"] as? NSString else {return}
                    guard let can = dic["cancelled"] as? NSString else {return}
                    guard let appr = dic["approved"] as? NSString else {return}

                    var status: NSString = ""
                    if can == "1" {
                         status = "cancelled"
                    } else if can == " " && appr == "1" {
                        status = "approved"
                    } else {
                        status = "Pending"
                    }
                  self.bookedFor.append(bID as String)
                    self.ground.append(groundName as String)
//                    self.bookingDate.append(bookingDate as String)
                    self.status.append(status as String)


                    
                    // Collecting Data for detail page
                    guard let id = dic["b_id"] as? NSString else {return}
                    self.b_IDs.append(id as String)
                    guard let emailid = dic["email"] as? NSString else {return}
                    self.emailIDs.append(emailid as String)
                    
                    var mobNo = ""
                    guard let mobileCode = dic["code"] as? NSString else {return}
                    guard let mobileNo = dic["mobile"] as? NSString else {return}
                    mobNo = (mobileCode as String) + (mobileNo as String)
                    self.mobileNos.append(mobNo)
                    
                    guard let date = dic["booked_on"] as? NSString else {return}
                    self.dates.append(date as String)
                    
                    guard let time = dic["time"] as? NSString else {return}
                    self.times.append(time as String)
                    
                    var dura = ""
                    guard let duration = dic["duration"] as? NSString else {return}
                    dura = (duration as String) + " mins"
                    self.Duration.append(dura)
                }
                SVProgressHUD.dismiss()
                DispatchQueue.main.async {
                    self.mytable.reloadData()
//                    print(self.emailIDs)
//                    print(self.mobileNos)
//                    print(self.dates)
//                    print(self.times)
//                    print(self.Duration)

                }
                
        }
        
    }

  

}

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
        
//        print(indexPath.row)
        cell.bookedFor.text = bookedFor[indexPath.row]
        cell.ground.text = ground[indexPath.row]
        cell.status.text = status[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Send to detail page")
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "bookingDetailVC") as? bookingDetailVC
        vc?.id = b_IDs[indexPath.row]
        vc?.name = bookedFor[indexPath.row]
        vc?.ground = ground[indexPath.row]
        vc?.emailID = emailIDs[indexPath.row]
        vc?.mobileNo = mobileNos[indexPath.row]
        vc?.date = dates[indexPath.row]
        vc?.time = times[indexPath.row]
        vc?.Duration = Duration[indexPath.row]
        
        vc?.status = status[indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)

    }
    
    
}
