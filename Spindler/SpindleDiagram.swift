//
//  SpindleDiagram.swift
//  Spindler
//
//  Created by Scott Johnson on 5/23/16.
//  Copyright © 2016 Scott Johnson. All rights reserved.
//

import UIKit

let π = CGFloat(M_PI)
var maxRise: CGFloat = 400
var angle: CGFloat = 30

@IBDesignable
class SpindleDiagram: UIView {
    var slopeLocation = CGPointMake(0, 0)
    var riseLocation = CGPointMake(0, 0)
    var spaceLocation = CGPointMake(0, 0)
    var picketLocation = CGPointMake(0, 0)
    var angleLocation = CGPointMake(0, 0)
    var runLocation = CGPointMake(0, 0)
    
    var rise: CGFloat = 30 {
        didSet {
            if rise >= 0 && rise <= maxRise  {
                //the view needs to be refreshed
                setNeedsDisplay()
            }
        }
    }
    
    var spindles: Int = 2 {
        didSet {
            if spindles > 0 && spindles <= 3  {
                //the view needs to be refreshed
                setNeedsDisplay()
            }
        }
    }
    
    var slopeChange = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
    
    
    override func drawRect(rect: CGRect) {
        let yOrigin = rect.maxY - 30 //max Y is screen bottom
        let xOrigin:CGFloat = 10
        let maxX = rect.maxX - 30
        rise = (slopeChange ? 90 : 0)
        let maxY: CGFloat = 10 //top of screen
        var newY = yOrigin - rise
        newY = newY > maxY ? newY: maxY
        maxRise = yOrigin - maxY
        let run = maxX - 10
        angle = atan(rise / run) * 180 / π
        let picketHeight: CGFloat = 80
        
        slopeLocation = CGPoint(x: (maxX - xOrigin)/2 + 50, y: rect.maxY - picketHeight - 80)
        runLocation = CGPoint(x: (maxX - xOrigin)/2 + 50, y: rect.maxY)
        riseLocation = CGPoint(x: maxX, y: yOrigin - (rise/2))
        
        let slope = addLine(CGPoint(x: xOrigin, y: yOrigin), finish: CGPoint(x: maxX, y: newY))
        slope.lineWidth = 5
        UIColor.brownColor().set()
        slope.stroke()
        
        let leftPost = UIBezierPath()
        leftPost.moveToPoint(CGPoint(x: xOrigin, y: yOrigin))
        leftPost.addLineToPoint(CGPoint(x: xOrigin + 10, y: yOrigin))
        leftPost.addLineToPoint(CGPoint(x: xOrigin + 10, y: yOrigin - picketHeight))
        leftPost.addLineToPoint(CGPoint(x: xOrigin, y: yOrigin - picketHeight))
        leftPost.closePath()
//        UIColor(patternImage: UIImage(named: "pattern.png")!).setFill()
        leftPost.fill()
        leftPost.stroke()
        
        let rightPost = UIBezierPath()
        rightPost.moveToPoint(CGPoint(x: maxX, y: newY))
        rightPost.addLineToPoint(CGPoint(x: run, y: newY))
        rightPost.addLineToPoint(CGPoint(x: run, y: newY - picketHeight))
        rightPost.addLineToPoint(CGPoint(x: run, y: newY - picketHeight))
        rightPost.addLineToPoint(CGPoint(x: maxX, y: newY - picketHeight))
        rightPost.closePath()
        rightPost.fill()
        rightPost.stroke()
        
        var spindle1Location = CGPointMake(xOrigin, yOrigin)
        var spindle2Location = CGPointMake(xOrigin, yOrigin)
//        var spindle3Location = CGPointMake(xOrigin, yOrigin)
        let picketWidth: CGFloat = 7
        
        let numSpindles = (spindles < 3 ? spindles : 2)
        //place the spindles on the graph
        if spindles > 0 {
            for spindle in 1...numSpindles {
                let space = (run / CGFloat(numSpindles + 1)) * CGFloat(spindle)
                let ySpace = (yOrigin - newY) / CGFloat(numSpindles + 1) * CGFloat(spindle)
                
                let spindleTop: CGPoint = CGPoint(x: xOrigin + space, y: yOrigin - ySpace - picketHeight)
                let picket = addLine(CGPoint(x: xOrigin + space, y: yOrigin - ySpace),
                                     finish: spindleTop)
                picket.lineWidth = picketWidth
                //            UIColor.brownColor().set()
                picket.stroke()
                if spindle == 1 {
                    spindle1Location = spindleTop
                } else if spindle == 2 {
                    spindle2Location = spindleTop
                }
//                else if spindle == 3 {
//                    spindle3Location = spindleTop
//                }
            }
        }
        
        /*******************************/
        /* post space ticks begin here */
        /*******************************/
        var ySpace = (yOrigin - newY)
        
        let postSpaceHeight = yOrigin - picketHeight - 45
        let postHashHeight = yOrigin - picketHeight - 55

        let lengthLine = addLine(CGPoint(x: xOrigin + 10, y: postSpaceHeight),
                                  finish: CGPoint(x: run, y: postSpaceHeight - ySpace))
        UIColor.whiteColor().set()
        lengthLine.stroke()
        addArrow(CGPoint(x: xOrigin + 10, y: postSpaceHeight), angle: angle)
        addArrow(CGPoint(x: run, y: postSpaceHeight - ySpace), angle: angle)
        
        let lengthHash1 = addLine(CGPoint(x: xOrigin + 10, y: yOrigin - picketHeight - 2),
                                  finish: CGPoint(x: xOrigin + 10, y: postHashHeight))
        lengthHash1.stroke()

        let lengthHash2 = addLine(CGPoint(x: run, y: newY - picketHeight - 2),
                                  finish: CGPoint(x: run, y: newY - picketHeight - 55))
        lengthHash2.stroke()
        /**************************/
        /* space ticks begin here */
        /**************************/
        if spindles > 1 {
            var midXOffset = (spindle2Location.x - spindle1Location.x)/2
            ySpace = (((spindle1Location.x + midXOffset - 10) - (xOrigin)) / (maxX - xOrigin)) * (yOrigin - newY)
            
            let spaceLength = addLine(pointShift(spindle1Location, xshift: picketWidth/2, yshift: -25),
                                     finish: pointShift(spindle2Location, xshift: -picketWidth/2, yshift: -25))
            spaceLength.stroke()
            addArrow(pointShift(spindle1Location, xshift: picketWidth/2, yshift: -25), angle: angle)
            addArrow(pointShift(spindle2Location, xshift: -picketWidth/2, yshift: -25), angle: angle)
            
            let spaceHash1 = addLine(pointShift(spindle1Location, xshift: 3, yshift: -2),
                                     finish: pointShift(spindle1Location, xshift: 3, yshift: -35))
            spaceHash1.stroke()
            
            let spaceHash2 = addLine(pointShift(spindle2Location, xshift: -3, yshift: -2),
                                     finish: pointShift(spindle2Location, xshift: -3, yshift: -35))
            spaceHash2.stroke()
            spaceLocation = CGPoint(x: spindle1Location.x + midXOffset + 40 , y: yOrigin - picketHeight - 10)
            
//            if spindles > 2 {
//                midXOffset = spindle3Location.x
//                
//                ySpace = (((spindle3Location.x - 30 - picketWidth/2) - (xOrigin)) / (maxX - xOrigin)) * (yOrigin - newY)
//                
//                picketLocation = CGPoint(x: spindle3Location.x - 30 , y: yOrigin - ySpace - picketHeight/2)
//                
//                let spindleTick1 = addLine(pointShift(spindle3Location, xshift: -picketWidth/2, yshift: picketHeight/2), finish: CGPoint(x: spindle3Location.x - 30, y: yOrigin - ySpace - picketHeight/2))
//                spindleTick1.stroke()
//                
//                ySpace = (((spindle3Location.x + 30 + picketWidth/2) - (xOrigin)) / (maxX - xOrigin)) * (yOrigin - newY)
//                
//                let spindleTick2 = addLine(pointShift(spindle3Location, xshift: picketWidth/2, yshift: picketHeight/2 - tan(angle * π / 180) * picketWidth/2 - 1), finish: CGPoint(x: spindle3Location.x + 30, y: yOrigin - ySpace - picketHeight/2 - 1))
//                spindleTick2.stroke()
//                
//                addArrow(pointShift(spindle3Location, xshift: picketWidth/2, yshift: picketHeight/2 - tan(angle * π / 180) * picketWidth/2 - 1), angle: angle)
//                addArrow(pointShift(spindle3Location, xshift: -picketWidth/2, yshift: picketHeight/2), angle: angle)
//                
//            } else
            
            if spindles >= 2 {
                midXOffset = spindle2Location.x
                
                ySpace = (((spindle2Location.x - 30 - picketWidth/2) - (xOrigin)) / (maxX - xOrigin)) * (yOrigin - newY)
                
                picketLocation = CGPoint(x: spindle2Location.x - 30 , y: yOrigin - ySpace - picketHeight/2)
                
                let spindleTick1 = addLine(pointShift(spindle2Location, xshift: -picketWidth/2, yshift: picketHeight/2), finish: CGPoint(x: spindle2Location.x - 30, y: yOrigin - ySpace - picketHeight/2))
                spindleTick1.stroke()
                
                ySpace = (((spindle2Location.x + 30 + picketWidth/2) - (xOrigin)) / (maxX - xOrigin)) * (yOrigin - newY)
                
                let spindleTick2 = addLine(pointShift(spindle2Location, xshift: picketWidth/2, yshift: picketHeight/2 - tan(angle * π / 180) * picketWidth/2 - 1), finish: CGPoint(x: spindle2Location.x + 30, y: yOrigin - ySpace - picketHeight/2 - 1))
                spindleTick2.stroke()
                addArrow(pointShift(spindle2Location, xshift: picketWidth/2, yshift: picketHeight/2 - tan(angle * π / 180) * picketWidth/2 - 1), angle: angle)
                addArrow(pointShift(spindle2Location, xshift: -picketWidth/2, yshift: picketHeight/2), angle: angle)
            }
        }
        /*******************************/
        /* run space ticks begin here */
        /*******************************/
        if slopeChange {
            
            let runLine = addLine(CGPoint(x: xOrigin, y: yOrigin), finish: CGPoint(x: maxX + 20, y: yOrigin))
            runLine.stroke()
            
            let runMeasure = addLine(CGPoint(x: xOrigin + 10, y: yOrigin + 15), finish: CGPoint(x: run, y: yOrigin + 15))
            UIColor.whiteColor().set()
            runMeasure.stroke()
            addArrow(CGPoint(x: xOrigin + 10, y: yOrigin + 15), angle: 0)
            addArrow(CGPoint(x: run, y: yOrigin + 15), angle: 0)
            
            let runHash1 = addLine(CGPoint(x: xOrigin + 10, y: yOrigin + 2), finish: CGPoint(x: xOrigin + 10, y: yOrigin + 25))
            runHash1.stroke()
            
            let runHash2 = addLine(CGPoint(x: run, y: yOrigin + 25), finish: CGPoint(x: run, y: newY + 10))
            runHash2.stroke()
            
            let riseMeasure = addLine(CGPoint(x: maxX + 10, y: newY), finish: CGPoint(x: maxX + 10, y: yOrigin))
            riseMeasure.stroke()
            addArrow(CGPoint(x: maxX + 10, y: newY), angle: 0)
            addArrow(CGPoint(x: maxX + 10, y: yOrigin), angle: 0)
            
            let riseTick = addLine(CGPoint(x: maxX + 2, y: newY), finish: CGPoint(x: maxX + 20, y: newY))
            riseTick.stroke()
            
            let angleMeasure1 = UIBezierPath(arcCenter: CGPoint(x: xOrigin, y: yOrigin),
                                             radius: maxX / 1.3,
                                             startAngle: -angle / 180 * π * 0.96,
                                             endAngle: 0,
                                             clockwise: true)
            angleMeasure1.lineWidth = 1
            angleMeasure1.stroke()
            addArrow(CGPoint(x: xOrigin + maxX/1.3, y: yOrigin), angle: 0)
            
            let arrowXOrigin: CGFloat = xOrigin + maxX/1.3
            addArrow(CGPoint(x: cos(angle * π / 180) * arrowXOrigin + 1, y: yOrigin + 6 - sin(angle * π / 180) * arrowXOrigin), angle: 0)
        }
      }
    
