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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        athleteName.delegate = self
        self.hideKeyboardWhenTappedAround()
        // set text to whatever the name is
        athleteName.text = GlobalVariable.athletesArray[GlobalVariable.athletesIndex].name
    }
    // set changes in array
    @IBAction func donePressed(_ sender: Any) {
        if athleteName.text != "" {
            GlobalVariable.athletesArray[GlobalVariable.athletesIndex].name = athleteName.text!
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
        let OKAction = UIAlertAction(title: "Yes", style: .default, handler: nil)
        alertController.addAction(OKAction)
        //shows
        self.present(alertController, animated: true, completion: nil)
    }
}
