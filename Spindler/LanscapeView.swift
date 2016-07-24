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
    @IBOutlet var stepAdjust: UIStepper!
    @IBOutlet var unitsSelector: UISwitch!
    @IBOutlet var slopeSelector: UISwitch!
    
    var metric = false
    var slope = false
    
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
        
        stepAdjust.hidden = true
        stepAdjust.layer.cornerRadius = 5;
        
//        swipeRec.addTarget(self, action: #selector(LanscapeView.swiper))
//        pictureView.addGestureRecognizer(swipeRec)
//        pictureView.userInteractionEnabled = true
//        pictureView.multipleTouchEnabled = true
        pictureView.rise = CGFloat(engine.getProject().rise.getRealMeasure())
//        pictureView.spindles = engine.getProject().numSpindles
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
        rise.hidden = !slope
        run.hidden = !slope
        angle.hidden = !slope
        updateValues()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateValues() {
        postSpacing.text = engine.getProject().postSpacing.asString(metric)
        spindleWidth.text = engine.getProject().spindleWidth.asString(metric)
        maxSpace.text = engine.getProject().maxSpace.asString(metric)
        spaces.text = String(engine.getProject().numSpaces)
        spindles.text = String(engine.getProject().numSpindles)
        onCenter.text = engine.getProject().onCenter.asString(metric)
        between.text = engine.getProject().between.asString(metric)
        angle.text = String(format: "%.0f deg.",engine.getProject().angle)
        rise.text = engine.getProject().rise.asString(metric)
        run.text = engine.getProject().run.asString(metric)
        if engine.getProject().maxSpace.getRealMeasure() < engine.getProject().between.getRealMeasure() {
            maxSpace.textColor = .redColor()
        } else {
            maxSpace.textColor = blueText
        }
        updateDiagram()
    }
    
    // Receive action
    func labelAction(gr:UITapGestureRecognizer) {
        let searchlbl = (gr.view as! UILabel) // Type cast it with the class for which you have added gesture
        
        if tapLabel != nil && tapLabel == searchlbl {
            tapLabel.textColor = blueText
            tapLabel = nil
            pickerView.hidden = true
            stepAdjust.hidden = true
        } else {
            if tapLabel != nil {
                tapLabel.textColor = blueText
                pickerView.hidden = true
                stepAdjust.hidden = true
            }
            tapLabel = searchlbl
            let labelFrame: CGRect = tapLabel.frame
            if tapLabel.tag != 4 && tapLabel.tag != 5 && tapLabel.tag != 8 {
                pickerView.center = CGPointMake(CGRectGetMidX(labelFrame),CGRectGetMaxY(labelFrame) + 60)
                tapLabel.textColor = .orangeColor()
                setPickerValues()
                pickerView.hidden = false
            } else {
                tapLabel.textColor = .orangeColor()
                stepAdjust.center = CGPointMake(CGRectGetMaxX(labelFrame) + 10,CGRectGetMidY(labelFrame))
                stepAdjust.hidden = false
                stepAdjust.value = engine.getValue(tapLabel.tag)
            }
        }
    }
    
    @IBAction func setStepper(sender: UIStepper) {
        engine.updateOperation(tapLabel.tag, newValue: stepAdjust.value)
        tapLabel.text = String(stepAdjust.value)
        updateDiagram()
        updateValues()
    }
    
    func setPickerValues() {
        let selection = engine.getProject().getValue(tapLabel.tag)
        
        if let feetIndex = pickerData[0].indexOf(String(selection.getFeet())) {
            feetPicker.selectRow(feetIndex, inComponent: 0, animated: false)
        }
        if let inchIndex = pickerData[1].indexOf(String(selection.getInches())) {
            feetPicker.selectRow(inchIndex, inComponent: 1, animated: false)
        }
        if let fractionIndex = pickerData[2].indexOf(selection.getFraction()) {
            feetPicker.selectRow(fractionIndex, inComponent: 2, animated: false)
        }
        
    }
    
//    var startLocation: CGPoint!
//    
//    @IBAction func swiper(sender: UIPanGestureRecognizer) {
//        var changeValue:Double
//        var velocity:CGPoint
//        var moveFactor: Double = 1
//        if tapLabel != nil {
//            changeValue = engine.getValue(tapLabel.tag)
//        } else {
//            return
//        }
//        if tapLabel.tag == 4 || tapLabel.tag == 5 {
//            moveFactor = 5
//        }
//        if (sender.state == UIGestureRecognizerState.Began) {
//            startLocation = sender.locationInView(self.view)
//        } else if (sender.state == UIGestureRecognizerState.Changed) {
//            let stopLocation: CGPoint = sender.locationInView(self.view)
//            velocity = sender.velocityInView(self.view)
//            let dx: CGFloat = stopLocation.x - startLocation.x
//            let dy: CGFloat = stopLocation.y - startLocation.y
//            let direction = dx*dx > dy*dy ? dx : dy
//            var distance: CGFloat = sqrt(dx*dx + dy*dy)
//            if (direction == dx && dx < 0) || (direction == dy && dy > 0) {
//                distance = -distance
//            }
//            let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
//            let slideMult = magnitude / 10
//            let factor = (slideMult > 4 ? 0.2 : 0.01) * moveFactor
//            var newValue = Double(changeValue) + Double(distance) * factor
//            newValue = newValue <= 0 ? 0 : newValue
//            engine.updateOperation(tapLabel.tag, newValue: newValue)
//            updateValues()
//            pictureView.rise = CGFloat(engine.getProject().rise.getRealMeasure())
////            pictureView.spindles = engine.getProject().numSpindles
//            startLocation = stopLocation
//        }
//    }
    
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
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        if let titleLabel = view as? UILabel {
            titleLabel.text = "Your Text"
            return titleLabel
        }else{
            let titleLabel = UILabel()
            titleLabel.font = UIFont.systemFontOfSize(14)//Font you want here
            titleLabel.textAlignment = NSTextAlignment.Center
            titleLabel.text = pickerData[component][row]
            return titleLabel
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateLabel()
    }
    
    @IBAction func slopeChanger(sender: UISwitch) {
        slope = !slope
        if !slope {
            engine.getProject().rise.update(0)
            engine.updateOperation(rise.tag, newValue: engine.getProject().rise)
            pictureView.rise = 0
        }
        rise.hidden = !slope
        angle.hidden = !slope
        run.hidden = !slope
        updateValues()
    }
    
    @IBAction func unitsChange(sender: UISwitch) {
        metric = !metric
        updateValues()
    }
    func updateLabel(){
        let feet = pickerData[0][feetPicker.selectedRowInComponent(0)]
        let inches = pickerData[1][feetPicker.selectedRowInComponent(1)]
        let fraction = pickerData[2][feetPicker.selectedRowInComponent(2)]
        let newMeasurement = Measurement(feet: Int(feet)!, inches: Int(inches)!, fraction: fraction)
        engine.getProject().getValue(tapLabel.tag).update(newMeasurement)
        tapLabel.text = engine.getProject().getValue(tapLabel.tag).asString(metric)
        engine.updateOperation(tapLabel.tag, newValue: newMeasurement)
        updateValues()
    }
    
    func updateDiagram() {
        pictureView.rise = CGFloat(engine.getProject().rise.getRealMeasure())
        pictureView.spindles = engine.getProject().numSpindles
    }
}
