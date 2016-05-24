//
//  SpindleDiagram.swift
//  Spindler
//
//  Created by Scott Johnson on 5/23/16.
//  Copyright © 2016 Scott Johnson. All rights reserved.
//

import UIKit

let maxAngle: Double = 32
let π:Double = M_PI

@IBDesignable class SpindleDiagram: UIView {

    var angle: Double = 1 {
        didSet {
            if angle >= 1 && angle <= maxAngle  {
                //the view needs to be refreshed
                setNeedsDisplay()
            }
        }
    }
    @IBInspectable var outlineColor: UIColor = UIColor.blueColor()
    @IBInspectable var counterColor: UIColor = UIColor.orangeColor()
    
    override func drawRect(rect: CGRect) {
        
        let ctx : CGContextRef = UIGraphicsGetCurrentContext()!
        
        var rise = abs(tan(angle * π / 180)) * (Double(CGRectGetMaxX(rect) - 20.0))
        rise = rise > 1 ? rise : 1
        CGContextBeginPath(ctx)
        CGContextMoveToPoint(ctx, 10, CGRectGetMaxY(rect) - 10)
        //draw run
        CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect) - 10, CGRectGetMaxY(rect) - 10)
        //draw rise
        CGContextAddLineToPoint(ctx, (CGRectGetMaxX(rect) - 10), CGRectGetMaxY(rect) - CGFloat(rise))
        CGContextClosePath(ctx)
        
        CGContextSetRGBFillColor(ctx, 1.0, 0.5, 0.0, 0.60);
        CGContextFillPath(ctx);
    }

}
