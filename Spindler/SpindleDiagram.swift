//
//  SpindleDiagram.swift
//  Spindler
//
//  Created by Scott Johnson on 5/23/16.
//  Copyright © 2016 Scott Johnson. All rights reserved.
//

import UIKit

let π = CGFloat(M_PI)

@IBDesignable
class SpindleDiagram: UIView {
    let engine = MathEngine.sharedInstance
    var maxRise: CGFloat = 400
    var postSpaceLabel = CGPoint(x: 15, y: 200)
    
    var rise: CGFloat = 30 {
        didSet {
            if rise >= 0 && rise <= maxRise  {
                //the view needs to be refreshed
                setNeedsDisplay()
            }
        }
    }
    
    var spindles: Int = 10 {
        didSet {
            if spindles >= 0 && spindles <= 30  {
                //the view needs to be refreshed
                setNeedsDisplay()
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
    
    
    override func drawRect(rect: CGRect) {
        let yOrigin = rect.maxY - 10
        let xOrigin:CGFloat = 10
        let maxX = rect.maxX - 10
        let maxY: CGFloat = 10
        let xRange = maxX - xOrigin
        let centerX = maxX/2
        var newY = yOrigin - rise * 3
        newY = newY > maxY ? newY: maxY
        let yOffset: CGFloat = 125
        let angle = abs(atan((yOrigin - newY) / xRange)) * 180 / π
        
        postSpaceLabel = CGPointMake( centerX, yOrigin - 125 - abs(tan(angle * π / 180)) * (xRange/2))
        NSLog(String(postSpaceLabel.x) + ", " + String(postSpaceLabel.y))
        maxRise = yOrigin - maxY
        
        do {
            let levelLine = UIBezierPath()
            levelLine.moveToPoint(CGPoint(x: xOrigin, y: yOrigin))
            levelLine.addLineToPoint(CGPoint(x: maxX, y: yOrigin))

            levelLine.closePath()
            levelLine.lineWidth = 2
                
            //If you want to stroke it with a red color
            UIColor.whiteColor().set()
            levelLine.stroke()
            //If you want to fill it as well
            levelLine.fill()
            
        }
        
        do {
            let slope = UIBezierPath()
            slope.moveToPoint(CGPoint(x: xOrigin, y: yOrigin))
            slope.addLineToPoint(CGPoint(x: maxX, y: newY))
            //        slope.closePath()
            slope.lineWidth = 5
            UIColor.whiteColor().set()
            slope.stroke()
            //If you want to fill it as well
            slope.fill()
        }
        
        //place the spindles on the graph
        if spindles > 0 {
            for spindle in 1...spindles {
                let picket = UIBezierPath()
                let run = maxX - 10
                let space = (run / CGFloat(spindles + 1)) * CGFloat(spindle)
                let ySpace = (yOrigin - newY) / CGFloat(spindles + 1) * CGFloat(spindle)
                
                
                picket.moveToPoint(CGPoint(x: xOrigin + space, y: yOrigin - ySpace))
                picket.addLineToPoint(CGPoint(x: xOrigin + space, y: yOrigin - ySpace - 80))
//                picket.closePath()
                picket.lineWidth = 7
                UIColor.brownColor().set()
                picket.stroke()
                //If you want to fill it as well
//                picket.fill()
            }
        }

        let leftTick = UIBezierPath()
        leftTick.moveToPoint(CGPoint(x: xOrigin, y: yOrigin - 10))
        leftTick.addLineToPoint(CGPoint(x: xOrigin, y: yOrigin - 150))
        leftTick.lineWidth = 1
        UIColor.whiteColor().set()
        leftTick.stroke()
        
        let rightTick = UIBezierPath()
        rightTick.moveToPoint(CGPoint(x: maxX, y: newY - 10))
        rightTick.addLineToPoint(CGPoint(x: maxX, y: newY - 140))
        rightTick.lineWidth = 1
        UIColor.whiteColor().set()
        rightTick.stroke()
        
        let leftMeasure = UIBezierPath()
        leftMeasure.moveToPoint(CGPoint(x: xOrigin, y: yOrigin - 125))
        leftMeasure.addLineToPoint(CGPoint(x: centerX - 20, y: yOrigin - abs(tan(angle * π / 180)) * (xRange/2 - 10) - 125))
        leftMeasure.lineWidth = 1
        UIColor.whiteColor().set()
        leftMeasure.stroke()
        
        
        let rightMeasure = UIBezierPath()
        rightMeasure.moveToPoint(CGPoint(x: centerX + 20, y: yOrigin - 125 - abs(tan(angle * π / 180)) * (xRange/2 + 10)))
        rightMeasure.addLineToPoint(CGPoint(x: maxX, y: newY - 125))
        rightMeasure.lineWidth = 1
        UIColor.whiteColor().set()
        rightMeasure.stroke()
    }
}
