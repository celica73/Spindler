//
//  ViewController.swift
//  Spindler
//
//  Created by Scott Johnson on 5/21/16.
//  Copyright © 2016 Scott Johnson. All rights reserved.
//

import UIKit

class LanscapeView: UIViewController, UIGestureRecognizerDelegate, UIPickerViewDataSource,UIPickerViewDelegate {
    
    var engine = MathEngine.sharedInstance
    
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
    
    @IBOutlet var feetPicker: UIPickerView!
    
    var feetData: [String] = []
    var inchData: [String] = []
    var fractionData: [String] = ["0","1/16","1/8","3/16","1/4","5/16","3/8","7/16","1/2","9/16","5/8","11/16","3/4","13/16","7/8","15/16"]
    var pickerData = [[String]]()
    @IBOutlet var pictureView: SpindleDiagram!
    @IBOutlet var pickerView: NumberSelector!
    
    @IBOutlet var swipeGesture: UIPanGestureRecognizer!
    
    var tapLabel: UILabel!
    var labelColor: UIColor!
    
    let swipeRec = UIPanGestureRecognizer()
    let blueText = UIColor( red: 212/255, green: 207/255, blue: 255/255, alpha: 1.0 )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        for i in 0...50 {
            feetData.append(String(i))
        }
        for i in 0...50 {
            inchData.append(String(i))
        }
        pickerData.append(feetData)
        pickerData.append(inchData)
        pickerData.append(fractionData)
        pickerView.hidden = true
        feetPicker.dataSource = self
        feetPicker.delegate = self
        
        swipeRec.addTarget(self, action: #selector(LanscapeView.swiper))
        pictureView.addGestureRecognizer(swipeRec)
        pictureView.userInteractionEnabled = true
        pictureView.multipleTouchEnabled = true
        pictureView.rise = CGFloat(engine.getProject().rise)
        pictureView.spindles = engine.getProject().numSpindles
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
        for i in 0...10 {
            if let taggedLabel = self.view.viewWithTag(i) as? UILabel {
                taggedLabel.userInteractionEnabled = true
                let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LanscapeView.labelAction))
                taggedLabel.addGestureRecognizer(tap)
                tap.delegate = self // Remember to extend your class with UIGestureRecognizerDelegate
            }
        }
        updateValues()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateValues() {
        postSpacing.text = "0\' " + asFraction(engine.getProject().postSpacing) + "\" 0"
        spindleWidth.text = asFraction(engine.getProject().spindleWidth) + "\""
        maxSpace.text = asFraction(engine.getProject().maxSpace) + "\""
        spaces.text = String(engine.getProject().numSpaces)
        spindles.text = String(engine.getProject().numSpindles)
        onCenter.text = asFraction(engine.getProject().onCenter) + "\""
        between.text = asFraction(engine.getProject().between) + "\""
        angle.text = NSString(format: "%.0f deg.",engine.getProject().angle) as String
        rise.text = asFraction(engine.getProject().rise) + "\""
        run.text = asFraction(engine.getProject().run) + "\""
        if engine.getProject().maxSpace < engine.getProject().between {
            maxSpace.textColor = .redColor()
        } else {
            maxSpace.textColor = blueText
        }
    }
    
    // Receive action
    func labelAction(gr:UITapGestureRecognizer) {
        let searchlbl:UILabel = (gr.view as! UILabel) // Type cast it with the class for which you have added gesture
        
        if tapLabel != nil && tapLabel == searchlbl {
            tapLabel.textColor = blueText
            tapLabel = nil
            pickerView.hidden = true
        } else {
            if tapLabel != nil {
                tapLabel.textColor = blueText
                pickerView.hidden = true
            }
            tapLabel = searchlbl
            let labelFrame: CGRect = tapLabel.frame
            pickerView.center = CGPointMake(CGRectGetMaxX(labelFrame) + 90,CGRectGetMidY(labelFrame) + 8)
            tapLabel.textColor = .orangeColor()
            setPickerValues()
            pickerView.hidden = false
        }
    }
    
    func setPickerValues() {
        let currentArray = tapLabel.text!.characters.split{$0 == " "}.map(String.init)
        let feet = currentArray[0].characters.split{$0 == "\'"}.map(String.init)[0]
        let inches = currentArray[1].characters.split{$0 == "\""}.map(String.init)[0]
        let fraction = currentArray[2]
        
        if let feetIndex = pickerData[0].indexOf(feet) {
            feetPicker.selectRow(0, inComponent: feetIndex, animated: false)
        }
        if let inchIndex = pickerData[1].indexOf(inches) {
            feetPicker.selectRow(1, inComponent: inchIndex, animated: false)
        }
        if let fractionIndex = pickerData[2].indexOf(fraction) {
            feetPicker.selectRow(2, inComponent: fractionIndex, animated: false)
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
    
    var startLocation: CGPoint!
    
    @IBAction func swiper(sender: UIPanGestureRecognizer) {
        var changeValue:Double
        var velocity:CGPoint
        var moveFactor: Double = 1
        if tapLabel != nil {
            changeValue = engine.getValue(tapLabel.tag)
        } else {
            return
        }
        if tapLabel.tag == 4 || tapLabel.tag == 5 {
            moveFactor = 5
        }
        if (sender.state == UIGestureRecognizerState.Began) {
            startLocation = sender.locationInView(self.view)
        } else if (sender.state == UIGestureRecognizerState.Changed) {
            let stopLocation: CGPoint = sender.locationInView(self.view)
            velocity = sender.velocityInView(self.view)
            let dx: CGFloat = stopLocation.x - startLocation.x
            let dy: CGFloat = stopLocation.y - startLocation.y
            let direction = dx*dx > dy*dy ? dx : dy
            var distance: CGFloat = sqrt(dx*dx + dy*dy)
            if (direction == dx && dx < 0) || (direction == dy && dy > 0) {
                distance = -distance
            }
            let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
            let slideMult = magnitude / 10
            let factor = (slideMult > 4 ? 0.2 : 0.01) * moveFactor
            var newValue = Double(changeValue) + Double(distance) * factor
            newValue = newValue <= 0 ? 0 : newValue
            engine.updateOperation(tapLabel.tag, newValue: newValue)
            updateValues()
            pictureView.rise = CGFloat(engine.getProject().rise)
            pictureView.spindles = engine.getProject().numSpindles
            startLocation = stopLocation
        }
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return pickerData.count
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return pickerData[component][row] + "\'"
        } else if component == 1 {
            return pickerData[component][row] + "\""
        } else {
            return pickerData[component][row]
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateLabel()
    }
    
    func updateLabel(){
        let feet = pickerData[0][feetPicker.selectedRowInComponent(0)]
        let inches = pickerData[1][feetPicker.selectedRowInComponent(1)]
        let fraction = pickerData[2][feetPicker.selectedRowInComponent(2)]
        tapLabel.text = feet + "\' " + inches + "\" " + fraction

    }
}
