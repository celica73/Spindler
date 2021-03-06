//
//  ViewController.swift
//  Spindler
//
//  Created by Scott Johnson on 5/21/16.
//  Copyright © 2016 Scott Johnson. All rights reserved.
//

import UIKit

class LanscapeView: UIViewController, UITextFieldDelegate {
    
    var engine = MathEngine()
    
    @IBOutlet var postSpacing: UITextField!
    @IBOutlet var spindleWidth: UITextField!
    @IBOutlet var maxSpace: UITextField!
    @IBOutlet var spaces: UITextField!
    @IBOutlet var spindles: UITextField!
    @IBOutlet var onCenter: UITextField!
    @IBOutlet var between: UITextField!
    @IBOutlet var angle: UITextField!
    @IBOutlet var rise: UITextField!
    @IBOutlet var run: UITextField!
    
    @IBOutlet var pictureView: SpindleDiagram!
    
    @IBOutlet var horizPincher: UIPinchGestureRecognizer!
    
    let pinchRec = UIPinchGestureRecognizer()
    var bottomText: UITextField!
    
        override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        registerForKeyboardNotifications()
        postSpacing.tag = 0
        spindleWidth.tag = 1
        maxSpace.tag = 2
        spaces.tag = 3
        spindles.tag = 4
        onCenter.tag = 5
        between.tag = 6
        angle.tag = 7
        rise.tag = 8
        run.tag = 9
        updateValues()
            pinchRec.addTarget(self, action: #selector(LanscapeView.horizontalPinch))
        pictureView.addGestureRecognizer(pinchRec)
        pictureView.userInteractionEnabled = true
        pictureView.multipleTouchEnabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateValues() {
        postSpacing.text = asFraction(engine.postSpacing)
        spindleWidth.text = asFraction(engine.spindleWidth)
        maxSpace.text = asFraction(engine.maxSpace)
        spaces.text = String(engine.numSpaces)
        spindles.text = String(engine.numSpindles)
        onCenter.text = asFraction(engine.onCenter)
        between.text = asFraction(engine.between)
        angle.text = NSString(format: "%.0f",engine.angle) as String
        rise.text = asFraction(engine.rise)
        run.text = asFraction(engine.run)
    }
    
    @IBAction func shiftWindow(sender: UITextField) {
        bottomText = sender;
    }
    
    @IBAction func updateView(sender: AnyObject) {
        NSLog(String(sender.tag))
        let update = sender.tag
        let inputCheck = validateInput(sender.text!, fieldTag: update)
        if(inputCheck.0) {
            let newNumber = inputCheck.1
            engine.updateOperation(update, newValue: newNumber)
            updateValues()
        } else {
            let badField = sender as! UITextField
            badField.text = "Invalid"
        }
    }
    
    func asFraction(number: Double) -> String {
        let fraction = number - Double(Int(number))
        var denominator = 32
        var numerator = Int(fraction * Double(denominator))
        
        while(numerator != 0 && numerator % 2 == 0) {
            numerator /= 2
            denominator /= 2
        }
        if(numerator == 0) {
            return String(Int(number))
        } else {
            return NSString(format: "%d %d/%d", Int(number), numerator, denominator) as String
        }
    }
    
    func validateInput(input: String, fieldTag: Int) -> (Bool, Double) {
        let value = asDecimal(input)
        if( value >= 0 ) {
            return (true, value)
        } else {
            return (false, value)
        }
    }
    
    func asDecimal(number: String) -> Double {
        let trimmedNumber = number.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let numArray = Array(trimmedNumber.characters)
        var root: Double = 0.0
        var numerator: Double = 0.0
        var denominator: Double = 0.0
        
        var spaceLocation: Int = -1
        var fracLocation: Int = -1
        var decimalLocation: Int = -1
        
        //validate characters
        for i in 0..<numArray.count {
            if( numArray[i] == "."){
                if( decimalLocation != -1 ) {return -1}
                decimalLocation = i
            } else if( numArray[i] == " " ) {
                if( spaceLocation != -1 ) {return -1}
                spaceLocation = i
            } else if( numArray[i] == "/" ) {
                if( fracLocation != -1 ) {return -1}
                fracLocation = i
            } else if( numArray[i] < "0" || numArray[i] > "9") {
                return -1
            }
        }
        //real number, return it
        if( spaceLocation == -1 && fracLocation == -1 ) {
            return Double(trimmedNumber)!
        }
        //is it a fraction
        if( spaceLocation != -1) {
            root = Double(trimmedNumber.characters.split{$0 == " "}.map(String.init)[0])!
            let substring = trimmedNumber.characters.split{$0 == " "}.map(String.init)[1]
            numerator = Double(substring.characters.split{$0 == "/"}.map(String.init)[0])!
            denominator = Double(substring.characters.split{$0 == "/"}.map(String.init)[1])!
        }
        return root + numerator/denominator
    }
    
    func registerForKeyboardNotifications()
    {
        //Adding notifies on keyboard appearing
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func deregisterFromKeyboardNotifications()
    {
        //Removing notifies on keyboard appearing
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomText.tag == 5 || bottomText.tag == 6 || bottomText.tag == 7 || bottomText.tag == 8 || bottomText.tag == 9 {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                self.view.window?.frame.origin.y = -0.5 * keyboardSize.height
            }
        } else if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.window?.frame.origin.y = 0 * keyboardSize.height
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if self.view.window?.frame.origin.y != 0 {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                self.view.window?.frame.origin.y += keyboardSize.height
            }
        }
    }

    @IBAction func horizontalPinch(sender: UIPinchGestureRecognizer) {

        let newAngle = Double(sender.scale) > 1 ? Double(sender.scale) * 5 + Double(engine.angle) : Double(engine.angle) - Double(sender.scale)
        engine.angle =  newAngle > 0 ? newAngle: 0
        NSLog(String(sender.scale))
        NSLog("new angle = %d", Int(newAngle))
        pictureView.angle = engine.angle
        updateView(angle)
    }
}

//code for figuring out scaling from x and y
//CGPoint firstPoint = [recognizer locationOfTouch:0 inView:recognizer.view];
//CGPoint secondPoint = [recognizer locationOfTouch:1 inView:recognizer.view];
//
//CGFloat angle = atan2(secondPoint.y - firstPoint.y, secondPoint.x - firstPoint.x);
