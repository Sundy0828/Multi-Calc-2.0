//
//  EditEventController.swift
//  Multi Calc 2.0
//
//  Created by Jerrod on 3/22/18.
//  Copyright © 2018 Jerrod Sunderland. All rights reserved.
//

import UIKit

class EditEventController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    // avaliable events
    var events = ["Mens Outdoor Dec", "Mens Outdoor Pen", "Mens Indoor Hep", "Mens Indoor Pen", "Womens Outdoor Hep", "Womens Outdoor Dec", "Womens Indoor Pen"]
    var selectedItem = -1
    var eventType = ""
    let userSettings = UserDefaults.standard
    
    // outlets
    @IBOutlet var eventName: UITextField!
    @IBOutlet var eventTbl: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // hide keyboard and set title
        self.hideKeyboardWhenTappedAround()
        self.eventName.delegate = self
        if let tabController = self.parent as? UITabBarController {
            tabController.navigationItem.title = "Add Event"
        }
    }
    // make text limit 25
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 25
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set table and text field
        eventTbl.delegate = self
        eventTbl.dataSource = self
        
        self.eventName.delegate = self
        // set event name and event type
        eventName.text = GlobalVariable.athletesArray[GlobalVariable.athletesIndex].events[GlobalVariable.eventsIndex].name
        eventType = GlobalVariable.athletesArray[GlobalVariable.athletesIndex].events[GlobalVariable.eventsIndex].eventType
        
        // hide keyboard and set title
        self.hideKeyboardWhenTappedAround()
    }
    // add event to athlete
    @IBAction func addEventPressed(_ sender: Any) {
        if eventName.text != "" {
            let athleteIndex = GlobalVariable.athletesArray.count - 1
            // set event name and event type in array
            GlobalVariable.athletesArray[GlobalVariable.athletesIndex].events[GlobalVariable.eventsIndex].name = eventName.text!
            GlobalVariable.athletesArray[GlobalVariable.athletesIndex].events[GlobalVariable.eventsIndex].eventType = eventType
            // save athlete edited
            
            GlobalVariable.athletesArray[athleteIndex].saveAthlete(id: athleteIndex)
            
            self.navigationController?.popViewController(animated: true)
        }else {
            alert(message: "Make sure an event is selected and a name is given!")
        }
    }
    // hide keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    // set table length
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    // set table rows
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myGray = UIColor(red: 214/255, green: 214/255, blue: 214/255, alpha:1.0)
        // set background to cell and view
        let view = UIView()
        view.backgroundColor = myGray
        let cell = UITableViewCell()
        cell.backgroundColor = myGray
        
        // set icon image
        let image = UIImageView(image: #imageLiteral(resourceName: "whiteGear"))
        image.frame = CGRect(x: 5, y: 5, width: 35, height: 35)
        view.addSubview(image)
        
        // set font and text
        let font = UIFont(name: "AvenirNext-Regular", size: 20)
        
        let label = UILabel()
        label.text = events[indexPath.row]
        label.font = font
        label.frame = CGRect(x: 45, y: 5, width: 250, height: 35)
        view.addSubview(label)
        
        // add checkmark if selected
        if eventType == events[indexPath.row] {
        //if indexPath.row == selectedItem {
            cell.accessoryType = .checkmark
        }
        
        cell.addSubview(view)
        
        return cell
    }
    // select which cell gets checkmark and set event type
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = indexPath.row
        eventType = events[indexPath.row]
        eventTbl.reloadData()
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
