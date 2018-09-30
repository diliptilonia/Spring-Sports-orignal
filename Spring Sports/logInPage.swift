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
        
        if logInSegment.selectedSegmentIndex == 0 {
            print("Admin selected")
            if (userName == "" || password == "") {
                print("either pass or email is empty")
                return
            }
            let Url = String(format: "http://52.66.132.37/booking.springsportsacademy.com/api/login/validate")
            doLogIn(userName!, password!, Url)
        } else if logInSegment.selectedSegmentIndex == 1 {
            print("user selected")
            let Url = String(format: "http://52.66.132.37/booking.springsportsacademy.com/api/login/user_signin")
            doLogIn(userName!, password!, Url)
        }
       
       
    }
    
    func doLogIn(_ userName : String, _ password : String, _ url: String) {
        
            let headers = [
                "Content-Type": "application/x-www-form-urlencoded"
            ]
            let parameters = ["username" : userName, "password" : password]
            Alamofire.request(url, method: .post, parameters: parameters).responseJSON
                { response in
                    
                    let json: AnyObject
                    do {
                        json = try JSONSerialization.jsonObject(with: response.data!, options: []) as AnyObject
                    } catch {
                        print("Error in catch")
                        return
                    }
                    print(json)
                    guard let msgData = json["msg"] as? NSString else {
                        print("Could not get route")
                        return
                    }
                    print(msgData)
                    if msgData == "success" {
                                    self.performSegue(withIdentifier: "homePage", sender: nil)
                    } else {
                        print("Log in id pass in incorrect")
                    }
                    
                 

                   
                  
                    
                    }
//            performSegue(withIdentifier: "homePage", sender: nil)

            }
            


        }
    
    


