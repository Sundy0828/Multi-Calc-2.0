//
//  CustomClasses.swift
//  Multi Calc 2.0
//
//  Created by Jerrod on 3/21/18.
//  Copyright © 2018 Jerrod Sunderland. All rights reserved.
//

import UIKit

class Event {
    var name: String
    var eventType: String
    var results: [String]
    
    init(name: String, eventType: String, results: [String]) {
        self.name = name
        self.eventType = eventType
        self.results = results
    }
}
class Athlete {
    var name: String
    var events: [Event]
    
    init(name: String, events: [Event]) {
        self.name = name
        self.events = events
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
