//
//  CALENDER.swift
//  Spring Sports
//
//  Created by Dilip Kumar on 01/10/18.
//  Copyright © 2018 Dilip Kumar. All rights reserved.
//

import UIKit
import Alamofire

class CALENDER: BaseViewController {

    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var mySegmentedControl: UISegmentedControl!
    
    let privateList:[String] = ["Private item 1","Private item 2"]
    let friendsAndFamily:[String] = ["Friend item 1","Friend item 2", "Friends item 3"]
    let publicList:[String] = ["Public item 1", "Public item 2", "Public item 3", "Public item 4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addSlideMenuButton()
        loadData()
        
    }
    
    // Creating Segment controleler
  
    @IBAction func segmentControllerAction(_ sender: UISegmentedControl) {
        myTableView.reloadData()
    }
    
    
    func loadData() {
        let parameters = ["user_id" : 1]
        
        Alamofire.request("http://52.66.132.37/booking.springsportsacademy.com/api/booking/calendar", method: .post).responseJSON
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

extension CALENDER: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnValue = 0
        
        switch(mySegmentedControl.selectedSegmentIndex)
        {
        case 0:
            returnValue = privateList.count
            break
        case 1:
            returnValue = friendsAndFamily.count
            break
            
        case 2:
            returnValue = publicList.count
            break
            
        default:
            break
            
        }
        
        return returnValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "calenderCell", for: indexPath)
        
        switch(mySegmentedControl.selectedSegmentIndex)
        {
        case 0:
            myCell.textLabel!.text = privateList[indexPath.row]
            break
        case 1:
            myCell.textLabel!.text = friendsAndFamily[indexPath.row]
            break
            
        case 2:
            myCell.textLabel!.text = publicList[indexPath.row]
            break
            
        default:
            break
            
        }
        
        
        return myCell
    }
    
    
}
