//
//  Measurement.swift
//  Spindler
//
//  Created by Scott Johnson on 7/22/16.
//  Copyright © 2016 Scott Johnson. All rights reserved.
//
import UIKit
import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(self * divisor) / divisor
    }
}

class Measurement {
    var feet: Int
    var inches: Int
    var fraction: String
    var cm: Double
    
    init() {
        feet = 0
        inches = 0
        fraction = "0"
        cm = 0
    }
    
    init(feet: Int, inches: Int, fraction: String) {
        self.feet = feet
        self.inches = inches
        self.fraction = fraction
        self.cm = 0
        self.cm = setMetric()
        update(self)
    }
    
    init(cm: Int, mm: Int) {
        self.cm = Double(cm) + Double(mm)/10
        self.feet = 0
        self.inches = 0
        self.fraction = "0"
        if self.cm != 0 {
            update(self.cm, metricInput: true)
        }
    }
    
    func setMetric() -> Double {
        let output = feet * 12 + inches
        var decimal: Double = 0
        if fraction.containsString("/"){
            let frac = fraction.characters.split{$0 == "/"}.map(String.init)
            decimal = Double(frac[0])!/Double(frac[1])!
        }
        return (Double(output) + decimal) * 2.54
    }
    
    func getFeet()->Int{
        return self.feet
    }
    func getInches()->Int{
        return self.inches
    }
    func getFraction()->String{
        return self.fraction
    }
    func getInchMeasure()->Double{
        return self.cm / 2.54
    }
    
    func getMetricMeasure()->Double{
        return self.cm
    }
    
    func update(value: Measurement){
        if value.cm != self.cm {
            self.cm = value.cm
        }
        update(self.cm, metricInput: true)
    }
    
    func update(measure: Double, metricInput: Bool){
        var english: Double
   
        if metricInput && measure != 0 {
            self.cm = measure
            english = measure / 2.54
        } else {
            english = measure
            self.cm = measure * 2.54
        }
        var newValue = english/12
        self.feet = Int(newValue)
        newValue -= Double(self.feet)
        self.inches = Int(newValue * 12)
        newValue = newValue * 12 - Double(self.inches)
        var numerator = Int((newValue * 16).roundToPlaces(0))
        var denominator: Int = 16
        if numerator == 16 {
            self.inches += 1
            self.fraction = "0"
        } else if numerator > 0 {
            while numerator != 0 && numerator % 2 == 0 {
                numerator /= 2
                denominator /= 2
            }
            self.fraction = String(numerator) + "/" + String(denominator)
        } else {
            self.fraction = "0"
        }
        print(String(format: "feet: %d, inches: %d, fraction %s, cm: %f", feet, inches, fraction, cm))

    }
    
    func asString(metric: Bool)->NSMutableAttributedString{
        let fracStr = NSMutableAttributedString(
            string: fraction,
            attributes: [NSFontAttributeName:UIFont.systemFontOfSize(14.0)])
        var output: String = ""
        
        if !metric {
            if feet != 0 {
                output += String(format: " %d' %d",feet, inches) + (fraction != "0" ? "": "\" ")
            } else if fraction != "0" {
                output += String(format: " %d", inches) //+ fraction + "\""
            } else {
                return NSMutableAttributedString(string: String(format: " %d\" ", inches))
            }
        } else {
            return NSMutableAttributedString(string: String(format: " %.1f cm ", getMetricMeasure()))
        }
        if fraction != "0" {
            output += " "
            let newOutput = NSMutableAttributedString(string: output)
            newOutput.appendAttributedString(fracStr)
            newOutput.appendAttributedString(NSAttributedString(string: "\" "))
            return newOutput
        }
        return NSMutableAttributedString(string: output)
    }
}
