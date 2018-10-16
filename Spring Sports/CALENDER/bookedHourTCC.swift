//
//  bookedHourTCC.swift
//  Spring Sports
//
//  Created by Dilip Kumar on 12/10/18.
//  Copyright © 2018 Dilip Kumar. All rights reserved.
//

import UIKit

class bookedHourTCC: UITableViewCell {

    @IBOutlet weak var pfImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var groundName: UILabel!
    
    func hourCell(hourCell: HourBooking) {
        pfImage.image = hourCell.image
        name.text = hourCell.name
        time.text = hourCell.time
        duration.text = hourCell.duration
        groundName.text = hourCell.groundName
    }
}