    func addLine(start: CGPoint, finish: CGPoint) -> UIBezierPath {
        let newLine = UIBezierPath()
        newLine.moveToPoint(start)
        newLine.addLineToPoint(finish)
        newLine.lineWidth = 1
        return newLine
    }
    
    func pointShift(point: CGPoint, xshift: CGFloat, yshift: CGFloat) -> CGPoint {
        let newX = point.x + xshift
        let newY = point.y + yshift
        return CGPoint(x: newX, y: newY)
    }
    
//    func addArrow(head: CGPoint, angle: CGFloat) -> UIBezierPath {
//        let height: CGFloat = 8
//        let width: CGFloat = 2
//        let length: CGFloat = sqrt(height * height + width * width)
//        let arrowAngle: CGFloat = atan(width / height) * 180 / π
//        
//        let pt2x: CGFloat = head.x + (cos((angle + arrowAngle) * π / 180) * length)
//        var pt2y: CGFloat = head.y - (sin((angle + arrowAngle) * π / 180) * length)
//        
//        var pt3x: CGFloat = head.x + (cos((arrowAngle - angle) * π / 180) * length)
//        var pt3y: CGFloat = head.y - (sin((arrowAngle - angle) * π / 180) * length)
//        if angle == 0 || angle == 180 {
//            pt3x = pt2x
//            pt3y = head.y + (sin((angle + arrowAngle) * π / 180) * length)
//        } else if angle >= 70 && angle <= 270 {
//            pt2y = head.y + (sin((angle + arrowAngle) * π / 180) * length)
//        }
//        
//        let arrowHead = UIBezierPath()
//        arrowHead.moveToPoint(head)
//        arrowHead.addLineToPoint(CGPoint(x: pt2x, y: pt2y))
//        arrowHead.addLineToPoint(CGPoint(x: pt3x, y: pt3y))
//        arrowHead.closePath()
//        UIColor.whiteColor().set()
//        arrowHead.stroke()
//        arrowHead.fill()
//        
//        return arrowHead
//    }
    
