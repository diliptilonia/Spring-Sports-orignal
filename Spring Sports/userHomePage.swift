//
//  userHomePage.swift
//  Spring Sports
//
//  Created by Dilip Kumar on 27/09/18.
//  Copyright © 2018 Dilip Kumar. All rights reserved.
//

import UIKit

class userHomePage: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var names = ["Ground1","Ground2","Ground3","Ground4","Ground5"]
    
    var tableDataArray: [tableData] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableDataArray = createTableData()
    }
    
    func createTableData() -> [tableData] {
        var tempTableDataArray: [tableData] = []
        
        let data1 = tableData(title: "First Entry")
        let data2 = tableData(title: "SEcond Entry")
        
        tempTableDataArray.append(data1)
        tempTableDataArray.append(data2)
        return tempTableDataArray
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = names[indexPath.row]
        
        return cell
    }
    

}


extension UIViewController {
//    public func hideNavi() {
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
//    }
    public func backButton(identifire: String) {
        var vcName = identifire
        let st = UIStoryboard(name: "Main", bundle: nil)
        let vc = st.instantiateViewController(withIdentifier: identifire)
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    
}
