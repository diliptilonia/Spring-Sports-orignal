//
//  ViewController.swift
//  Spring Sports
//
//  Created by Dilip Kumar on 27/09/18.
//  Copyright © 2018 Dilip Kumar. All rights reserved.
//

import UIKit
import Alamofire

class logInPage: UIViewController {
    

    @IBOutlet weak var logInSegment: UISegmentedControl!
    @IBOutlet weak var forgotButtonOutlet: UIButton!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passTF: UITextField!
    
    let yourAttributes : [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),
        NSAttributedString.Key.foregroundColor : UIColor.white,
        NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
    //.styleDouble.rawValue, .styleThick.rawValue, .styleNone.rawValue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let attributeString = NSMutableAttributedString(string: "Forgot Password?",
                                                        attributes: yourAttributes)
        forgotButtonOutlet.setAttributedTitle(attributeString, for: .normal)
    }
    
    @IBAction func logInButton(_ sender: UIButton) {
        let userName = emailTF.text
        let password = passTF.text
       var isValueForm =  isValidEmail(testStr: emailTF.text!)
        if isValueForm == false {
            print("Email is not in correct form")
        }
        
        if logInSegment.selectedSegmentIndex == 0 {
            print("Admin selected")
            var userNameAru = "username"
        
            if (userName == "" || password == "") {
                print("either pass or email is empty")
                return
            }
            let Url = String(format: "http://52.66.132.37/booking.springsportsacademy.com/api/login/validate")
            doLogIn(userNameAru, userName!, password!, Url)
        } else if logInSegment.selectedSegmentIndex == 1 {
            print("user selected")
            var userNameAru = "email"

            let Url = String(format: "http://52.66.132.37/booking.springsportsacademy.com/api/login/user_signin")
            doLogIn(userNameAru , userName!, password!, Url)
        }
       
       
    }
    
    func doLogIn(_ userNameAru: String , _ userName : String, _ password : String, _ url: String) {
        
            let headers = [
                "Content-Type": "application/x-www-form-urlencoded"
            ]
            let parameters = [userNameAru : userName, "password" : password]
            Alamofire.request(url, method: .post, parameters: parameters).responseJSON
                { response in
                    
                    let json: AnyObject
                    do {
                        json = try JSONSerialization.jsonObject(with: response.data!, options: []) as AnyObject
                    } catch {
                        print("Error in catch")
                        return
                    }
//                    print(json)
                    guard let collectionData = json["data"] as? NSDictionary else {
                        print("Could not get route")
                        return
                    }
                                    print(collectionData)
                    guard let userID = collectionData["user_id"] as? NSString else {
                        print("Coun't get data")
                        return
                    }
                    print(userID as String)
                    let uID = userID as String
                    UserDefaults.standard.set(uID, forKey: "userID")
                    guard let msgData = json["msg"] as? NSString else {
                        print("Could not get route")
                        return
                    }
                    print("this is msg \(msgData)")
                    if msgData == "success" {
                        if userNameAru == "username" {
                            self.performSegue(withIdentifier: "goToAdminDB", sender: nil)

                            
                        } else if userNameAru == "email" {
                            self.performSegue(withIdentifier: "homePage", sender: nil)

                        }
                    } else {
                        print("Log in id pass in incorrect")
                    }
                    
                 

                   
                  
                    
                    }
//            performSegue(withIdentifier: "homePage", sender: nil)

            }
            


        }

extension logInPage {
    func isValidEmail(testStr:String) -> Bool {
        print("validate emilId: \(testStr)")
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
}
extension String {
    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
        } catch {
            return false
        }
    }
}
    
    


