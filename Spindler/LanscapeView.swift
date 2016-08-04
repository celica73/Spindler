//
//  ViewController.swift
//  Spindler
//
//  Created by Scott Johnson on 5/21/16.
//  Copyright © 2016 Scott Johnson. All rights reserved.
//

import UIKit

class LanscapeView: UIViewController, UIGestureRecognizerDelegate, UIPickerViewDataSource,UIPickerViewDelegate {
    
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
    
    @IBOutlet var feetPicker: UIPickerView!
    @IBOutlet var unitsSelector: UISwitch!
    @IBOutlet var slopeSelector: UISwitch!
    
    var metric = false
    var slope = false
    var landscape = false
    var stepAdjust = UIStepper(frame:CGRectMake(110, 250, 0, 0))
    
    
    
    var feetData: [String] = []
    var inchData: [String] = []
    var fractionData: [String] = ["0","1/16","1/8","3/16","1/4","5/16","3/8","7/16","1/2","9/16","5/8","11/16","3/4","13/16","7/8","15/16"]
    var pickerData = [[String]]()
    
    var centimeters: [Int] = Array(0...2000)
    var millimeters:[Int] = Array(0...9)
    var metricData = [[Int]]()
    
    
    @IBOutlet var pictureView: SpindleDiagram!
    @IBOutlet var pickerView: NumberSelector!
    
    var tapLabel: UILabel!
    var labelColor: UIColor!

    override func viewDidLoad() {
        super.viewDidLoad()
        stepAdjust.wraps = true
        stepAdjust.autorepeat = true
        stepAdjust.maximumValue = 100
        stepAdjust.backgroundColor = UIColor.lightGrayColor()
        stepAdjust.addTarget(self, action: #selector(LanscapeView.setStepper), forControlEvents: .ValueChanged)
        self.view.addSubview(stepAdjust)
        stepAdjust.hidden = true
        stepAdjust.layer.cornerRadius = 5;
        
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
        
        metricData.append(centimeters)
        metricData.append(millimeters)
        
        pictureView.rise = CGFloat(engine.getProject().rise.getRealMeasure())
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
                let tap = UITapGestureRecognizer(target: self, action: #selector(LanscapeView.labelAction))
                taggedLabel.addGestureRecognizer(tap)
                tap.delegate = self // Remember to extend your class with UIGestureRecognizerDelegate
                taggedLabel.layer.cornerRadius = 5.0
                taggedLabel.layer.masksToBounds = true
            }
        }
        pictureView.userInteractionEnabled = true
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(LanscapeView.labelFinish))
        pictureView.addGestureRecognizer(tap2)
        tap2.delegate = self
        
