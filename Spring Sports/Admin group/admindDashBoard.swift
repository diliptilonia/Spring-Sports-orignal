//
//  admindDashBoard.swift
//  Spring Sports
//
//  Created by Dilip Kumar on 28/09/18.
//  Copyright © 2018 Dilip Kumar. All rights reserved.
//

import UIKit
import Alamofire

class admindDashBoard: BaseViewController {
   
    @IBOutlet weak var myTableView: UITableView!
    var cellArray: [String] = []
    var cellTitleArray: [String] = ["Total Cancelled", "Total Pending", "Total Approved"]
    var cellTableData: [tableData] = []
    var bIdData: [String] = []
    @IBOutlet weak var collectionView: UICollectionView!
   
    
    // Table cell Info
    var b_id: [String] = []
    var name: [String] = []
    var bookingDate: [String] = []
    var duration: [String] = []
    
    // Table Header
    var headerArray = ["I_ID"]
    
    
    override func viewWillAppear(_ animated: Bool) {
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()
            self.loadData()
        
        self.addSlideMenuButton()

        print(cellArray)
    }
    

  

    func loadData() {
        let parameters = ["user_id" : 1]

        Alamofire.request("http://52.66.132.37/booking.springsportsacademy.com/api/dashboard", method: .post, parameters: parameters).responseJSON
            { response in
                
                let json: AnyObject
                do {
                    json = try JSONSerialization.jsonObject(with: response.data!, options: []) as AnyObject
                } catch {
                    print("Error in catch")
                    return
                }
                                print(json)
                guard let collectionData = json["data"] as? NSDictionary else {
                    print("Could not get route")
                    return
                }
                //                print(collectionData)
                
                
                guard let cancelled_bookingData = collectionData["cancelled_booking"] as? NSArray else {
                    print("Coun't get data")
                    return
                }
                
                if let totalCancled = cancelled_bookingData.value(forKey: "cancelled") as? NSArray
                {
                    let numberOfCancles = totalCancled[0]
                    
                        self.cellArray.append(numberOfCancles as! String)
                
                    print(numberOfCancles)
                    
                }
                
                
                guard let pending_bookingData = collectionData["pending_booking"] as? NSArray else {
                    print("Coun't get data")
                    return
                }
                
                
                if let totalPending = pending_bookingData.value(forKey: "pending") as? NSArray
                {
                    let numberOfPending = totalPending[0]
                    self.cellArray.append(numberOfPending as! String)

                    print(numberOfPending)
                    
                }
                
                
                
                guard let approved_bookingData = collectionData["approved_booking"] as? NSArray else {
                    print("Coun't get data")
                    return
                }
                if let totalPrroved = approved_bookingData.value(forKey: "approved") as? NSArray
                {
                    let numberOfaprroved = totalPrroved[0]
                    print(numberOfaprroved)
                    self.cellArray.append(numberOfaprroved as! String)
                    print("thisis approoved \(self.cellArray)")
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        print("thisiss after reload \(self.cellArray)")
                    }
                    
                }
                
                // Here we getting the table data from JSON
                guard let tableData = collectionData["booking_list"] as? [[String: Any]] else {
                    print("Coun't get data")
                    return
                }
                for dic in tableData{
                    guard let bID = dic["b_id"] as? NSString else { return }
                    guard let name = dic["name"] as? NSString else { return }
                    guard let bookingDate = dic["booking_date"] as? NSString else {return}
                    guard let ducration = dic["game_duration"] as? NSString else {return}
                    
                    self.b_id.append(bID as String)
                    self.name.append(name as String)
                    self.bookingDate.append(bookingDate as String)
                    self.duration.append(ducration as String)
                    
                  
                }
                DispatchQueue.main.async {
                    self.myTableView.reloadData()
                    print("This is bIdData \(self.bIdData)")

                }

        }
       
    }
    
    
}

extension admindDashBoard: UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("headerView", owner: self, options: nil)?.first as! headerView
        headerView.ID.text = "ID"
        headerView.name.text = "Name"
        headerView.date.text = "Date"
        headerView.duration.text = "Duration"
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return b_id.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTable", for: indexPath) as! AdminDBTCell
        cell.b_id.text = b_id[indexPath.row]
        cell.name.text = name[indexPath.row]
        cell.bookingDate.text = bookingDate[indexPath.row]
        cell.duration.text = duration[indexPath.row]
        return cell
    }
    
    
    // MARK: Collection view Methods 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! adminDBCCell
        cell.states.text = cellArray[indexPath.row]
        cell.titles.text = cellTitleArray[indexPath.row]
        return cell
    }
    
    struct tableData {
        var b_id: String
        var f_id: String
        init(_ dictionary: [String: Any]) {
            self.b_id = dictionary["b_id"] as? String ?? "No b_id"
            self.f_id = dictionary["f_id"] as? String ?? "No f_id"
        }
    }
}


