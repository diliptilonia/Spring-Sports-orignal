//
//  userTableCell.swift
//  Spring Sports
//
//  Created by Dilip Kumar on 03/10/18.
//  Copyright © 2018 Dilip Kumar. All rights reserved.
//

import UIKit

class userTableCell: UITableViewCell {


    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userType: UILabel!
    @IBOutlet weak var userStatusButtonOutlet: UIButton!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    

}