        rise.hidden = !slope
        run.hidden = !slope
        angle.hidden = !slope
    }
    
    override func viewDidAppear(animated: Bool) {
        updateValues()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        landscape = !landscape
        pictureView.landscapeView = landscape
        if tapLabel != nil {
            stepAdjust.center = CGPointMake(CGRectGetMaxX(tapLabel.frame) + stepAdjust.frame.width/2,CGRectGetMidY(tapLabel.frame))
        }
        let delay = 0.025
        NSTimer.scheduledTimerWithTimeInterval(delay, target: self, selector: #selector(updateValues), userInfo: nil, repeats: false)
        
    }
    
    func updateValues() {
        postSpacing.attributedText = engine.getProject().postSpacing.asString(metric)
        spindleWidth.attributedText = engine.getProject().spindleWidth.asString(metric)
        maxSpace.attributedText = engine.getProject().maxSpace.asString(metric)
        spaces.text = " " + String(engine.getProject().numSpaces) + " "
        spindles.text = " " + String(engine.getProject().numSpindles) + " "
        onCenter.attributedText = engine.getProject().onCenter.asString(metric)
        between.attributedText = engine.getProject().between.asString(metric)
        angle.text = String(format: " %.0f\u{00B0} ",engine.getProject().angle)
        rise.attributedText = engine.getProject().rise.asString(metric)
        run.attributedText = engine.getProject().run.asString(metric)
        rise.sizeToFit()
        postSpacing.sizeToFit()
        spindleWidth.sizeToFit()
        between.sizeToFit()
        angle.sizeToFit()
        run.sizeToFit()
        if engine.getProject().maxSpace.getRealMeasure() < engine.getProject().between.getRealMeasure() {
            maxSpace.textColor = .redColor()
        } else {
            maxSpace.textColor = .blackColor()
        }
        pictureView.rise = CGFloat(engine.getProject().rise.getRealMeasure())
        pictureView.spindles = engine.getProject().numSpindles
        updatePositions()
    }
    
    func updatePositions() {
        let center = CGPointMake(view.frame.midX, view.frame.midY)
        let viewCenter = CGPointMake(pictureView.frame.midX, pictureView.frame.midY)
        let xOffset = center.x - viewCenter.x
        let yOffset = center.y - viewCenter.y
        rise.center = pictureView.pointShift(pictureView.riseLocation, xshift: xOffset - rise.frame.width/2, yshift: yOffset)
        run.center = pictureView.pointShift(pictureView.runLocation, xshift: xOffset, yshift: yOffset)
        postSpacing.center = pictureView.pointShift(pictureView.slopeLocation, xshift: xOffset, yshift: yOffset)
        between.center = pictureView.pointShift(pictureView.spaceLocation, xshift: xOffset, yshift: yOffset)
        spindleWidth.center = pictureView.pointShift(pictureView.picketLocation, xshift: xOffset, yshift: yOffset)
        angle.center = pictureView.pointShift(pictureView.angleLocation, xshift: xOffset, yshift: yOffset)
    }
    
    // Receive action
    func labelAction(gr:UITapGestureRecognizer) {
        let searchlbl = (gr.view as! UILabel) // Type cast it with the class for which you have added gesture
        feetPicker.reloadAllComponents()
//        pictureView.addSubview(feetPicker)
        
        if tapLabel != nil && tapLabel == searchlbl {
            tapLabel.textColor = .blackColor()
            tapLabel = nil
            pickerView.hidden = true
            stepAdjust.hidden = true
        } else {
            if tapLabel != nil {
                tapLabel.textColor = .blackColor()
                pickerView.hidden = true
                stepAdjust.hidden = true
            }
            tapLabel = searchlbl
            let labelFrame: CGRect = tapLabel.frame
            if tapLabel.tag != 4 && tapLabel.tag != 5 && tapLabel.tag != 8 {
                pickerView.center = CGPointMake(self.view.frame.midX, self.view.frame.midY)
                tapLabel.textColor = .orangeColor()
                setPickerValues()
                pickerView.hidden = false
            } else {
                tapLabel.textColor = .orangeColor()
                stepAdjust.center = CGPointMake(CGRectGetMaxX(labelFrame) + stepAdjust.frame.width/2,CGRectGetMidY(labelFrame))
                stepAdjust.hidden = false
                stepAdjust.value = engine.getValue(tapLabel.tag)
            }
        }
    }
    
    func labelFinish(gr:UITapGestureRecognizer) {
        if tapLabel != nil {
            tapLabel.textColor = .blackColor()
            tapLabel = nil
            pickerView.hidden = true
            stepAdjust.hidden = true
        }
    }
    
    @IBAction func setStepper(sender: UIStepper) {
        engine.updateOperation(tapLabel.tag, newValue: stepAdjust.value)
        between.hidden = !Bool(engine.getProject().numSpindles)
        spindleWidth.hidden = !Bool(engine.getProject().numSpindles)
        onCenter.hidden = !Bool(engine.getProject().numSpindles)
        let delay = 0.025
        NSTimer.scheduledTimerWithTimeInterval(delay, target: self, selector: #selector(updateValues), userInfo: nil, repeats: false)
        updateValues()
    }

    func setPickerValues() {
        let selection = engine.getProject().getValue(tapLabel.tag)
        
        if !metric {
            if let feetIndex = pickerData[0].indexOf(String(selection.getFeet())) {
                feetPicker.selectRow(feetIndex, inComponent: 0, animated: false)
            }
            if let inchIndex = pickerData[1].indexOf(String(selection.getInches())) {
                feetPicker.selectRow(inchIndex, inComponent: 1, animated: false)
            }
            if let fractionIndex = pickerData[2].indexOf(selection.getFraction()) {
                feetPicker.selectRow(fractionIndex, inComponent: 2, animated: false)
            }
        } else {
            if let cmIndex = metricData[0].indexOf(Int(selection.cm)) {
                feetPicker.selectRow(cmIndex, inComponent: 0, animated: false)
            }
            if let mmIndex = metricData[1].indexOf(Int((selection.cm * 10)) % 10) {
                feetPicker.selectRow(mmIndex, inComponent: 1, animated: false)
            }
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        if !metric {
            return pickerData.count
        } else {
            return metricData.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if !metric {
            return pickerData[component].count
        } else {
            return metricData[component].count
        }
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFontOfSize(14)//Font you want here
        titleLabel.textAlignment = NSTextAlignment.Right
        if !metric {
            if component == 0 {
                titleLabel.text = pickerData[component][row] + "\'"
            } else if component == 1 {
                titleLabel.text = pickerData[component][row] + "\""
            } else if component == 2 {
                titleLabel.text = pickerData[component][row] + "\""
                titleLabel.font = UIFont.systemFontOfSize(10)
            }
            return titleLabel
        } else {
            titleLabel.text = String(metricData[component][row])
            return titleLabel
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateLabel()
    }
    
    @IBAction func slopeChanger(sender: UISwitch) {
        slope = !slope
        pictureView.slopeChange = slope

        if !slope {
            engine.getProject().rise.update(0)
            engine.updateOperation(rise.tag, newValue: engine.getProject().rise)
            pictureView.rise = 0
        }
        rise.hidden = !slope
        angle.hidden = !slope
        run.hidden = !slope
        let delay = 0.025
        NSTimer.scheduledTimerWithTimeInterval(delay, target: self, selector: #selector(updateValues), userInfo: nil, repeats: false)
    }
    
    @IBAction func unitsChange(sender: UISwitch) {
        metric = !metric
        updateValues()
    }
    
    func updateLabel(){
        var newMeasurement: Measurement
        if !metric {
            let feet = pickerData[0][feetPicker.selectedRowInComponent(0)]
            let inches = pickerData[1][feetPicker.selectedRowInComponent(1)]
            let fraction = pickerData[2][feetPicker.selectedRowInComponent(2)]
            newMeasurement = Measurement(feet: Int(feet)!, inches: Int(inches)!, fraction: fraction)
        } else {
            let cm = metricData[0][feetPicker.selectedRowInComponent(0)]
            let mm = metricData[1][feetPicker.selectedRowInComponent(1)]
            newMeasurement = Measurement(cm: cm, mm: mm)
        }
        engine.getProject().getValue(tapLabel.tag).update(newMeasurement)
        tapLabel.attributedText = engine.getProject().getValue(tapLabel.tag).asString(metric)
        engine.updateOperation(tapLabel.tag, newValue: newMeasurement)
        updateValues()
    }
}
