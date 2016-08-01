//
//  NumberSelector.swift
//  Spindler
//
//  Created by Scott Johnson on 6/11/16.
//  Copyright © 2016 Scott Johnson. All rights reserved.
//

import UIKit

//@IBDesignable
class NumberSelector: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        let width = rect.width
        let height = rect.height
        let xOrigin: CGFloat = 20;
        let yOrigin: CGFloat = height
        let yMax: CGFloat = 0
        let xMax: CGFloat = width - 10
        let arrowStart = CGPointMake(width/3 - 10, yMax + 20)
        let arrowFinish = CGPointMake(width/3 + 10, yMax + 20)
        let arrowPoint = CGPointMake(width/3,yMax)
        
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: xOrigin, y: yMax + 30))
        path.addArcWithCenter(CGPoint(x: xOrigin + 10, y: yMax + 30), radius: 10.0, startAngle: π, endAngle: (3 * π / 2), clockwise: true)
        path.addLineToPoint(arrowStart)
        path.addLineToPoint(arrowPoint)
        path.addLineToPoint(arrowFinish)
        path.addLineToPoint(CGPoint(x: xMax - 10, y: yMax + 20))
        path.addArcWithCenter(CGPoint(x: xMax - 10, y: yMax + 30), radius: 10.0, startAngle: (3 * π / 2), endAngle: 0, clockwise: true)
        path.addLineToPoint(CGPoint(x: xMax, y: yOrigin - 10))
        path.addArcWithCenter(CGPoint(x: xMax - 10, y: yOrigin - 10), radius: 10.0, startAngle: 0, endAngle: (π/2), clockwise: true)
        path.addLineToPoint(CGPoint(x: xOrigin + 10, y: yOrigin))
        path.addArcWithCenter(CGPoint(x: xOrigin + 10, y: yOrigin - 10), radius: 10.0, startAngle: (π/2), endAngle: π, clockwise: true)
        path.closePath()
        UIColor.grayColor().setStroke()
        UIColor(patternImage: UIImage(named: "picker.png")!).setFill()
        path.stroke()
        path.fill()
    }
}
