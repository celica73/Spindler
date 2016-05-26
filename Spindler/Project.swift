//
//  Project.swift
//  Spindler
//
//  Created by Scott Johnson on 5/26/16.
//  Copyright © 2016 Scott Johnson. All rights reserved.
//

import Foundation

class Project: NSObject, NSCoding {
    
    var postSpacing = 100.0
    var spindleWidth = 1.5
    var onCenter = 3.31
    var between = 3.81
    var angle = 0.0
    var rise = 0.0
    var run = 100.0
    var maxSpace = 4.0
    var numSpaces = 19
    var numSpindles = 18
    
    override init() {}
    
    init(postSpacing: Double, spindleWidth: Double, onCenter: Double, between: Double, angle: Double, rise: Double, run: Double, maxSpace: Double, numSpaces: Int, numSpindles: Int) {
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
    
    required convenience init?(coder decoder: NSCoder) {
        let postSpacing = decoder.decodeObjectForKey("postSpacing") as? Double
        let spindleWidth = decoder.decodeObjectForKey("spindleWidth") as? Double
        let onCenter = decoder.decodeObjectForKey("onCenter") as? Double
        let between = decoder.decodeObjectForKey("between") as? Double
        let angle = decoder.decodeObjectForKey("angle") as? Double
        let rise = decoder.decodeObjectForKey("rise") as? Double
        let run = decoder.decodeObjectForKey("run") as? Double
        let maxSpace = decoder.decodeObjectForKey("maxSpace") as? Double
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
        coder.encodeDouble(self.postSpacing, forKey: "postSpacing")
        coder.encodeDouble(self.spindleWidth, forKey: "spindleWidth")
        coder.encodeDouble(self.onCenter, forKey: "onCenter")
        coder.encodeDouble(self.between, forKey: "between")
        coder.encodeDouble(self.angle, forKey: "angle")
        coder.encodeDouble(self.rise, forKey: "rise")
        coder.encodeDouble(self.run, forKey: "run")
        coder.encodeDouble(self.maxSpace, forKey: "maxSpace")
        coder.encodeInt(Int32(self.numSpaces), forKey: "numSpaces")
        coder.encodeInt(Int32(self.numSpindles), forKey: "numSpindles")
    }
}