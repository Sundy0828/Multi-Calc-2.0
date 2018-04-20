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
    
    // keys to save values to phone
    let userSettings = UserDefaults.standard
    var distStepper = 100.0
    let keyAuto = "distChoice"
    let keyMeasure = "paceDistChoice"
    let keyTheme = "theme"
    let keyLapDist = "lapDist"
    let textArr = ["Track Size", "Timing", "Measurement", "Theme"]
    let imgArrL = [#imageLiteral(resourceName: "whiteGear"),#imageLiteral(resourceName: "whiteGear"),#imageLiteral(resourceName: "whiteGear"),#imageLiteral(resourceName: "whiteGear")]
    let imgArrD = [#imageLiteral(resourceName: "blackArrow"), #imageLiteral(resourceName: "blackArrow"), #imageLiteral(resourceName: "blackArrow"), #imageLiteral(resourceName: "blackArrow")]
    
    // cell label
    @IBOutlet weak var trackSizeLbl: UILabel!
    @IBOutlet var fatTimeLbl: UILabel!
    @IBOutlet var handTimeLbl: UILabel!
    @IBOutlet var meterLbl: UILabel!
    @IBOutlet var feetLbl: UILabel!
    @IBOutlet var lightLbl: UILabel!
    @IBOutlet var darkLbl: UILabel!
    
    // cells
    @IBOutlet var trackSizeCell: UITableViewCell!
    @IBOutlet var fatTimeCell: UITableViewCell!
    @IBOutlet var handTimeCell: UITableViewCell!
    @IBOutlet var meterCell: UITableViewCell!
    @IBOutlet var feetCell: UITableViewCell!
    @IBOutlet var lightCell: UITableViewCell!
    @IBOutlet var darkCell: UITableViewCell!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // style cells
        style()
        changeTheme()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //style cells
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
        // set check marks based on values selected
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
        
        // set distance text
        trackSizeLbl.text = "\(GlobalVariable.distStepperVal) meters"
        changeTheme()
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        tableView.tableHeaderView?.frame.size.height = 45
        
        let view = UIView()
        
        let image = UIImageView()
        image.frame = CGRect(x: 5, y: 5, width: 20, height: 20)
        
        let label = UILabel()
        label.text = textArr[section]
        label.frame = CGRect(x: 30, y: 5, width: 250, height: 20)
        
        image.image = imgArrD[section]
        
        view.backgroundColor = GlobalVariable.tableHeaderColor
        label.textColor = UIColor.black
        
        view.addSubview(image)
        view.addSubview(label)
        
        return view
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Your action here
        let section = indexPath.section
        let row = indexPath.row
        
        // based on section and row selected save data to phone and in app
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
                GlobalVariable.textColor = UIColor.black
                GlobalVariable.backgroundColor = UIColor(red: 214/255, green: 214/255, blue: 214/255, alpha: 1.0)
                GlobalVariable.menuColor = GlobalVariable.myBlue
                GlobalVariable.subtextColor = GlobalVariable.myBlue
                GlobalVariable.tableViewColor = UIColor.white
                GlobalVariable.tableViewBtnColor = UIColor.darkGray
                GlobalVariable.tableHeaderColor = UIColor.white
            }else if row == 1 {
                GlobalVariable.theme = "dark"
                userSettings.set(GlobalVariable.theme, forKey: keyTheme)
                GlobalVariable.textColor = UIColor.white
                GlobalVariable.backgroundColor = UIColor.darkGray
                GlobalVariable.menuColor = GlobalVariable.myBlue
                GlobalVariable.subtextColor = GlobalVariable.myBlue
                GlobalVariable.tableViewColor = UIColor(red: 214/255, green: 214/255, blue: 214/255, alpha: 1.0)
                GlobalVariable.tableViewBtnColor = UIColor.lightGray
                GlobalVariable.tableHeaderColor = UIColor(red: 214/255, green: 214/255, blue: 214/255, alpha: 1.0)
            }
            //changeTheme()
        }
        style()
        changeTheme()
        style()
        //tableView.reloadData()
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
    
    func changeTheme() {
        var cellColor: UIColor = UIColor(red: 214/255, green: 214/255, blue: 214/255, alpha: 1.0)
        var cellTextColor: UIColor = UIColor.black
        if GlobalVariable.theme == "dark" {
            cellColor = UIColor.darkGray
            cellTextColor = UIColor.white
        }
        
        trackSizeLbl.textColor = cellTextColor
        fatTimeLbl.textColor = cellTextColor
        handTimeLbl.textColor = cellTextColor
        meterLbl.textColor = cellTextColor
        feetLbl.textColor = cellTextColor
        lightLbl.textColor = cellTextColor
        darkLbl.textColor = cellTextColor
        
        trackSizeCell.backgroundColor = cellColor
        fatTimeCell.backgroundColor = cellColor
        handTimeCell.backgroundColor = cellColor
        meterCell.backgroundColor = cellColor
        feetCell.backgroundColor = cellColor
        lightCell.backgroundColor = cellColor
        darkCell.backgroundColor = cellColor
        
        trackSizeCell.contentView.backgroundColor = cellColor
        fatTimeCell.contentView.backgroundColor = cellColor
        handTimeCell.contentView.backgroundColor = cellColor
        meterCell.contentView.backgroundColor = cellColor
        feetCell.contentView.backgroundColor = cellColor
        
        trackSizeCell.tintColor = cellTextColor
        fatTimeCell.tintColor = cellTextColor
        handTimeCell.tintColor = cellTextColor
        meterCell.tintColor = cellTextColor
        feetCell.tintColor = cellTextColor
        lightCell.tintColor = cellTextColor
        darkCell.tintColor = cellTextColor
        
        view.backgroundColor = cellColor
        tableView.reloadData()
    }
}