    func addArrow(head: CGPoint, angle: CGFloat) -> UIBezierPath {
        let height: CGFloat = 4
        let width: CGFloat = 4
        let length: CGFloat = sqrt(pow(height, 2) + pow(width, 2))
        let arrowAngle = CGFloat(45 + angle)
        
        let pt2x: CGFloat = head.x + (cos((arrowAngle) * π / 180) * length)
        let pt2y: CGFloat = head.y - (sin((arrowAngle) * π / 180) * length)
        
        let pt3x: CGFloat = head.x - (cos((arrowAngle) * π / 180) * length)
        let pt3y: CGFloat = head.y + (sin((arrowAngle) * π / 180) * length)
        
        let arrowHead = addLine(CGPoint(x: pt2x, y: pt2y), finish: CGPoint(x: pt3x, y: pt3y))
        UIColor.whiteColor().set()
        arrowHead.stroke()
        
        return arrowHead
    }
    
}
// rob mayoff's CGPath.foreach
extension CGPath {
    func forEach(@noescape body: @convention(block) (CGPathElement) -> Void) {
        typealias Body = @convention(block) (CGPathElement) -> Void
        func callback(info: UnsafeMutablePointer<Void>, element: UnsafePointer<CGPathElement>) {
            let body = unsafeBitCast(info, Body.self)
            body(element.memory)
        }
        let unsafeBody = unsafeBitCast(body, UnsafeMutablePointer<Void>.self)
        CGPathApply(self, unsafeBody, callback)
    }
}

// Finds the first point in a path
extension UIBezierPath {
    func firstPoint() -> CGPoint? {
        var firstPoint: CGPoint? = nil
        
        self.CGPath.forEach { element in
            // Just want the first one, but we have to look at everything
            guard firstPoint == nil else { return }
            assert(element.type == .MoveToPoint, "Expected the first point to be a move")
            firstPoint = element.points.memory
        }
        return firstPoint
    }
}
