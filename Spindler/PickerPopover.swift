//
//  PickerPopover.swift
//  Spindler
//
//  Created by Scott Johnson on 8/22/16.
//  Copyright © 2016 Scott Johnson. All rights reserved.
//

import UIKit

class PickerPopover: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var feetPicker: UIPickerView!
    
    
    var feetData: [String] = []
    var inchData: [String] = []
    var fractionData: [String] = ["0","1/16","1/8","3/16","1/4","5/16","3/8","7/16","1/2","9/16","5/8","11/16","3/4","13/16","7/8","15/16"]
    var pickerData = [[String]]()
    
    var centimeters: [Int] = Array(0...2000)
    var millimeters:[Int] = Array(0...9)
    var metricData = [[Int]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0...50 {
            feetData.append(String(i))
        }
        for i in 0...50 {
            inchData.append(String(i))
        }
        pickerData.append(feetData)
        pickerData.append(inchData)
        pickerData.append(fractionData)
        
        feetPicker.dataSource = self
        feetPicker.delegate = self
        
        metricData.append(centimeters)
        metricData.append(millimeters)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            if component == 1 {
                titleLabel.textAlignment = NSTextAlignment.Center
            }
            titleLabel.text = String(metricData[component][row])
            return titleLabel
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateLabel()
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