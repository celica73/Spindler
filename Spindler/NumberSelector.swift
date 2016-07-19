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
        let yOrigin: CGFloat = height - 20
        let yMax: CGFloat = 20
        let xMax: CGFloat = width - 10
        var arrowStart: CGPoint = CGPointMake(CGFloat(20),height / 2 + 10)
        var arrowFinish: CGPoint = CGPointMake(CGFloat(20),height / 2 - 10)
        var arrowPoint: CGPoint = CGPointMake(CGFloat(0),height / 2)
        
        var path = UIBezierPath()
        path.moveToPoint(CGPoint(x: xOrigin, y: yOrigin))
        path.addLineToPoint(arrowStart)
        path.addLineToPoint(arrowPoint)
        path.addLineToPoint(arrowFinish)
        path.addLineToPoint(CGPoint(x: xOrigin, y: yMax))
        path.addLineToPoint(CGPoint(x: xMax, y: yMax))
        path.addLineToPoint(CGPoint(x: xMax, y: yOrigin))
        path.closePath()
        UIColor.grayColor().setStroke()
        UIColor.grayColor().setFill()
        path.stroke()
        path.fill()
    }
}
