//
//  AddAthleteController.swift
//  Multi Calc 2.0
//
//  Created by Jerrod on 3/21/18.
//  Copyright © 2018 Jerrod Sunderland. All rights reserved.
//

import UIKit
import UserNotifications

class AddAthleteController: UIViewController, UITextFieldDelegate {
    @IBOutlet var athleteName: UITextField!
    
    let userSettings = UserDefaults.standard
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // hide keyboard and change title
        self.hideKeyboardWhenTappedAround()
        self.athleteName.delegate = self
        if let tabController = self.parent as? UITabBarController {
            tabController.navigationItem.title = "Add Athlete"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // hide keyboard and change title
        self.hideKeyboardWhenTappedAround()
        self.athleteName.delegate = self
        if let tabController = self.parent as? UITabBarController {
            tabController.navigationItem.title = "Add Athlete"
        }
    }
    // hide keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    // make text limit 25
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 25
    }
    @IBAction func addAthletePressed(_ sender: Any) {
        if athleteName.text != "" {
            // add values to athlete array and set textfield to ""
            let name = athleteName.text!
            // set athlete and add it to the array
            let athlete: Athlete = Athlete(name: name, events: [Event]())
            let athleteIndex = GlobalVariable.athletesArray.count
            GlobalVariable.athletesArray.append(athlete)
            userSettings.set(athleteIndex, forKey: "totAthletes")
            
            // save only the athlete we're on, do not resave the entire array
            GlobalVariable.athletesArray[athleteIndex].saveAthlete(id: athleteIndex)
            
            //athlete.saveAthlete()
            athleteName.text = ""
            // show notification that athlete was added
            timedNotifications(inSeconds: 0.1, name: name) { (success) in
                if success {
                    print("Successfully Notified")
                }
            }
            
        }else {
            alert(message: "Make sure name is given!")
        }
    }
    // alert function
    func alert(message: String, title: String = "Error") {
        //calls alert controller with tital and message
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //creates and adds ok button
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        //shows
        self.present(alertController, animated: true, completion: nil)
    }
    // athlete notification function
    func timedNotifications(inSeconds: TimeInterval, name: String, completion: @escaping (_ Success: Bool) -> ()) {
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: inSeconds, repeats: false)
        
        let content = UNMutableNotificationContent()
        
        content.title = "Athlete Added"
        //content.subtitle = "Yo whats up i am subtitle"
        content.body = "\(name) was added to the athlete list!"
        
        let request = UNNotificationRequest(identifier: "customNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                completion(false)
            }else {
                completion(true)
            }
        }
    }
}
