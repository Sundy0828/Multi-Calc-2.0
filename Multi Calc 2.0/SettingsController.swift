//
//  settingsController.swift
//  Multi Scoring Calc
//
//  Created by Jerrod on 2/21/18.
//  Copyright © 2018 Jerrod Sunderland. All rights reserved.
//

import Foundation
import UIKit

class SettingsController: UITableViewController {
    
    let userSettings = UserDefaults.standard
    var distStepper = 100.0
    let keyAuto = "distChoice"
    let keyMeasure = "paceDistChoice"
    let keyTheme = "theme"
    let keyLapDist = "lapDist"
    
    @IBOutlet weak var trackSizeLbl: UILabel!
    
    @IBOutlet var fatTimeCell: UITableViewCell!
    @IBOutlet var handTimeCell: UITableViewCell!
    @IBOutlet var meterCell: UITableViewCell!
    @IBOutlet var feetCell: UITableViewCell!
    @IBOutlet var lightCell: UITableViewCell!
    @IBOutlet var darkCell: UITableViewCell!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        style()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
    }
    @IBAction func refreshPressed(_ sender: Any) {
        // Declare Alert
        let dialogMessage = UIAlertController(title: "Reset", message: "Are you sure you want to reset the settings?", preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
            GlobalVariable.distStepperVal = 400.0
            self.userSettings.set(GlobalVariable.distStepperVal, forKey: self.keyLapDist)
            GlobalVariable.auto = true
            self.userSettings.set(GlobalVariable.auto, forKey: self.keyAuto)
            GlobalVariable.measure = true
            self.userSettings.set(GlobalVariable.measure, forKey: self.keyMeasure)
            GlobalVariable.theme = "light"
            self.userSettings.set(GlobalVariable.theme, forKey: self.keyTheme)
            
            self.style()
        })
        
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            // event if canceled
        }
        
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
    }
    func style() {
        
        if GlobalVariable.auto == false {
            fatTimeCell.accessoryType = .none
            handTimeCell.accessoryType = .checkmark
        }else {
            fatTimeCell.accessoryType = .checkmark
            handTimeCell.accessoryType = .none
        }
        if GlobalVariable.measure == false {
            meterCell.accessoryType = .none
            feetCell.accessoryType = .checkmark
        }else {
            meterCell.accessoryType = .checkmark
            feetCell.accessoryType = .none
        }
        if GlobalVariable.theme == "light" {
            darkCell.accessoryType = .none
            lightCell.accessoryType = .checkmark
        }else {
            darkCell.accessoryType = .checkmark
            lightCell.accessoryType = .none
        }
        trackSizeLbl.text = "\(GlobalVariable.distStepperVal) meters"
        //changeTheme()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Your action here
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 1 {
            if row == 0 {
                GlobalVariable.auto = true
                userSettings.set(GlobalVariable.auto, forKey: keyAuto)
            }else if row == 1 {
                GlobalVariable.auto = false
                userSettings.set(GlobalVariable.auto, forKey: keyAuto)
            }
        }else if section == 2 {
            if row == 0 {
                GlobalVariable.measure = true
                userSettings.set(GlobalVariable.measure, forKey: keyMeasure)
            }else if row == 1 {
                GlobalVariable.measure = false
                userSettings.set(GlobalVariable.measure, forKey: keyMeasure)
            }
        }else if section == 3 {
            if row == 0 {
                GlobalVariable.theme = "light"
                userSettings.set(GlobalVariable.theme, forKey: keyTheme)
                //navigationController?.navigationBar.barStyle = .default
            }else if row == 1 {
                GlobalVariable.theme = "dark"
                userSettings.set(GlobalVariable.theme, forKey: keyTheme)
                //navigationController?.navigationBar.barStyle = .black
            }
            //changeTheme()
        }
        style()
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

