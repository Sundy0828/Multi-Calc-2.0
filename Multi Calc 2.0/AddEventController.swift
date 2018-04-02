//
//  AddEventController.swift
//  Multi Calc 2.0
//
//  Created by Jerrod on 3/21/18.
//  Copyright © 2018 Jerrod Sunderland. All rights reserved.
//

import UIKit
import UserNotifications

class AddEventController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    // avaliable events
    var events = ["Mens Outdoor Dec", "Mens Outdoor Pen", "Mens Indoor Hep", "Mens Indoor Pen", "Womens Outdoor Hep", "Womens Outdoor Dec", "Womens Indoor Pen"]
    var selectedItem = 0
    var eventType = "Mens Outdoor Dec"
    let userSettings = UserDefaults.standard
    var sex = ""
    
    // outlets
    @IBOutlet var eventName: UITextField!
    @IBOutlet var eventTbl: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // hide keyboard and set title
        self.hideKeyboardWhenTappedAround()
        self.eventName.delegate = self
        self.view.backgroundColor = GlobalVariable.backgroundColor
        eventTbl.backgroundColor = GlobalVariable.backgroundColor
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set table and text field
        eventTbl.delegate = self
        eventTbl.dataSource = self
        
        self.eventName.delegate = self
        
        // hide keyboard and set title
        self.hideKeyboardWhenTappedAround()
    }
    // add event to athlete
    @IBAction func addEventPressed(_ sender: Any) {
        if eventName.text != "" {
            //let athleteIndex = GlobalVariable.athletesArray.count - 1
            let id = GlobalVariable.athletesArray[GlobalVariable.athletesIndex].events.count
            let event = Event(name: eventName.text!, eventType: eventType, fat: GlobalVariable.auto, metric: GlobalVariable.measure, trackSize: GlobalVariable.distStepperVal, events: setEventsArray(eventSelected: eventType), marks: [[String]](), scores: [String]())
            GlobalVariable.athletesArray[GlobalVariable.athletesIndex].events.append(event)
            // set athlete event to specific event
            let athleteEvent = GlobalVariable.athletesArray[GlobalVariable.athletesIndex].events[id]
            athleteEvent.events = setEventsArray(eventSelected: athleteEvent.eventType)
            // put number in mark and score arrays
            for _ in 0...athleteEvent.events.count - 1 {
                var holdArr = [String]()
                holdArr.append("00")
                holdArr.append("00")
                holdArr.append("00")
                athleteEvent.marks.append(holdArr)
                athleteEvent.scores.append("0000")
            }
            // only save once for this specific event/athlete
            //GlobalVariable.athletesArray[athleteIndex].saveAthlete(id: athleteIndex)
            for i in 0...GlobalVariable.athletesArray.count - 1 {
                GlobalVariable.athletesArray[i].saveAthlete(id: i)
            }
            
            // show notification that event was added
            timedNotifications(inSeconds: 0.1, name: eventName.text!, eventType: eventType) { (success) in
                if success {
                    print("Successfully Notified")
                }
            }
            
            //event.saveEvents(AID: GlobalVariable.athletesIndex)
            eventName.text = ""
            eventTbl.reloadData()
            
        }else {
            alert(message: "Make sure an event is selected and a name is given!")
        }
    }
    // each multi has a set of events and these are the sets for each event
    func setEventsArray(eventSelected : String) -> [String] {
        var eventTypeEvents = [String]()
        switch (eventSelected) {
        case "Mens Outdoor Dec" :
            eventTypeEvents = ["100", "LJ", "SP", "HJ", "400", "110H", "DT", "PV", "JT", "1500"]
            sex = "men"
            break;
        case "Mens Outdoor Pen" :
            eventTypeEvents = ["LJ", "JT", "200", "DT", "1500"]
            sex = "men"
            break;
        case "Mens Indoor Hep" :
            eventTypeEvents = ["60", "LJ", "SP", "HJ", "60H", "PV", "1000"]
            sex = "men"
            break;
        case "Mens Indoor Pen" :
            eventTypeEvents = ["60H", "LJ", "SP", "HJ", "1000"]
            sex = "men"
            break;
        case "Womens Outdoor Hep" :
            eventTypeEvents = ["100H", "HJ", "SP", "200", "LJ", "JT", "800"]
            sex = "women"
            break;
        case "Womens Outdoor Dec" :
            eventTypeEvents = ["100", "DT", "PV", "JT", "400", "100H", "LJ", "SP", "HJ", "1500"]
            sex = "women"
            break;
        case "Womens Indoor Pen" :
            eventTypeEvents = ["60H", "HJ", "SP", "LJ", "800"]
            sex = "women"
            break;
        default:
            eventTypeEvents = [String]()
        }
        return eventTypeEvents
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
    // set table length
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    // set table rows
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let myGray = UIColor(red: 214/255, green: 214/255, blue: 214/255, alpha:1.0)
        // set background to cell and view
        let view = UIView()
        view.backgroundColor = GlobalVariable.backgroundColor
        let cell = UITableViewCell()
        cell.backgroundColor = GlobalVariable.backgroundColor
        
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
    // event notification function
    func timedNotifications(inSeconds: TimeInterval, name: String, eventType: String, completion: @escaping (_ Success: Bool) -> ()) {
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: inSeconds, repeats: false)
        
        let content = UNMutableNotificationContent()
        
        content.title = "Event Added"
        //content.subtitle = "Yo whats up i am subtitle"
        content.body = "\(name) was added with \(eventType) to the event list!"
        
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
