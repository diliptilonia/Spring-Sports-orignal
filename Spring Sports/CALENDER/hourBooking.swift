//
//  hourBooking.swift
//  Spring Sports
//
//  Created by Dilip Kumar on 13/10/18.
//  Copyright © 2018 Dilip Kumar. All rights reserved.
//

import Foundation
import UIKit

class HourBooking {
    var image: UIImage
    var name: String
    var time: String
    var duration: String
    var groundName: String
    
    init(image: UIImage, name: String, time: String, duration: String, groundName: String) {
        self.image = image
        self.name = name
        self.time = time
        self.duration = duration
        self.groundName = groundName
    }
    
   
    
}
