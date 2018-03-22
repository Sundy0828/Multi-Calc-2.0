//
//  AddEventController.swift
//  Multi Calc 2.0
//
//  Created by Jerrod on 3/21/18.
//  Copyright © 2018 Jerrod Sunderland. All rights reserved.
//

import UIKit

class AddEventController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    var events = ["Mens Outdoor Dec", "Mens Outdoor Pen", "Mens Indoor Hep", "Mens Indoor Pen", "Womens Outdoor Hep", "Womens Outdoor Dec", "Womens Indoor Pen"]
    var selectedItem = -1
    var eventType = ""
    let userSettings = UserDefaults.standard
    
    @IBOutlet var eventName: UITextField!
    @IBOutlet var eventTbl: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideKeyboardWhenTappedAround()
        self.eventName.delegate = self
        if let tabController = self.parent as? UITabBarController {
            tabController.navigationItem.title = "Add Event"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        eventTbl.delegate = self
        eventTbl.dataSource = self
        
        self.eventName.delegate = self
                
        if let tabController = self.parent as? UITabBarController {
            tabController.navigationItem.title = "Add Event"
        }
    }
    @IBAction func addEventPressed(_ sender: Any) {
        let event = Event(name: eventName.text!, eventType: eventType, results: [String]())
        GlobalVariable.athletesArray[GlobalVariable.athletesIndex].events.append(event)
        //userSettings.set(GlobalVariable.athletesArray, forKey: GlobalVariable.keyAthletes)
        eventName.text = ""
        selectedItem = -1
        eventTbl.reloadData()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myGray = UIColor(red: 214/255, green: 214/255, blue: 214/255, alpha:1.0)
        let view = UIView()
        view.backgroundColor = myGray
        let cell = UITableViewCell()
        cell.backgroundColor = myGray
        
        let image = UIImageView(image: #imageLiteral(resourceName: "whiteGear"))
        image.frame = CGRect(x: 5, y: 5, width: 35, height: 35)
        view.addSubview(image)
        
        let font = UIFont(name: "AvenirNext-Regular", size: 20)
        
        let label = UILabel()
        label.text = events[indexPath.row]
        label.font = font
        label.frame = CGRect(x: 45, y: 5, width: 250, height: 35)
        view.addSubview(label)
        
        if indexPath.row == selectedItem {
            cell.accessoryType = .checkmark
        }
        
        cell.addSubview(view)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = indexPath.row
        eventType = events[indexPath.row]
        eventTbl.reloadData()
    }
}
