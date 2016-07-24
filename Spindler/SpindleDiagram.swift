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
    var angle: CGFloat = 30
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
    
    
    override func drawRect(rect: CGRect) {
        let yOrigin = rect.maxY - 30 //max Y is screen bottom
        let xOrigin:CGFloat = 10
        let maxX = rect.maxX - 30
        rise = (rise > 0 ? 90 : 0)
        let maxY: CGFloat = 10 //top of screen
        var newY = yOrigin - rise
        newY = newY > maxY ? newY: maxY
        maxRise = yOrigin - maxY
        let run = maxX - 10
        angle = atan(rise / run) * 180 / π
        
        let slope = UIBezierPath()
        slope.moveToPoint(CGPoint(x: xOrigin, y: yOrigin))
        slope.addLineToPoint(CGPoint(x: maxX, y: newY))
        slope.lineWidth = 5
        UIColor.brownColor().set()
        slope.stroke()
        
        let leftPost = UIBezierPath()
        let picketHeight: CGFloat = 80
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
        var spindle3Location = CGPointMake(xOrigin, yOrigin)
        let picketWidth: CGFloat = 7
        
        let numSpindles = (spindles < 5 ? spindles : 4)
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
                } else if spindle == 3 {
                    spindle3Location = spindleTop
                }
            }
        }
        
        /*******************************/
        /* post space ticks begin here */
        /*******************************/
        var ySpace = (((maxX/2 - 10) - (xOrigin)) / (maxX - xOrigin)) * (yOrigin - newY)
        let postSpaceHeight = yOrigin - picketHeight - 45
        let postHashHeight = yOrigin - picketHeight - 55
        let spindleSpaceHeight = yOrigin - picketHeight - 25
        
        let lengthLine = addLine(CGPoint(x: xOrigin + 10, y: postSpaceHeight),
                                  finish: CGPoint(x: maxX/2 - 10, y: postSpaceHeight - ySpace))
        UIColor.whiteColor().set()
        lengthLine.stroke()
        addArrow(CGPoint(x: xOrigin + 12, y: postSpaceHeight - 1), angle: angle)

        let lengthHash1 = addLine(CGPoint(x: xOrigin + 10, y: yOrigin - picketHeight - 2),
                                  finish: CGPoint(x: xOrigin + 10, y: postHashHeight))
        lengthHash1.stroke()
        
        ySpace = (((maxX/2 + 10) - (xOrigin)) / (maxX - xOrigin)) * (yOrigin - newY)
        
        let lengthTick2 = addLine(CGPoint(x: run, y: newY - picketHeight - 45),
                                  finish: CGPoint(x: maxX/2 + 10, y: postSpaceHeight - ySpace))
        lengthTick2.stroke()
        addArrow(CGPoint(x: run - 2, y: newY - picketHeight - 44), angle: 180 - angle)
        
        let lengthHash2 = addLine(CGPoint(x: run, y: newY - picketHeight - 2),
                                  finish: CGPoint(x: run, y: newY - picketHeight - 55))
        lengthHash2.stroke()
        /**************************/
        /* space ticks begin here */
        /**************************/
        if spindles > 1 {
            var midXOffset = (spindle2Location.x - spindle1Location.x)/2
            ySpace = (((spindle1Location.x + midXOffset - 10) - (xOrigin)) / (maxX - xOrigin)) * (yOrigin - newY)
            
            let spaceTick1 = addLine(pointShift(spindle1Location, xshift: 3, yshift: -25),
                                     finish: CGPoint(x: spindle1Location.x + midXOffset - 10, y: spindleSpaceHeight - ySpace))
            spaceTick1.stroke()
            addArrow(pointShift(spindle1Location, xshift: 5, yshift: -25), angle: angle)
            
            let spaceHash1 = addLine(pointShift(spindle1Location, xshift: 3, yshift: -2),
                                     finish: pointShift(spindle1Location, xshift: 3, yshift: -35))
            spaceHash1.stroke()
            
            ySpace = (((spindle1Location.x + midXOffset + 10) - (xOrigin)) / (maxX - xOrigin)) * (yOrigin - newY)
            
            let spaceTick2 = addLine(CGPoint(x: spindle2Location.x - midXOffset + 10, y: spindleSpaceHeight - ySpace),
                                     finish: pointShift(spindle2Location, xshift: -3, yshift: -25))
            spaceTick2.stroke()
            addArrow(pointShift(spindle2Location, xshift: -5, yshift: -25), angle: 180 - angle)
            
            let spaceHash2 = addLine(pointShift(spindle2Location, xshift: -3, yshift: -2),
                                     finish: pointShift(spindle2Location, xshift: -3, yshift: -35))
            spaceHash2.stroke()
            
            if spindles > 2 {
                midXOffset = spindle3Location.x
                
                ySpace = (((spindle3Location.x - 30) - (xOrigin)) / (maxX - xOrigin)) * (yOrigin - newY)
                
                let spindleTick2 = addLine(pointShift(spindle3Location, xshift: -picketWidth/2, yshift: picketHeight/2),
                                           finish: CGPoint(x: spindle3Location.x - 30, y: yOrigin - ySpace - picketHeight/2))
                spindleTick2.stroke()
                ySpace = (((spindle3Location.x + 30) - (xOrigin)) / (maxX - xOrigin)) * (yOrigin - newY)
                
                let spindleTick1 = addLine(pointShift(spindle3Location, xshift: picketWidth/2, yshift: picketHeight/2 - tan(angle) * picketWidth/2),
                                           finish: CGPoint(x: spindle3Location.x + 30, y: yOrigin - ySpace - picketHeight/2 - tan(angle) * picketWidth/2))
                spindleTick1.stroke()
                addArrow(pointShift(spindle3Location, xshift: picketWidth/2 + 2, yshift: picketHeight/2 - tan(angle) * picketWidth/2), angle: angle)
                addArrow(pointShift(spindle3Location, xshift: -picketWidth/2 - 2, yshift: picketHeight/2), angle: 180 - angle)
            } else if spindles == 2 {
                midXOffset = spindle2Location.x
                
                ySpace = (((spindle2Location.x - 30) - (xOrigin)) / (maxX - xOrigin)) * (yOrigin - newY)
                
                let spindleTick2 = addLine(pointShift(spindle2Location, xshift: -picketWidth/2, yshift: picketHeight/2),
                                           finish: CGPoint(x: spindle2Location.x - 30, y: yOrigin - ySpace - picketHeight/2))
                spindleTick2.stroke()
                
                ySpace = (((spindle2Location.x + 30) - (xOrigin)) / (maxX - xOrigin)) * (yOrigin - newY)
                
                let spindleTick1 = addLine(pointShift(spindle2Location, xshift: picketWidth/2, yshift: picketHeight/2),
                                           finish: CGPoint(x: spindle2Location.x + 30, y: yOrigin - ySpace - picketHeight/2))
                spindleTick1.stroke()
                addArrow(pointShift(spindle2Location, xshift: picketWidth/2 + 2, yshift: picketHeight/2), angle: angle)
                addArrow(pointShift(spindle2Location, xshift: -picketWidth/2 - 2, yshift: picketHeight/2), angle: 180 - angle)
            }
        }
        /*******************************/
        /* run space ticks begin here */
        /*******************************/
        if angle > 0 {
            
            let runLine = UIBezierPath()
            runLine.moveToPoint(CGPoint(x: xOrigin, y: yOrigin))
            runLine.addLineToPoint(CGPoint(x: maxX + 20, y: yOrigin))
            runLine.lineWidth = 1
            
            UIColor.whiteColor().set()
            runLine.stroke()
            
            let riseTick = UIBezierPath()
            riseTick.moveToPoint(CGPoint(x: maxX + 2, y: newY))
            riseTick.addLineToPoint(CGPoint(x: maxX + 20, y: newY))
            riseTick.lineWidth = 1
            riseTick.stroke()
            
            let halfRise = (yOrigin - newY)/2
            let riseMeasure1 = UIBezierPath()
            riseMeasure1.moveToPoint(CGPoint(x: maxX + 10, y: newY))
            riseMeasure1.addLineToPoint(CGPoint(x: maxX + 10, y: yOrigin - halfRise - 10))
            riseMeasure1.lineWidth = 1
            riseMeasure1.stroke()
            addArrow(CGPoint(x: maxX + 10, y: newY + 2), angle: 90)
            
            let riseMeasure2 = UIBezierPath()
            riseMeasure2.moveToPoint(CGPoint(x: maxX + 10, y: yOrigin))
            riseMeasure2.addLineToPoint(CGPoint(x: maxX + 10, y: yOrigin - halfRise + 10))
            riseMeasure2.lineWidth = 1
            riseMeasure2.stroke()
            addArrow(CGPoint(x: maxX + 10, y: yOrigin - 2), angle: 270)
            
            let runTick1 = addLine(CGPoint(x: xOrigin + 10, y: yOrigin + 15),
                                   finish: CGPoint(x: maxX/2 - 10, y: yOrigin + 15))
            UIColor.whiteColor().set()
            runTick1.stroke()
            addArrow(CGPoint(x: xOrigin + 10 + 2, y: yOrigin + 15), angle: 0)
            
            let runHash1 = addLine(CGPoint(x: xOrigin + 10, y: yOrigin + 2),
                                   finish: CGPoint(x: xOrigin + 10, y: yOrigin + 25))
            runHash1.stroke()
            
            let runTick2 = addLine(CGPoint(x: run, y: yOrigin + 15),
                                   finish: CGPoint(x: maxX/2 + 10, y: yOrigin + 15))
            runTick2.stroke()
            addArrow(CGPoint(x: run - 2, y: yOrigin + 15), angle: 180)
            
            let runHash2 = addLine(CGPoint(x: run, y: yOrigin + 25),
                                   finish: CGPoint(x: run, y: newY + 10))
            runHash2.stroke()
            
            let angleMeasure1 = UIBezierPath(arcCenter: CGPoint(x: xOrigin, y: yOrigin),
                                             radius: maxX / 1.3,
                                             startAngle: -angle / 180 * π * 0.4,
                                             endAngle: 0,
                                             clockwise: true)
            angleMeasure1.lineWidth = 1
            angleMeasure1.stroke()
            addArrow(CGPoint(x: xOrigin + maxX/1.3, y: yOrigin - 2), angle: 265)
            
            let angleMeasure2 = UIBezierPath(arcCenter: CGPoint(x: xOrigin, y: yOrigin),
                                            radius: maxX / 1.3,
                                            startAngle: -angle / 180 * π * 0.85,
                                            endAngle: -angle / 180 * π * 0.6,
                                            clockwise: true)
            angleMeasure2.lineWidth = 1
            angleMeasure2.stroke()
            let arrowXOrigin: CGFloat = xOrigin + maxX/1.3
            addArrow(CGPoint(x: cos(angle * π / 180) * arrowXOrigin, y: yOrigin + 8 - sin(angle * π / 180) * arrowXOrigin), angle: 70)
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
        let arrowAngle = CGFloat(45)
        
        let pt2x: CGFloat = head.x + (cos((angle + arrowAngle) * π / 180) * length)
        var pt2y: CGFloat = head.y - (sin((angle + arrowAngle) * π / 180) * length)
        
        var pt3x: CGFloat = head.x - (cos((arrowAngle - angle) * π / 180) * length)
        var pt3y: CGFloat = head.y + (sin((arrowAngle - angle) * π / 180) * length)
//        if angle == 0 || angle == 180 {
//            pt3x = pt2x
//            pt3y = head.y + (sin((angle + arrowAngle) * π / 180) * length)
//        } else if angle >= 70 && angle <= 270 {
//            pt2y = head.y + (sin((angle + arrowAngle) * π / 180) * length)
//        }
        
        let arrowHead = UIBezierPath()
        arrowHead.moveToPoint(CGPoint(x: pt2x, y: pt2y))
        arrowHead.addLineToPoint(CGPoint(x: pt3x, y: pt3y))
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
