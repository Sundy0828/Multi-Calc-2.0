//
//  EditAthleteController.swift
//  Multi Calc 2.0
//
//  Created by Jerrod on 3/22/18.
//  Copyright © 2018 Jerrod Sunderland. All rights reserved.
//

import UIKit

class EditAthleteController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var athleteName: UITextField!
    @IBOutlet var athleteLastName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        athleteName.delegate = self
        self.hideKeyboardWhenTappedAround()
        // set text to whatever the name is
        athleteName.text = GlobalVariable.athletesArray[GlobalVariable.athletesIndex].fName
        athleteLastName.text = GlobalVariable.athletesArray[GlobalVariable.athletesIndex].lName
    }
    // make text limit 25
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 12
    }
    // set changes in array
    @IBAction func donePressed(_ sender: Any) {
        if athleteName.text != "" {
            let athleteIndex = GlobalVariable.athletesArray.count - 1
            GlobalVariable.athletesArray[GlobalVariable.athletesIndex].fName = athleteName.text!
            GlobalVariable.athletesArray[GlobalVariable.athletesIndex].lName = athleteLastName.text!
            // save athlete edited
            
            GlobalVariable.athletesArray[athleteIndex].saveAthlete(id: athleteIndex)
            
            self.navigationController?.popViewController(animated: true)
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
