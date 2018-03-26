//
//  AddAthleteController.swift
//  Multi Calc 2.0
//
//  Created by Jerrod on 3/21/18.
//  Copyright © 2018 Jerrod Sunderland. All rights reserved.
//

import UIKit

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
            let athleteIndex = GlobalVariable.athletesArray.count - 1
            GlobalVariable.athletesArray.append(athlete)
            userSettings.set(athleteIndex, forKey: "totAthletes")
            
            // save only the athlete we're on, do not resave the entire array
            GlobalVariable.athletesArray[athleteIndex].saveAthlete(id: athleteIndex)
            
            //athlete.saveAthlete()
            athleteName.text = ""
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
}
