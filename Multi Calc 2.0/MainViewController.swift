//
//  MainViewController.swift
//  Multi Calc 2.0
//
//  Created by Jerrod on 3/22/18.
//  Copyright © 2018 Jerrod Sunderland. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // avaliable events
    var events = ["Mens Outdoor Dec", "Mens Outdoor Pen", "Mens Indoor Hep", "Mens Indoor Pen", "Womens Outdoor Hep", "Womens Outdoor Dec", "Womens Indoor Pen"]
    var eventType = "Mens Outdoor Dec"
    
    @IBOutlet var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
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
