//
//  Measurement.swift
//  Spindler
//
//  Created by Scott Johnson on 7/22/16.
//  Copyright © 2016 Scott Johnson. All rights reserved.
//

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
        self.cm = getMetric()
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
    func getRealMeasure()->Double{
        let output = feet * 12 + inches
        var decimal: Double = 0
        if fraction.containsString("/"){
            let frac = fraction.characters.split{$0 == "/"}.map(String.init)
            decimal = Double(frac[0])!/Double(frac[1])!
        }
//        print(output)
        return Double(output) + decimal
    }
    
    func getMetric()->Double{
        return getRealMeasure() * 2.54
    }
    func update(value: Measurement){
        self.feet = value.feet
        self.inches = value.inches
        self.fraction = value.fraction
        self.cm = getMetric()
    }
    
    func update(measure: Double){
        var newValue = measure/12
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
        self.cm = getMetric()
    }
    
    func asString(metric: Bool)->String{
        if !metric {
            if feet != 0 {
                return String(format: "%d' %d",feet, inches) + (fraction != "0" ? " " + fraction  : "") + "\""
            } else if fraction != "0" {
                return String(format: "%d ", inches) + fraction + "\""
            } else {
                return String(format: "%d\"", inches)
            }
        } else {
            return String(format: "%.1f cm", getMetric())
        }
    }
}
