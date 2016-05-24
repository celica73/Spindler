//
//  ViewController.swift
//  Spindler
//
//  Created by Scott Johnson on 5/21/16.
//  Copyright © 2016 Scott Johnson. All rights reserved.
//

import UIKit

class LanscapeView: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    var engine = MathEngine()
    
    @IBOutlet var postSpacing: UILabel!
    @IBOutlet var spindleWidth: UILabel!
    @IBOutlet var maxSpace: UILabel!
    @IBOutlet var spaces: UILabel!
    @IBOutlet var spindles: UILabel!
    @IBOutlet var onCenter: UILabel!
    @IBOutlet var between: UILabel!
    @IBOutlet var angle: UILabel!
    @IBOutlet var rise: UILabel!
    @IBOutlet var run: UILabel!
    
    @IBOutlet var pictureView: SpindleDiagram!
    
    @IBOutlet var swipeGesture: UIPanGestureRecognizer!
    
    var tapLabel: UILabel!
    var labelColor: UIColor!
    
    let swipeRec = UIPanGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        postSpacing.tag = 1
        spindleWidth.tag = 2
        maxSpace.tag = 3
        spaces.tag = 4
        spindles.tag = 5
        onCenter.tag = 6
        between.tag = 7
        angle.tag = 8
        rise.tag = 9
        run.tag = 10
        updateValues()
        swipeRec.addTarget(self, action: #selector(LanscapeView.swiper))
        pictureView.addGestureRecognizer(swipeRec)
        pictureView.userInteractionEnabled = true
        pictureView.multipleTouchEnabled = true
        pictureView.rise = engine.rise
        for i in 0...9 {
            if let taggedLabel = self.view.viewWithTag(i) as? UILabel {
                NSLog(String(taggedLabel.text))
                taggedLabel.userInteractionEnabled = true
                let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LanscapeView.labelAction))
                taggedLabel.addGestureRecognizer(tap)
                tap.delegate = self // Remember to extend your class with UIGestureRecognizerDelegate
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateValues() {
        postSpacing.text = "PostSpacing: " + asFraction(engine.postSpacing) + "\""
        spindleWidth.text = "Spindle Width: " + asFraction(engine.spindleWidth) + "\""
        maxSpace.text = "Max Space: " + asFraction(engine.maxSpace) + "\""
        spaces.text = "Spaces: " + String(engine.numSpaces)
        spindles.text = "Spindles: " + String(engine.numSpindles)
        onCenter.text = "On center: " + asFraction(engine.onCenter) + "\""
        between.text = "Between: " + asFraction(engine.between) + "\""
        angle.text = NSString(format: "Angle: %.0f deg.",engine.angle) as String
        rise.text = "Rise: " + asFraction(engine.rise) + "\""
        run.text = "Run: " + asFraction(engine.run) + "\""
    }
    

    
    // Receive action
    func labelAction(gr:UITapGestureRecognizer) {
        let searchlbl:UILabel = (gr.view as! UILabel) // Type cast it with the class for which you have added gesture
        print(searchlbl.text)
        
        if tapLabel != nil && tapLabel == searchlbl {
            tapLabel.textColor = .whiteColor()
            tapLabel = nil
        } else {
            if tapLabel != nil {
                tapLabel.textColor = .whiteColor()
            }
            tapLabel = searchlbl
            tapLabel.textColor = .orangeColor()
        }
    }
    
//     @IBAction func updateView(sender: AnyObject) {
////        NSLog(String(sender.tag, sender.text))
//        let update = sender.tag
//        let inputCheck = validateInput(sender.text!, fieldTag: update)
//        if(inputCheck.0) {
//            let newNumber = inputCheck.1
//            engine.updateOperation(update, newValue: newNumber)
//            updateValues()
//        } else {
//            let badField = sender as! UILabel
//            badField.text = "Invalid"
//        }
//    }
    
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
    
//    func validateInput(input: String, fieldTag: Int) -> (Bool, Double) {
//        let value = asDecimal(input)
//        if( value >= 0 ) {
//            return (true, value)
//        } else {
//            return (false, value)
//        }
//    }
    
//    func asDecimal(number: String) -> Double {
//        let trimmedNumber = number.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
//        let numArray = Array(trimmedNumber.characters)
//        var root: Double = 0.0
//        var numerator: Double = 0.0
//        var denominator: Double = 0.0
//        
//        var spaceLocation: Int = -1
//        var fracLocation: Int = -1
//        var decimalLocation: Int = -1
//        
//        //validate characters
//        for i in 0..<numArray.count {
//            if( numArray[i] == "."){
//                if( decimalLocation != -1 ) {return -1}
//                decimalLocation = i
//            } else if( numArray[i] == " " ) {
//                if( spaceLocation != -1 ) {return -1}
//                spaceLocation = i
//            } else if( numArray[i] == "/" ) {
//                if( fracLocation != -1 ) {return -1}
//                fracLocation = i
//            } else if( numArray[i] < "0" || numArray[i] > "9") {
//                return -1
//            }
//        }
//        //real number, return it
//        if( spaceLocation == -1 && fracLocation == -1 ) {
//            return Double(trimmedNumber)!
//        }
//        //is it a fraction
//        if( spaceLocation != -1) {
//            root = Double(trimmedNumber.characters.split{$0 == " "}.map(String.init)[0])!
//            let substring = trimmedNumber.characters.split{$0 == " "}.map(String.init)[1]
//            numerator = Double(substring.characters.split{$0 == "/"}.map(String.init)[0])!
//            denominator = Double(substring.characters.split{$0 == "/"}.map(String.init)[1])!
//        }
//        return root + numerator/denominator
//    }
    
    var startLocation: CGPoint!
    @IBAction func swiper(sender: UIPanGestureRecognizer) {
        var changeValue:Double  = 0
        if tapLabel != nil {
            changeValue = engine.getValue(tapLabel.tag)
        } else {
            return
        }
        if (sender.state == UIGestureRecognizerState.Began) {
            startLocation = sender.locationInView(self.view)
        } else if (sender.state == UIGestureRecognizerState.Changed) {
            let stopLocation: CGPoint = sender.locationInView(self.view);
            let dx: CGFloat = stopLocation.x - startLocation.x;
            let dy: CGFloat = stopLocation.y - startLocation.y;
            var distance: CGFloat = sqrt(dx*dx + dy*dy);
            if dy > 0 || dx < 0 {
                distance = -distance
            }
            NSLog("Distance: %f", distance);
            var newValue = Double(distance) > 0 ? Double(distance) * 0.1 + Double(changeValue) : Double(changeValue) + Double(distance) * 0.1
            newValue = newValue <= 0 ? 0 : newValue
            engine.updateOperation(tapLabel.tag, newValue: newValue)
            //        NSLog("new value = %d", Int(engine.getValue(tapLabel.tag)))
            updateValues()
            pictureView.rise = engine.rise
            pictureView.spindles = engine.numSpindles
            startLocation = stopLocation
        }
    }
}

//code for figuring out scaling from x and y
//CGPoint firstPoint = [recognizer locationOfTouch:0 inView:recognizer.view];
//CGPoint secondPoint = [recognizer locationOfTouch:1 inView:recognizer.view];
//
//CGFloat angle = atan2(secondPoint.y - firstPoint.y, secondPoint.x - firstPoint.x);
