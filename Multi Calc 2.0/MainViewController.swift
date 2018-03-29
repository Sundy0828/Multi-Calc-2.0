//
//  MainViewController.swift
//  Multi Calc 2.0
//
//  Created by Jerrod on 3/22/18.
//  Copyright © 2018 Jerrod Sunderland. All rights reserved.
//

import UIKit
import UserNotifications

class MainViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // avaliable events
    var events = ["Mens Outdoor Dec", "Mens Outdoor Pen", "Mens Indoor Hep", "Mens Indoor Pen", "Womens Outdoor Hep", "Womens Outdoor Dec", "Womens Indoor Pen"]
    var eventType = "Mens Outdoor Dec"
    let userSettings = UserDefaults.standard
    // save key names
    let keyAuto = "distChoice"
    let keyMeasure = "paceDistChoice"
    let keyTheme = "theme"
    let keyLapDist = "lapDist"
    
    @IBOutlet var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // ask to allow alerts
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
            
            if error != nil {
                print("Authorization Unsuccessfull")
            }else {
                print("Authorization Successfull")
            }
        }
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        // set varables if values were saved
        if (userSettings.value(forKey: keyAuto) as! Bool?) != nil {
            GlobalVariable.auto = (userSettings.value(forKey: keyAuto) as! Bool?)!
        }
        if (userSettings.value(forKey: keyMeasure) as! Bool?) != nil {
            GlobalVariable.measure = (userSettings.value(forKey: keyMeasure) as! Bool?)!
        }
        if (userSettings.value(forKey: keyTheme) as! String?) != nil {
            GlobalVariable.theme = (userSettings.value(forKey: keyTheme) as! String?)!
        }
        if (userSettings.value(forKey: keyLapDist) as! Double?) != nil {
            GlobalVariable.distStepperVal = (userSettings.value(forKey: keyLapDist) as! Double?)!
        }
        if (userSettings.value(forKey: GlobalVariable.keyAthletes) as! [Athlete]?) != nil {
            GlobalVariable.athletesArray = (userSettings.value(forKey: GlobalVariable.keyAthletes) as! [Athlete]?)!
        }
        
        // if there is a first user then get saved data
        if (userSettings.value(forKey: "\(0)") as! Int?) != nil {
            // get total number of athlete
            if (userSettings.value(forKey: "totAthletes") as! Int?) != nil {
                GlobalVariable.totAthletes = (userSettings.value(forKey: "totAthletes") as! Int?)!
            }
            // based on number of athletes get the number of events per athlete and add to tot event array
            for i in 0...GlobalVariable.totAthletes {
                var totAthleteEvents = -1
                if (userSettings.value(forKey: "totAthleteEvents\(i)") as! Int?) != nil {
                    totAthleteEvents = (userSettings.value(forKey: "totAthleteEvents\(i)") as! Int?)!
                }
                GlobalVariable.totEvents.append(totAthleteEvents)
            }
            // set athletes array from saved data
            for i in 0...GlobalVariable.totAthletes {
                if (userSettings.value(forKey: "totAthleteEvents\(i)") as! Int?) != nil {
                    GlobalVariable.totAthletes = (userSettings.value(forKey: "totAthleteEvents\(i)") as! Int?)!
                }
                let athlete: Athlete = fetchAthletes(athleteNum: i, eventNumArr: GlobalVariable.totEvents)
                GlobalVariable.athletesArray.append(athlete)
            }
        }
        
    }
    // get data for all athletes
    func fetchAthletes(athleteNum: Int, eventNumArr: [Int]) -> Athlete {
        var fName = String()
        var lName = String()
        var events = [Event]()
        if (userSettings.value(forKey: "athleteFirstName\(athleteNum)") as! String?) != nil {
            fName = (userSettings.value(forKey: "athleteFirstName\(athleteNum)") as! String?)!
        }
        if (userSettings.value(forKey: "athleteLastName\(athleteNum)") as! String?) != nil {
            lName = (userSettings.value(forKey: "athleteLastName\(athleteNum)") as! String?)!
        }
        if eventNumArr[athleteNum] != -1 {
            for j in 0...eventNumArr[athleteNum] {
                let event = fetchEvents(AID: athleteNum, eventNum: j)
                events.append(event)
            }
        }
        
        let athlete = Athlete(fName: fName, lName: lName, events: events)
        return athlete
    }
    
    func fetchEvents(AID: Int, eventNum: Int) -> Event {
        var name = String()
        var eventType = String()
        var fat = Bool()
        var metric = Bool()
        var trackSize = Double()
        var events = [String]()
        var marks = [[String]]()
        var scores = [String]()
        
        if (userSettings.value(forKey: "\(AID)eventName\(eventNum)") as! String?) != nil {
            name = (userSettings.value(forKey: "\(AID)eventName\(eventNum)") as! String?)!
        }
        if (userSettings.value(forKey: "\(AID)eventType\(eventNum)") as! String?) != nil {
            eventType = (userSettings.value(forKey: "\(AID)eventType\(eventNum)") as! String?)!
        }
        if (userSettings.value(forKey: "\(AID)fat\(eventNum)") as! Bool?) != nil {
            fat = (userSettings.value(forKey: "\(AID)fat\(eventNum)") as! Bool?)!
        }
        if (userSettings.value(forKey: "\(AID)metric\(eventNum)") as! Bool?) != nil {
            metric = (userSettings.value(forKey: "\(AID)metric\(eventNum)") as! Bool?)!
        }
        if (userSettings.value(forKey: "\(AID)trackSize\(eventNum)") as! Double?) != nil {
            trackSize = (userSettings.value(forKey: "\(AID)trackSize\(eventNum)") as! Double?)!
        }
        
        var num = 1
        if eventType.contains("Dec") {
            num = 10
        }else if eventType.contains("Pen") {
            num = 5
        }else if eventType.contains("Hep") {
            num = 7
        }
        for i in 0...num - 1 {
            if (userSettings.value(forKey: "\(AID)\(i)events\(eventNum)") as! String?) != nil {
                let event: String = (userSettings.value(forKey: "\(AID)\(i)events\(eventNum)") as! String?)!
                events.append(event)
            }
        }
        for i in 0...num - 1 {
            var mark1 = ""
            var mark2 = ""
            var mark3 = ""
            
            if (userSettings.value(forKey: "\(AID)\(i)0marks\(eventNum)") as! String?) != nil {
                mark1 = (userSettings.value(forKey: "\(AID)\(i)0marks\(eventNum)") as! String?)!
            }
            if (userSettings.value(forKey: "\(AID)\(i)1marks\(eventNum)") as! String?) != nil {
                mark2 = (userSettings.value(forKey: "\(AID)\(i)1marks\(eventNum)") as! String?)!
            }
            if (userSettings.value(forKey: "\(AID)\(i)2marks\(eventNum)") as! String?) != nil {
                mark3 = (userSettings.value(forKey: "\(AID)\(i)2marks\(eventNum)") as! String?)!
            }
            marks.append([mark1, mark2, mark3])
        }
        for i in 0...num - 1 {
            if (userSettings.value(forKey: "\(AID)\(i)scores\(eventNum)") as! String?) != nil {
                let score: String = (userSettings.value(forKey: "\(AID)\(i)scores\(eventNum)") as! String?)!
                scores.append(score)
            }
        }
        if GlobalVariable.measure != metric {
            metric = !metric
        }
        let event = Event(name: name, eventType: eventType, fat: fat, metric: metric, trackSize: trackSize, events: events, marks: marks, scores: scores)
        return event
    }
    
    @IBAction func calcScorePressed(_ sender: Any) {
        if GlobalVariable.eventType != eventType {
            GlobalVariable.markArray = [[String]]()
            GlobalVariable.scoreArray = [String]()
            GlobalVariable.eventType = eventType
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return events.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return events[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        eventType = events[row]
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "AvenirNext-Regular", size: 30)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = events[row]
        pickerLabel?.textColor = UIColor.black
        
        return pickerLabel!
    }
}
