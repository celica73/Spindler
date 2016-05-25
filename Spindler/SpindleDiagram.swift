//
//  SpindleDiagram.swift
//  Spindler
//
//  Created by Scott Johnson on 5/23/16.
//  Copyright © 2016 Scott Johnson. All rights reserved.
//

import UIKit

var maxRise: Double = 400
let π:Double = M_PI



@IBDesignable class SpindleDiagram: UIView {

    var rise: Double = 90 {
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
        let level = UIBezierPath()
        
        let yOrigin = Double(rect.maxY) - 20
        let xOrigin:Double = 10
        let maxX = Double(rect.maxX) - 10
        let maxY: Double = 20
        maxRise = yOrigin - maxY
            
        level.moveToPoint(CGPoint(x: xOrigin, y: yOrigin))
        level.addLineToPoint(CGPoint(x: maxX, y: yOrigin))
        
        level.closePath()
        level.lineWidth = 5
        
        //If you want to stroke it with a red color
        UIColor.whiteColor().set()
        level.stroke()
        //If you want to fill it as well 
        level.fill()
        
        let slope = UIBezierPath()
        
        slope.moveToPoint(CGPoint(x: xOrigin, y: yOrigin))
        var newY = yOrigin - rise * 3
        newY = newY > maxY ? newY: maxY
        slope.addLineToPoint(CGPoint(x: maxX, y: newY))
        slope.closePath()
        slope.lineWidth = 5
        UIColor.whiteColor().set()
        slope.stroke()
        //If you want to fill it as well
        slope.fill()
        
        //place the spindles on the graph
        if spindles > 0 {
            for spindle in 1...spindles {
                let picket = UIBezierPath()
                let run = maxX - 10
                let space = (run / Double(spindles + 1)) * Double(spindle)
                let ySpace = (yOrigin - newY) / Double(spindles + 1) * Double(spindle)
                
                
                picket.moveToPoint(CGPoint(x: xOrigin + space, y: yOrigin - ySpace))
                picket.addLineToPoint(CGPoint(x: xOrigin + space, y: yOrigin - ySpace - 80))
                picket.closePath()
                picket.lineWidth = 7
                UIColor.brownColor().set()
                picket.stroke()
                //If you want to fill it as well
                picket.fill()
            }
        }
        
//        let length = UIBezierPath()
//        
//        length.moveToPoint(CGPoint(x: 10, y: rect.maxY - 50))
//        length.addLineToPoint(CGPoint(x:rect.maxX - 10, y:rect.maxY - 50 - CGFloat(rise)))
//        
//        length.closePath()
//        length.lineWidth = 1
//        
//        //If you want to stroke it with a red color
//        UIColor.whiteColor().set()
//        length.stroke()
//        //If you want to fill it as well
//        length.fill()
    }
}
