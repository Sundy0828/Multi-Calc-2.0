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
        var name = String()
        var events = [Event]()
        if (userSettings.value(forKey: "athleteName\(athleteNum)") as! String?) != nil {
            name = (userSettings.value(forKey: "athleteName\(athleteNum)") as! String?)!
        }
        if eventNumArr[athleteNum] != -1 {
            for j in 0...eventNumArr[athleteNum] {
                let event = fetchEvents(AID: athleteNum, eventNum: j)
                events.append(event)
            }
        }
        
        let athlete = Athlete(name: name, events: events)
        return athlete
    }
    
    func fetchEvents(AID: Int, eventNum: Int) -> Event {
        var name = String()
        var eventType = String()
        var marks = [[String]]()
        var scores = [String]()
        
        if (userSettings.value(forKey: "\(AID)eventName\(eventNum)") as! String?) != nil {
            name = (userSettings.value(forKey: "\(AID)eventName\(eventNum)") as! String?)!
        }
        if (userSettings.value(forKey: "\(AID)eventType\(eventNum)") as! String?) != nil {
            eventType = (userSettings.value(forKey: "\(AID)eventType\(eventNum)") as! String?)!
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
        let event = Event(name: name, eventType: eventType, events: events, marks: marks, scores: scores)
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
}
