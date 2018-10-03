//
//  bookingTableCell.swift
//  Spring Sports
//
//  Created by Dilip Kumar on 03/10/18.
//  Copyright © 2018 Dilip Kumar. All rights reserved.
//

import UIKit

class bookingTableCell: UITableViewCell {

    @IBOutlet weak var bookedFor: UILabel!
    @IBOutlet weak var ground: UILabel!
    @IBOutlet weak var status: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
