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
        var newY = yOrigin - rise * 3
        newY = newY > maxY ? newY: maxY
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
                picket.lineWidth = 7
                UIColor.brownColor().set()
                picket.stroke()
            }
        }
    }
}
