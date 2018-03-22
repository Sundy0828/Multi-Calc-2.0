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
        self.hideKeyboardWhenTappedAround()
        self.athleteName.delegate = self
        if let tabController = self.parent as? UITabBarController {
            tabController.navigationItem.title = "Add Athlete"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        self.athleteName.delegate = self
        
        if let tabController = self.parent as? UITabBarController {
            tabController.navigationItem.title = "Add Athlete"
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func addAthletePressed(_ sender: Any) {
        let name = athleteName.text!
        let athlete: Athlete = Athlete(name: name, events: [Event]())
        GlobalVariable.athletesArray.append(athlete)
        //userSettings.set(GlobalVariable.athletesArray, forKey: GlobalVariable.keyAthletes)
        athleteName.text = ""
    }
}
