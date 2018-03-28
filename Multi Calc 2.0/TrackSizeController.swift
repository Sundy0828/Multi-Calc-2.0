//
//  LapDistController.swift
//  Pace Calc 4.0
//
//  Created by Jerrod on 3/11/18.
//  Copyright © 2018 Jerrod Sunderland. All rights reserved.
//

import UIKit

class TrackSizeController: UIViewController {
    
    // buttons in custom segmented control
    @IBOutlet var stackBtnVal2: UIButton!
    @IBOutlet var stackBtnVal3: UIButton!
    @IBOutlet var stackBtnVal4: UIButton!
    @IBOutlet var stackBtnVal5: UIButton!
    
    // height of stack
    @IBOutlet var stackHeight: NSLayoutConstraint!
    
    // view custom segmented control is in
    @IBOutlet var stepperView: UIView!
    
    // "stepper" buttons and segmented control
    @IBOutlet weak var stepperMinus: UIButton!
    @IBOutlet weak var stepperPlus: UIButton!
    
    // lap dist
    @IBOutlet weak var lapDist: UILabel!
    
    // keys, timers and basic variables
    let userSettings = UserDefaults.standard
    var distStepper = 100.0
    var btnTagClicked = 4
    let keyDist = "distChoice"
    let keyPaceDist = "paceDistChoice"
    let keyTheme = "theme"
    let keyLapDist = "lapDist"
    var timer: Timer!
    var timerOne: Timer!
    var stackBtnVal = [UIButton]()
    
    // get height and width of phone
    let height = UIScreen.main.bounds.size.height
    let width = UIScreen.main.bounds.size.width
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        //changeTheme()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // add buttons to array so they dont change positions
        stackBtnVal.append(stackBtnVal2)
        stackBtnVal.append(stackBtnVal3)
        stackBtnVal.append(stackBtnVal4)
        stackBtnVal.append(stackBtnVal5)
        
        // style buttons
        styleBtnBlue(btn: stepperPlus, heightT: 30)
        styleBtnBlue(btn: stepperMinus, heightT: 30)
        
        for i in 0...stackBtnVal.count - 1 {
            styleBtnWhite(btn: stackBtnVal[i], heightT: 17)
        }
        styleBtnBlue(btn: stackBtnVal[stackBtnVal.count - 1], heightT: 17)
        
        // style segmented control
        let stackBtnHeight = 50/667*width
        stackHeight.constant = stackBtnHeight
        stepperView.clipsToBounds = true
        stepperView.layer.cornerRadius = stackBtnHeight/2
        
        // set text size of lap dist
        let sizeS = CGFloat(Int(20/375*width))
        let smallFont = UIFont(name: "AvenirNext-Bold", size: sizeS)
        lapDist.font = smallFont
        
        // set value of lap dist
        lapDist.text = "Track Size: \(GlobalVariable.distStepperVal) meters"
        //changeTheme()
    }
    @IBAction func stepBtnPressed(_ sender: UIButton) {
        // set distance and change titles
        btnTagClicked = sender.tag
        distStepper = Double(sender.currentTitle!)!
        stepperMinus.setTitle("- \(distStepper)m", for: UIControlState.normal)
        stepperPlus.setTitle("+ \(distStepper)m", for: UIControlState.normal)
        for i in 0...stackBtnVal.count - 1 {
            if sender.tag == i {
                styleBtnBlue(btn: stackBtnVal[i], heightT: 17)
            }else {
                styleBtnWhite(btn: stackBtnVal[i], heightT: 17)
            }
        }
    }
    @IBAction func minusDownBtn(_ sender: Any) {
        // subtract values based on stepper
        minus()
        // repeat minus function to move values faster if held down
        timerOne = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector:#selector(minus), userInfo: nil, repeats: true)
    }
    // subtract values from lap split distance
    @IBAction func minusUpBtn(_ sender: Any) {
        timerOne.invalidate()
    }
    @objc func minus() {
        // if value == 1609.344 then make it go to 1600 so its an even number
        if GlobalVariable.distStepperVal - distStepper < 1600 && GlobalVariable.distStepperVal > 1600 {
            GlobalVariable.distStepperVal = 1600
            //make sure it doesnt get less than 100 meters
        }else if GlobalVariable.distStepperVal - distStepper >= 100{
            GlobalVariable.distStepperVal -= distStepper
        }else {
            alert(message: "Sorry, no laps less than 100 meters!")
            timerOne.invalidate()
        }
        lapDist.text = "Track Size: \(GlobalVariable.distStepperVal)  meters"
        userSettings.set(GlobalVariable.distStepperVal, forKey: keyLapDist)
    }
    
    
    @IBAction func plusDownBtn(_ sender: Any) {
        plus()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector:#selector(plus), userInfo: nil, repeats: true)
    }
    // add value to lap split distance
    @IBAction func plusUpBtn(_ sender: Any) {
        timer.invalidate()
    }
    @objc func plus() {
        // make sure it doesnt get higher than 1600 meters (1609.344)
        if GlobalVariable.distStepperVal + distStepper <= 1600{
            GlobalVariable.distStepperVal += distStepper
            //lapSplit()
            // allow user to go to a full mile
        }else {
            GlobalVariable.distStepperVal = 1609.344
            //lapSplit()
            alert(message: "Sorry, no laps more than 1609.344 meters (1 mile)!")
            timer.invalidate()
        }
        lapDist.text = "Track Size: \(GlobalVariable.distStepperVal)  meters"
        userSettings.set(GlobalVariable.distStepperVal, forKey: keyLapDist)
    }
    
    // style button blue
    func styleBtnBlue(btn: UIButton, heightT: CGFloat) {
        //set color to blue
        let btnColor = GlobalVariable.myBlue.cgColor
        
        // set text size
        let sizeS = CGFloat(Int(heightT/375*width))
        let smallFont = UIFont(name: "AvenirNext-Bold", size: sizeS)
        btn.titleLabel?.font = smallFont
        
        // use color blue and round corners
        btn.layer.backgroundColor = btnColor
        if heightT > 17 {
            btn.layer.cornerRadius = 50/2
        }
        btn.setTitleColor(.black, for: .normal)
        
    }
    // style button white
    func styleBtnWhite(btn: UIButton, heightT: CGFloat) {
        //set color to white
        let btnColor = UIColor.white.cgColor
        
        // set text size
        let sizeS = CGFloat(Int(heightT/375*width))
        let smallFont = UIFont(name: "AvenirNext-Bold", size: sizeS)
        btn.titleLabel?.font = smallFont
        
        // use color blue and round corners
        btn.layer.backgroundColor = btnColor
        if heightT > 17 {
            btn.layer.cornerRadius = 50/2
        }
        btn.setTitleColor(.black, for: .normal)
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
    /*
    func changeTheme() {
        var textColor : UIColor
        var bgColor: UIColor
        // set colors
        if GlobalVariable.theme == "dark" {
            bgColor = UIColor.darkGray
            textColor = .white
        }else {
            bgColor = GlobalVariable.silver
            textColor = .black
        }
        self.view.backgroundColor = bgColor
        lapDist.textColor = textColor
    }*/
}
