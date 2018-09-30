//
//  admindDashBoard.swift
//  Spring Sports
//
//  Created by Dilip Kumar on 28/09/18.
//  Copyright © 2018 Dilip Kumar. All rights reserved.
//

import UIKit
import Alamofire

class admindDashBoard: UIViewController {
   
    @IBOutlet weak var myTableView: UITableView!
    var cellArray: [String] = []
    var cellTitleArray: [String] = ["Total Cancelled", "Total Pending", "Total Approved"]
    var cellTableData: [tableData] = []
    var bIdData: [String] = []
    @IBOutlet weak var collectionView: UICollectionView!
   
    
    // Table cell Info
    var b_id: [String] = ["1", "2", "3"]
    var name: [String] = ["Dilip","Ajay", "Deepak"]
    var bookingDate: [String] = ["Today", "Tomorrow", "day after Tomo"]
    var duration: [String] = ["54", "34", "30"]
    
    
    override func viewWillAppear(_ animated: Bool) {

    }


    override func viewDidLoad() {
        super.viewDidLoad()
            self.loadData()
        
        
        print(cellArray)
    }
    

  

    func loadData() {
        
        Alamofire.request("http://52.66.132.37/booking.springsportsacademy.com/api/dashboard", method: .post).responseJSON
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
                    guard let title = dic["b_id"] as? NSString else { return }
                    guard let bid = dic["f_id"] as? NSString else { return }
                    self.bIdData.append(title as String)
                  
                }
                DispatchQueue.main.async {
                    self.myTableView.reloadData()
                    print("This is bIdData \(self.bIdData)")

                }

        }
       
    }
    
    
}

extension admindDashBoard: UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bIdData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTable", for: indexPath)
        cell.textLabel?.text = bIdData[indexPath.row]
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


