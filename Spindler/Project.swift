//
//  Project.swift
//  Spindler
//
//  Created by Scott Johnson on 5/26/16.
//  Copyright © 2016 Scott Johnson. All rights reserved.
//

import Foundation

class Project: NSObject, NSCoding {
    
    var postSpacing = Measurement(cm: 456, mm: 3)
    var spindleWidth = Measurement(cm: 4, mm: 0)
    var onCenter = Measurement(feet: 0, inches: 3, fraction: "5/16")
    var between = Measurement(feet: 0, inches: 3, fraction: "13/16")
    var angle = 0.0
    var rise = Measurement()
    var run = Measurement(feet: 0, inches: 0, fraction: "0")
    var maxSpace = Measurement(cm: 10, mm: 0)
    var numSpaces = 19
    var numSpindles = 18
    
    override init() {}
    
    init(postSpacing: Measurement, spindleWidth: Measurement, onCenter: Measurement, between: Measurement, angle: Double, rise: Measurement, run: Measurement, maxSpace: Measurement, numSpaces: Int, numSpindles: Int) {
            self.postSpacing = postSpacing
            self.spindleWidth = spindleWidth
            self.onCenter = onCenter
            self.between = between
            self.angle = angle
            self.rise = rise
            self.run = run
            self.maxSpace = maxSpace
            self.numSpaces = numSpaces
            self.numSpindles = numSpindles
    }
    
    func getValue(sender: Int)->Measurement {
        switch sender {
        case 1: return postSpacing
        case 2: return spindleWidth
        case 3: return maxSpace
        case 6: return onCenter
        case 7: return between
        case 9: return rise
        case 10: return run
        default: return postSpacing
        }
    }
    
    required convenience init?(coder decoder: NSCoder) {
        let postSpacing = decoder.decodeObjectForKey("postSpacing") as? Measurement
        let spindleWidth = decoder.decodeObjectForKey("spindleWidth") as? Measurement
        let onCenter = decoder.decodeObjectForKey("onCenter") as? Measurement
        let between = decoder.decodeObjectForKey("between") as? Measurement
        let angle = decoder.decodeObjectForKey("angle") as? Double
        let rise = decoder.decodeObjectForKey("rise") as? Measurement
        let run = decoder.decodeObjectForKey("run") as? Measurement
        let maxSpace = decoder.decodeObjectForKey("maxSpace") as? Measurement
        let numSpaces = decoder.decodeObjectForKey("numSpaces") as? Int
        let numSpindles = decoder.decodeObjectForKey("numSpindles") as? Int
        
        self.init(
            postSpacing: postSpacing!,
            spindleWidth: spindleWidth!,
            onCenter: onCenter!,
            between: between!,
            angle: angle!,
            rise: rise!,
            run: run!,
            maxSpace: maxSpace!,
            numSpaces: numSpaces!,
            numSpindles: numSpindles!
        )
    }
    
    func encodeWithCoder(coder: NSCoder) {
//        coder.encodeDouble(self.postSpacing, forKey: "postSpacing")
//        coder.encodeDouble(self.spindleWidth, forKey: "spindleWidth")
//        coder.encodeDouble(self.onCenter, forKey: "onCenter")
//        coder.encodeDouble(self.between, forKey: "between")
//        coder.encodeDouble(self.angle, forKey: "angle")
//        coder.encodeDouble(self.rise, forKey: "rise")
//        coder.encodeDouble(self.run, forKey: "run")
//        coder.encodeDouble(self.maxSpace, forKey: "maxSpace")
//        coder.encodeInt(Int32(self.numSpaces), forKey: "numSpaces")
//        coder.encodeInt(Int32(self.numSpindles), forKey: "numSpindles")
    }
}