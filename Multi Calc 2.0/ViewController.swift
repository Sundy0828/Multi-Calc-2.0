//
//  ViewController.swift
//  Multi Calc 2.0
//
//  Created by Jerrod on 3/19/18.
//  Copyright © 2018 Jerrod Sunderland. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    static var metric = true
    var changed = false
    
    // base values for function
    var eventClicked = -1
    var sex = "men"
    let convertFeet = 3.280839895
    var totScore = 0
    
    // picker values
    var pickerTimeOne = [String]()
    var pickerTimeTwo = [String]()
    var pickerTimeThree = [String]()
    
    var pickerDistOne = [String]()
    var pickerDistTwo = [String]()
    var pickerDistThree = [String]()
    
    
    let userSettings = UserDefaults.standard
    
    // set big view height to be 35% of screen
    let height = UIScreen.main.bounds.size.height
    let width = UIScreen.main.bounds.size.width

    @IBOutlet var scrollLbl: UILabel!
    
    @IBOutlet var eventLbl: UILabel!
    @IBOutlet var markLbl: UILabel!
    @IBOutlet var scoreLbl: UILabel!
    
    // table and picker outlets
    @IBOutlet var eventsTbl: UITableView!
    @IBOutlet var timePicker: UIPickerView!
    @IBOutlet var distPicker: UIPickerView!
    
    var eventsArr = [String]()
    
    // set all arrays
    func setArrays() {
        // put number in mark and score arrays
        for _ in 0...eventsArr.count - 1 {
            var holdArr = [String]()
            holdArr.append("00")
            holdArr.append("00")
            holdArr.append("00")
            GlobalVariable.markArray.append(holdArr)
            GlobalVariable.scoreArray.append("0000")
        }
        
        // put numbers 0 - 99 in for picker components
        for i in 0...149 {
            var number = String(i)
            if i < 10 {
                pickerDistTwo.append(number)
                pickerDistThree.append(number)
                number = "0" + number
            }
            
            // make sure min and sec values dont go above 59
            if i < 60 {
                pickerTimeTwo.append(number)
            }
            // final decimal and first values for each picker go to 99
            if i < 100 {
                pickerTimeOne.append(number)
                pickerTimeThree.append(number)
            }
            
            // go the rest of the way (specifically for JT but also all distances)
            pickerDistOne.append(number)
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        changeTheme()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) { [weak self] in
            self?.eventsTbl.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // set table and pickers
        eventsTbl.dataSource = self
        eventsTbl.delegate = self
        
        timePicker.dataSource = self
        timePicker.delegate = self
        
        distPicker.dataSource = self
        distPicker.delegate = self
        
        timePicker.isHidden = true
        distPicker.isHidden = true
        
        // set events based on what event type user chose
        setEventsArray(eventSelected: GlobalVariable.eventType)
        
        // set arrays picker and table
        setArrays()
        
        // convert distances and get points based off of settings values
        for i in 0...eventsArr.count - 1 {
            if !eventsArr[i].contains("0") {
                GlobalVariable.markArray[i] = convertDistance(mark: GlobalVariable.markArray[i], metric: ViewController.metric)
            }
            let points = getPoints(event: eventsArr[i], selected: i)
            if !points.isNaN {
                if Int(GlobalVariable.markArray[i][0]) != 0 || Int(GlobalVariable.markArray[i][1]) != 0 || Int(GlobalVariable.markArray[i][2]) != 0 {
                    GlobalVariable.scoreArray[i] = String(Int(points))
                }else {
                    GlobalVariable.scoreArray[i] = "0000"
                }
                
            }
        }
        
        // calc score
        calcScore()
        
    }
    // convert distance
    func convertDistance(mark: [String], metric: Bool) -> [String] {
        var hold = Double(mark[0] + "." + mark[1] + mark[2])!
        if GlobalVariable.measure != metric {
            if GlobalVariable.measure {
                hold = convertToMeter(mark: mark)
            }else {
                hold = convertToFeet(mark: mark)
            }
            changed = true
        }
        
        
        let one = Int(hold)
        let two = (hold - Double(one)) * 10
        let three = (two - Double(Int(two))) * 10
        
        return [String(Int(one)), String(Int(two)), String(Int(three.rounded()))]
    }
    // convert to feet
    func convertToFeet(mark: [String]) -> Double {
        var returnVal = 0.0
        let convertFeet = 3.280839895
        
        let partOne = mark[0]
        let partTwo = mark[1]
        let partThree = mark[2]
        
        if partOne != "" || partTwo != "" || partThree != "" {
            returnVal = Double(partOne + "." + partTwo + partThree)!
        }
        returnVal = returnVal * convertFeet
        
        return returnVal
    }
    // convert to meter
    func convertToMeter(mark: [String]) -> Double {
        var returnVal = 0.0
        let convertFeet = 3.280839895
        
        let partOne = mark[0]
        let partTwo = mark[1]
        let partThree = mark[2]
        
        if partOne != "" || partTwo != "" || partThree != "" {
            returnVal = Double(partOne + "." + partTwo + partThree)!
        }
        returnVal = returnVal / convertFeet
        
        return returnVal
    }
    // each multi has a set of events and these are the sets for each event
    func setEventsArray(eventSelected : String) {
        switch (eventSelected) {
        case "Mens Outdoor Dec" :
            eventsArr = ["100", "LJ", "SP", "HJ", "400", "110H", "DT", "PV", "JT", "1500"]
            sex = "men"
            break;
        case "Mens Outdoor Pen" :
            eventsArr = ["LJ", "JT", "200", "DT", "1500"]
            sex = "men"
            break;
        case "Mens Indoor Hep" :
            eventsArr = ["60", "LJ", "SP", "HJ", "60H", "PV", "1000"]
            sex = "men"
            break;
        case "Mens Indoor Pen" :
            eventsArr = ["60H", "LJ", "SP", "HJ", "1000"]
            sex = "men"
            break;
        case "Womens Outdoor Hep" :
            eventsArr = ["100H", "HJ", "SP", "200", "LJ", "JT", "800"]
            sex = "women"
            break;
        case "Womens Outdoor Dec" :
            eventsArr = ["100", "DT", "PV", "JT", "400", "100H", "LJ", "SP", "HJ", "1500"]
            sex = "women"
            break;
        case "Womens Indoor Pen" :
            eventsArr = ["60H", "HJ", "SP", "LJ", "800"]
            sex = "women"
            break;
        default:
            eventsArr = [String]()
        }
    }

    //
    // table section
    //
    // number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsArr.count
    }
    // height of row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // use custom cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventsCell") as! CustomTableViewCell
        // set measure appearance
        var measure = "m"
        if !GlobalVariable.measure {
            measure = "ft"
        }
        cell.contentView.backgroundColor = GlobalVariable.backgroundColor
        let cellHeight = cell.cellView.frame.height
        let cellWidth = cell.cellView.frame.width
        
        // set corner radius to half of height
        let corner = cellHeight/2
        cell.cellView.layer.cornerRadius = corner
        cell.cellView.clipsToBounds = true
        cell.cellView.backgroundColor = GlobalVariable.tableViewColor
        
        // change blue to gray if cell was clicked
        if indexPath.row == eventClicked {
            cell.calcLbl.backgroundColor = GlobalVariable.tableViewBtnColor
        }else {
            cell.calcLbl.backgroundColor = GlobalVariable.myBlue
        }
        
        
        // set calc label and round courners
        cell.calcLbl.text = "Enter \(eventsArr[indexPath.row])"
        cell.calcLbl.layer.cornerRadius = corner
        cell.calcLbl.clipsToBounds = true
        // set blue label width but it goes to thr right width after a table is selected
        cell.calcLbl.frame.size.width = 171/345*cellWidth
        
        // set marks based if it needs a time or distance
        if eventsArr[indexPath.row].contains("0") {
            cell.markLbl.text = GlobalVariable.markArray[indexPath.row][0] + ":" + GlobalVariable.markArray[indexPath.row][1] + "." + GlobalVariable.markArray[indexPath.row][2]
        }else {
            cell.markLbl.text = GlobalVariable.markArray[indexPath.row][0] + "." + GlobalVariable.markArray[indexPath.row][1] + GlobalVariable.markArray[indexPath.row][2] + measure
        }
        
        // set scores
        cell.scoreLbl.text = GlobalVariable.scoreArray[indexPath.row]
        
        return cell
    }
    // on row select
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        scrollLbl.isHidden = true
        // set value to one clicked to know which one to turn gray and refresh table
        eventClicked = indexPath.row
        // decide which picker view to hide
        var hidden = false
        if eventsArr[eventClicked].contains("0") {
            hidden = true
            timePicker.selectRow(Int(GlobalVariable.markArray[eventClicked][0])!, inComponent: 0, animated: false)
            timePicker.selectRow(Int(GlobalVariable.markArray[eventClicked][1])!, inComponent: 1, animated: false)
            timePicker.selectRow(Int(GlobalVariable.markArray[eventClicked][2])!, inComponent: 2, animated: false)
        }else {
            distPicker.selectRow(Int(GlobalVariable.markArray[eventClicked][0])!, inComponent: 0, animated: false)
            distPicker.selectRow(Int(GlobalVariable.markArray[eventClicked][1])!, inComponent: 1, animated: false)
            distPicker.selectRow(Int(GlobalVariable.markArray[eventClicked][2])!, inComponent: 2, animated: false)
        }
        timePicker.isHidden = !hidden
        distPicker.isHidden = hidden
        
        
        
        eventsTbl.reloadData()
    }
    //
    // Picker section
    //
    // set picker color/text
    func pickerColorChange(pickerRow: String? = "", unit : String? = "", dec : String? = "") -> UILabel? {
        // set label (color, size, and text)
        let pickerLabel = UILabel()
        pickerLabel.textColor = GlobalVariable.textColor
        pickerLabel.text = dec! + pickerRow! + unit!
        let size = 20/375*width
        pickerLabel.font = UIFont(name: "AvenirNext-Regular", size: size)
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
    
    // pick picker text
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var returnVal =  pickerColorChange(pickerRow: "")
        
        // if time picker add min, sec, and mili sec/. where needed
        if pickerView == timePicker {
            if component == 0 {
                returnVal = pickerColorChange(pickerRow: pickerTimeOne[row], unit: " min")
            }else if component == 1 {
                returnVal = pickerColorChange(pickerRow: pickerTimeTwo[row], unit: " sec")
            }else {
                returnVal = pickerColorChange(pickerRow: pickerTimeThree[row], unit: " mili sec",dec: ".")
            }
        }else {
            // based on measure chosen set distance picker
            if GlobalVariable.measure {
                if component == 0 {
                    returnVal =  pickerColorChange(pickerRow: pickerDistOne[row], unit: " m")
                }else if component == 1 {
                    returnVal =  pickerColorChange(pickerRow: pickerDistTwo[row], unit: " deci" ,dec: ".")
                }else {
                    returnVal =  pickerColorChange(pickerRow: pickerDistThree[row], unit: " centi")
                }
            }else {
                if component == 0 {
                    returnVal =  pickerColorChange(pickerRow: pickerDistOne[row], unit: " ft")
                }else if component == 1 {
                    returnVal =  pickerColorChange(pickerRow: pickerDistTwo[row] ,dec: ".")
                }else {
                    returnVal =  pickerColorChange(pickerRow: pickerDistThree[row], unit: " in")
                }
            }
        }
        return returnVal!
    }
    // number of selections for picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // return 3 columns for each picker
        return 3
    }
    // number of rows in each section of picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // if time (track event)
        if pickerView == timePicker {
            if component == 0 {
                return pickerTimeOne.count
            }else if component == 1 {
                return pickerTimeTwo.count
            }else {
                return pickerTimeThree.count
            }
            // if dist (field event)
        }else {
            if component == 0 {
                return pickerDistOne.count
            }else if component == 1 {
                return pickerDistTwo.count
            }else {
                return pickerDistThree.count
            }
        }
    }
    // set each value in each row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // if time (track event)
        if pickerView == timePicker {
            if component == 0 {
                return pickerTimeOne[row]
            }else if component == 1 {
                return pickerTimeTwo[row]
            }else {
                return pickerTimeThree[row]
            }
            // if dist (field event)
        }else {
            if component == 0 {
                return pickerDistOne[row]
            }else if component == 1 {
                return pickerDistTwo[row]
            }else {
                return pickerDistThree[row]
            }
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var selectedOne, selectedTwo, selectedThree : Int
        var one, two, three : String
        
        //use row selected to find final value
        if pickerView == timePicker {
            //get row selected
            selectedOne = timePicker.selectedRow(inComponent: 0)
            selectedTwo = timePicker.selectedRow(inComponent: 1)
            selectedThree = timePicker.selectedRow(inComponent: 2)
            one = pickerTimeOne[selectedOne]
            two = pickerTimeTwo[selectedTwo]
            three = pickerTimeThree[selectedThree]
        }else {
            // get row selected
            selectedOne = distPicker.selectedRow(inComponent: 0)
            selectedTwo = distPicker.selectedRow(inComponent: 1)
            selectedThree = distPicker.selectedRow(inComponent: 2)
            one = pickerDistOne[selectedOne]
            two = pickerDistTwo[selectedTwo]
            three = pickerDistThree[selectedThree]
        }
        // set each picker component to correct area
        GlobalVariable.markArray[eventClicked][0] = one
        GlobalVariable.markArray[eventClicked][1] = two
        GlobalVariable.markArray[eventClicked][2] = three
        
        // get points and set them
        let points = getPoints(event: eventsArr[eventClicked], selected: eventClicked)
        GlobalVariable.scoreArray[eventClicked] = "0"
        if !points.isNaN {
            if one != "00" || two != "00" || three != "00" {
                GlobalVariable.scoreArray[eventClicked] = String(Int(points))
            }
        }
        // calc score
        calcScore()

        eventsTbl.reloadData()
    }
    
    //
    // calculate score
    //
    // a,b, and c values for each event
    func getPoints(event: String, selected: Int) -> Double {
        var markType = ""
        var a, b, c, tot : Double
        // Men
        if sex == "men" {
            switch event {
            // Outdoor
            case "100":
                a =  25.4347
                b = 18.00
                c = 1.81
                markType = "track"
                break
            case "200":
                a =  5.8425
                b = 38.00
                c = 1.81
                markType = "track"
                break
            case "400":
                a =  1.53775
                b = 82.00
                c = 1.81
                markType = "track"
                break
            case "1500":
                a =  0.03768
                b = 480.00
                c = 1.85
                markType = "track"
                break
            case "110H":
                a =  5.74352
                b = 28.50
                c = 1.92
                markType = "track"
                break
            case "HJ":
                a =  0.8465
                b = 75.00
                c = 1.42
                markType = "jump"
                break
            case "PV":
                a =  0.2797
                b = 100.00
                c = 1.35
                markType = "jump"
                break
            case "LJ":
                a =  0.14354
                b = 220.00
                c = 1.40
                markType = "jump"
                break
            case "SP":
                a =  51.39
                b = 1.50
                c = 1.05
                markType = "throw"
                break
            case "DT":
                a =  12.91
                b = 4.00
                c = 1.10
                markType = "throw"
                break
            case "JT":
                a =  10.14
                b = 7.00
                c = 1.08
                markType = "throw"
                break
            // INDOOR
            case "60":
                a =  58.0150
                b = 11.50
                c = 1.81
                markType = "track"
                break
            case "1000":
                a =  0.08713
                b = 305.00
                c = 1.85
                markType = "track"
                break
            case "60H":
                a =  20.5173
                b = 15.50
                c = 1.92
                markType = "track"
                break
            default:
                a = 0
                b = 0
                c = 0
                markType = ""
            }
            // WOMEN
        }else {
            switch event {
            // Outdoor
            case "200":
                a =  4.99087
                b = 42.50
                c = 1.81
                markType = "track"
                break
            case "800":
                a =  0.11193
                b = 254.00
                c = 1.88
                markType = "track"
                break
            case "100H":
                a =  9.23076
                b = 26.70
                c = 1.835
                markType = "track"
                break
            case "HJ":
                a =  1.84523
                b = 75.00
                c = 1.348
                markType = "jump"
                break
            case "LJ":
                a =  0.188807
                b = 210.50
                c = 1.41
                markType = "jump"
                break
            case "SP":
                a =  56.0211
                b = 1.50
                c = 1.05
                markType = "throw"
                break
            case "JT":
                a =  15.9803
                b = 3.80
                c = 1.04
                markType = "throw"
                break
            case "100":
                a =  17.8570
                b = 21.0
                c = 1.81
                markType = "track"
                break
            case "400":
                a =  1.34285
                b = 91.7
                c = 1.81
                markType = "track"
                break
            case "1500":
                a =  0.02883
                b = 535
                c = 1.88
                markType = "track"
                break
            case "PV":
                a =  0.44125
                b = 100
                c = 1.35
                markType = "jump"
                break
            case "DT":
                a =  12.3311
                b = 3
                c = 1.10
                markType = "throw"
                break
            // INDOOR
            case "60H":
                a =  20.0479
                b = 17
                c = 1.835
                markType = "track"
                break
            default:
                a = 0
                b = 0
                c = 0
                markType = ""
            }
        }
        
        var hold, mark : Double
        if markType == "track" {
            // if track event get time in sec and follow formula a*(b-mark)**c
            mark = convertToSec(selected: selected)
            hold = pow((b - mark), c)
            tot = a*hold
        }else if markType == "jump" {
            // if jump event get dist in centimeters and follow formula a*(mark-b)**c
            mark = convertToMeter(selected: selected)
            hold = pow((mark*100.0 - b), c)
            tot = a*hold
        }else {
            // if throw event get dist in meters and follow formula a*(mark-b)**c
            mark = convertToMeter(selected: selected)
            hold = pow((mark - b), c)
            tot = a*hold
        }
        return tot
    }
    // convert to meter
    func convertToMeter(selected: Int) -> Double {
        var returnVal = 0.0
        
        let partOne = GlobalVariable.markArray[selected][0]
        let partTwo = GlobalVariable.markArray[selected][1]
        let partThree = GlobalVariable.markArray[selected][2]
        
        if partOne != "" || partTwo != "" || partThree != "" {
            returnVal = Double(partOne + "." + partTwo + partThree)!
        }
        if !GlobalVariable.measure {
            returnVal = returnVal / convertFeet
        }
        return returnVal
    }
    // convert to sec
    func convertToSec(selected: Int) -> Double {
        var returnVal = 0.0
        
        let partOne = GlobalVariable.markArray[selected][0]
        let partTwo = GlobalVariable.markArray[selected][1]
        let partThree = GlobalVariable.markArray[selected][2]
        
        if partOne != "" {
            returnVal = returnVal + (Double(partOne)! * 60.0)
        }
        if partTwo != "" && partThree != "" {
            returnVal = returnVal + Double(partTwo + "." + partThree)!
        }else if partTwo != "" {
            returnVal = returnVal + Double(partTwo)!
        }else if partThree != "" {
            returnVal = returnVal + Double("." + partThree)!
        }
        if !GlobalVariable.auto {
            returnVal += 0.14
        }
        if GlobalVariable.distStepperVal < 400 {
            returnVal += 0.1
        }
        return returnVal
    }
    // convert double to string without losing decimal places
    func convertToString(num : Double) -> String {
        return String(format: "%.64f", num)
    }
    // get total score and set it as title
    func calcScore() {
        totScore = 0
        for i in 0...eventsArr.count - 1 {
            let hold = GlobalVariable.scoreArray[i]
            totScore = totScore + Int(hold)!
            self.title = "Score - " + String(totScore)
        }
    }
    func changeTheme() {
        eventLbl.textColor = GlobalVariable.textColor
        markLbl.textColor = GlobalVariable.textColor
        scoreLbl.textColor = GlobalVariable.textColor
        scrollLbl.textColor = GlobalVariable.textColor
        self.view.backgroundColor = GlobalVariable.backgroundColor
        eventsTbl.backgroundColor = GlobalVariable.backgroundColor
    }
}

