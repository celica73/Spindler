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
        path.moveToPoint(CGPoint(x: xOrigin, y: yMax + 20))
        path.addLineToPoint(arrowStart)
        path.addLineToPoint(arrowPoint)
        path.addLineToPoint(arrowFinish)
        path.addLineToPoint(CGPoint(x: xMax, y: yMax + 20))
        path.addLineToPoint(CGPoint(x: xMax, y: yOrigin))
        path.addLineToPoint(CGPoint(x: xOrigin, y: yOrigin))
        path.closePath()
        UIColor.grayColor().setStroke()
        UIColor.grayColor().setFill()
        path.stroke()
        path.fill()
    }
}
