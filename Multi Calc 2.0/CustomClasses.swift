//
//  CustomClasses.swift
//  Multi Calc 2.0
//
//  Created by Jerrod on 3/21/18.
//  Copyright © 2018 Jerrod Sunderland. All rights reserved.
//

import UIKit

// class for event for each athlete
class Event {
    var id: Int
    var name: String
    var eventType: String
    var events: [String]
    var marks: [[String]]
    var scores: [String]
    
    init(id: Int, name: String, eventType: String, events: [String], marks: [[String]], scores: [String]) {
        self.id = id
        self.name = name
        self.eventType = eventType
        self.events = events
        self.marks = marks
        self.scores = scores
    }
    
    func saveEvents(AID: Int) {
        let userSettings = UserDefaults.standard
        print("\(AID)\(id)\n\(name)\n\(eventType)\n\(marks)\n\(scores)\n")
        userSettings.set(id, forKey: "\(AID)\(id)")
        userSettings.set(name, forKey: "\(AID)eventName\(id)")
        userSettings.set(eventType, forKey: "\(AID)eventType\(id)")
        var num = 1
        if eventType.contains("Dec") {
            num = 10
        }else if eventType.contains("Pen") {
            num = 5
        }else if eventType.contains("Hep") {
            num = 7
        }
        if !marks.isEmpty {
            for i in 0...num - 1 {
                userSettings.set(marks[i][0], forKey: "\(AID)\(i)0marks\(id)")
                userSettings.set(marks[i][1], forKey: "\(AID)\(i)1marks\(id)")
                userSettings.set(marks[i][2], forKey: "\(AID)\(i)2marks\(id)")
            }
        }
        if !scores.isEmpty {
            for i in 0...num - 1 {
                userSettings.set(scores[i], forKey: "\(AID)\(i)scores\(id)")
            }
        }
    }
}
// class for each athlete
class Athlete {
    var id: Int
    var name: String
    var events: [Event]
    
    init(id: Int, name: String, events: [Event]) {
        self.id = id
        self.name = name
        self.events = events
    }
    
    func saveAthlete() {
        let userSettings = UserDefaults.standard
        userSettings.set(id, forKey: "\(id)")
        userSettings.set(name, forKey: "athleteName\(id)")
        if events.count > 0 {
            userSettings.set(events.count - 1, forKey: "totAthleteEvents\(id)")
            for i in 0...events.count - 1 {
                events[i].saveEvents(AID: id)
            }
        }
    }
}
// extension to hide keyboard
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
