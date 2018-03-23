//
//  AddEventController.swift
//  Multi Calc 2.0
//
//  Created by Jerrod on 3/21/18.
//  Copyright © 2018 Jerrod Sunderland. All rights reserved.
//

import UIKit

class AddEventController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set table and text field
        eventTbl.delegate = self
        eventTbl.dataSource = self
        
        self.eventName.delegate = self
        
        // hide keyboard and set title
        self.hideKeyboardWhenTappedAround()
        if let tabController = self.parent as? UITabBarController {
            tabController.navigationItem.title = "Add Event"
        }
    }
    // add event to athlete
    @IBAction func addEventPressed(_ sender: Any) {
        let event = Event(name: eventName.text!, eventType: eventType, events: [String](), marks: [[String]](), scores: [String]())
        GlobalVariable.athletesArray[GlobalVariable.athletesIndex].events.append(event)
        eventName.text = ""
        selectedItem = -1
        eventTbl.reloadData()
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
        if indexPath.row == selectedItem {
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
}
