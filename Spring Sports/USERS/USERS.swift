//
//  USERS.swift
//  Spring Sports
//
//  Created by Dilip Kumar on 01/10/18.
//  Copyright © 2018 Dilip Kumar. All rights reserved.
//

import UIKit
import Alamofire

class USERS: BaseViewController {

    var list = [1,2,3,4,5,6]
    @IBOutlet weak var myUserTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addSlideMenuButton()
        self.loadData()

    }
    
    func loadData() {
        Alamofire.request("\(apiUrl)" + "api/booking/get_users_list", method: .post).responseJSON { responce in
            let json: AnyObject
            do {
                json = try JSONSerialization.jsonObject(with: responce.data!, options: []) as AnyObject
            } catch {
                print("Error in catch")
                return
            }
//            print(json)
            guard let userData = json["data"] as? NSDictionary else {
                print("Cound't get data in userData")
            return
            }
            print(userData)
        }
    }
    

}

extension USERS: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
//        cell.textLabel?.text = String(list[indexPath.row])
        return cell
    }
    
    
}
