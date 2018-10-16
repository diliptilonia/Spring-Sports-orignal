//
//  bookedHourVC.swift
//  Spring Sports
//
//  Created by Dilip Kumar on 12/10/18.
//  Copyright © 2018 Dilip Kumar. All rights reserved.
//

import UIKit
import Alamofire

class bookedHourVC: UIViewController {

    @IBOutlet weak var myTableView: UITableView!
    var date = ""
    var time = ""
    var s_time = ""
    
    var hourData: [HourBooking] = []
    
    
    // Detail View Arrays
    var b_IDs: [String] = []
    var emailIDs: [String] = []
    var mobileNos: [String] = []
    var dates: [String] = []
    var times: [String] = []
    var Duration: [String] = []
    var status: [String] = []
    var bookedFor: [String] = []
    var ground: [String] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        showAlert()
        
        self.myTableView.rowHeight = 110
        print(date)
        print(time)
        print(s_time)
        loadBookingData()
      
    }

    
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
   

}

extension bookedHourVC {
    // All API calling
    func loadBookingData() {
        let defaults = UserDefaults.standard
        var userID = defaults.string(forKey: "userID")!
        let parameters = ["user_id" : Int(userID),
            "date" : date,
            "time" : time,
            "start_time": s_time
            ] as [String : Any]
        print(parameters)
        Alamofire.request("http://booking.springsportsacademy.com/api/booking/calendar", method: .post, parameters: parameters).responseJSON
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
                
                guard let isthereData = json["success"] as? Int else {
                    print("Coun't get data in table data")
                    return
                }
                print(isthereData)
                if isthereData == 0 {
                    print("There is not Data")
                    DispatchQueue.main.async {
                        self.showAlert(message: "No Booking in This Hour")
                    }
                } else {
                    guard let data = json["data"] as? NSDictionary else {
                        print("Coun't get data in table data")
                        return
                }
//                print("This is whole Data \(data)")
                
                    guard let bookings = data["booking"] as? [[String: Any]] else {
                    print("Coun't get datav in booking")
                    return
                }
                    
                    let noOFBooking = bookings.count
                    if noOFBooking != nil {
                        print("There is  booking \(String(describing: bookings))")
//                        var tempHourData: [HourBooking] = []

                        for index in bookings{
                            var groundName: String = ""
                            
                            guard let names = index["name"] as? NSString else { return }
                            print("These are names \(names)")
                            
                            
                            guard let time = index["time"] as? NSString else { return }
                            print("These are time \(time)")
                            
                            
                            guard let duration = index["duration"] as? NSString else { return }
                            print("These are duration \(duration)")
                            
                            
                            // Extracting Name
                            guard let school_name = index["school_name"] as? NSString else { return }
                            print("These are schoolName \(school_name)")
                            guard let type = index["type"] as? NSString else { return }
                            print("These are type \(type)")
                            guard let frac_code = index["frac_code"] as? NSString else { return }
                            print("These are frac_code \(frac_code)")
                            guard let size = index["size"] as? NSString else { return }
                            print("These are size \(size)")
                            
                            groundName = school_name as String + "-" + (type as String) as String + "-" +
                                (frac_code as String) as String + "-" + (size as String) as String
                            self.ground.append(groundName)
                            self.bookedFor.append(names as String)
                            
                            var cell1 = HourBooking(image: #imageLiteral(resourceName: "default"), name: names as String, time: time as String, duration: duration as String, groundName: groundName as String)
                            self.hourData.append(cell1)
                            
                            
                            // Collecting Data for detail page
                            guard let can = index["cancelled"] as? NSString else {return}
                            guard let appr = index["approved"] as? NSString else {return}
                            var status: NSString = ""
                            if can == "1" {
                                status = "cancelled"
                            } else if can == " " && appr == "1" {
                                status = "approved"
                            } else {
                                status = "Pending"
                            }
                            self.status.append(status as String)

                            
                            guard let id = index["b_id"] as? NSString else {return}
                            self.b_IDs.append(id as String)
                            guard let emailid = index["email"] as? NSString else {return}
                            self.emailIDs.append(emailid as String)
                            
                            var mobNo = ""
                            guard let mobileCode = index["code"] as? NSString else {return}
                            guard let mobileNo = index["mobile"] as? NSString else {return}
                            mobNo = (mobileCode as String) + (mobileNo as String)
                            self.mobileNos.append(mobNo)
                            
                            guard let date = index["booked_on"] as? NSString else {return}
                            self.dates.append(date as String)
                            
                            guard let times = index["time"] as? NSString else {return}
                            self.times.append(time as String)
                            
                            var dura = ""
                            guard let durations = index["duration"] as? NSString else {return}
                            dura = (duration as String) + " mins"
                            self.Duration.append(dura)
                            
                        }
                    
                    } else {
                        print("This is no booking \(String(describing: bookings))")
                        
                    }
                    DispatchQueue.main.async {
                        self.myTableView.reloadData()
                    }
                    
        }
    }
    }
}

extension bookedHourVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hourData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! bookedHourTCC
        let hourCell = hourData[indexPath.row]
        
        cell.hourCell(hourCell: hourCell)
        
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
