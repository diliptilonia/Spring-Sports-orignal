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
//    1:00 pm
    var hours: [String] = ["12:00 am","1:00 am","2:00 am","3:00 am","4:00 am","5:00 am","6:00 am","7:00 am","8:00 am","9:00 am","10:00 am","11:00 am","12:00 pm","1:00 pm","2:00 pm","3:00 pm","4:00 pm","5:00 pm","6:00 pm","7:00 pm","8:00 pm","9:00 pm","10:00 pm","11:00 pm"]
    var s_time: [String] = ["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23"]
    let date = Date()
    let formatter = DateFormatter()
    
    @IBOutlet weak var dateLabel: UILabel!
    var selectedDate:NSDate!

    override func viewDidLoad() {
        super.viewDidLoad()
        selectedDate = NSDate()   // sets the initial date
        dateLabel.text = selectedDate.formatted
        self.addSlideMenuButton()
        
    }
    
    // Creating Segment controleler
  
    @IBAction func stepAction(_ sender: UIStepper) {
        selectedDate = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!.date(byAdding: .day, value: Int(sender.value), to: NSDate() as Date, options: [])! as NSDate
        dateLabel.text =  selectedDate.formatted
    }
    
    
    



}

extension NSDate {
    var formatted: String {
        let df = DateFormatter()
        df.dateFormat = "yyyy.MM.dd"
        df.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        return df.string(from: self as Date)
    }
}

extension CALENDER: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hours.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! calendarCVC
        cell.timeLabel.text = hours[indexPath.row]
        cell.layer.borderWidth = 2
        cell.layer.borderColor = #colorLiteral(red: 0.9882352941, green: 0.7137254902, blue: 0.0862745098, alpha: 1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let st = UIStoryboard(name: "Main", bundle: nil)
        let vc = st.instantiateViewController(withIdentifier :"bookedHourVC") as! bookedHourVC
        vc.time = hours[indexPath.row]
        vc.date = dateLabel.text!
        vc.s_time = s_time[indexPath.row]
       
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

