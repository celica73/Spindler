//
//  ViewController.swift
//  Spindler
//
//  Created by Scott Johnson on 5/21/16.
//  Copyright © 2016 Scott Johnson. All rights reserved.
//

import UIKit

class LanscapeView: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    var engine = MathEngine.sharedInstance
    
    @IBOutlet var postSpacing: UILabel!
    @IBOutlet var spindleWidth: UILabel!
    @IBOutlet var maxSpace: UILabel!
    @IBOutlet var spaces: UILabel!
    @IBOutlet var spindles: UILabel!
    @IBOutlet var onCenter: UILabel!
    @IBOutlet var between: UILabel!
    @IBOutlet var angle: UILabel!
    @IBOutlet var rise: UILabel!
    @IBOutlet var run: UILabel!
    
    @IBOutlet var pictureView: SpindleDiagram!
    
    @IBOutlet var swipeGesture: UIPanGestureRecognizer!
    
    var tapLabel: UILabel!
    var labelColor: UIColor!
    
    let swipeRec = UIPanGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        swipeRec.addTarget(self, action: #selector(LanscapeView.swiper))
        pictureView.addGestureRecognizer(swipeRec)
        pictureView.userInteractionEnabled = true
        pictureView.multipleTouchEnabled = true
        pictureView.rise = CGFloat(engine.getProject().rise)
        pictureView.spindles = engine.getProject().numSpindles
        postSpacing.tag = 1
        spindleWidth.tag = 2
        maxSpace.tag = 3
        spaces.tag = 4
        spindles.tag = 5
        onCenter.tag = 6
        between.tag = 7
        angle.tag = 8
        rise.tag = 9
        run.tag = 10
        for i in 0...10 {
            if let taggedLabel = self.view.viewWithTag(i) as? UILabel {
                taggedLabel.userInteractionEnabled = true
                let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LanscapeView.labelAction))
                taggedLabel.addGestureRecognizer(tap)
                tap.delegate = self // Remember to extend your class with UIGestureRecognizerDelegate
            }
        }
        updateValues()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateValues() {
        updateLabel(postSpacing, center: pictureView.postSpaceLabel, text: (asFraction(engine.getProject().postSpacing) + "\""))
//        postSpacing.text = "PostSpacing: " + asFraction(engine.getProject().postSpacing) + "\""
        spindleWidth.text = "Spindle Width: " + asFraction(engine.getProject().spindleWidth) + "\""
        maxSpace.text = "Max Space: " + asFraction(engine.getProject().maxSpace) + "\""
        spaces.text = "Spaces: " + String(engine.getProject().numSpaces)
        spindles.text = "Spindles: " + String(engine.getProject().numSpindles)
        onCenter.text = "On center: " + asFraction(engine.getProject().onCenter) + "\""
        between.text = "Between: " + asFraction(engine.getProject().between) + "\""
        angle.text = NSString(format: "Angle: %.0f deg.",engine.getProject().angle) as String
        rise.text = "Rise: " + asFraction(engine.getProject().rise) + "\""
        run.text = "Run: " + asFraction(engine.getProject().run) + "\""
        if engine.getProject().maxSpace < engine.getProject().between {
            maxSpace.textColor = .redColor()
        } else {
            maxSpace.textColor = .whiteColor()
        }
    }
    
    func updateLabel(label: UILabel, center: CGPoint, text: String) {
        NSLog(String(pictureView.postSpaceLabel.x) + ", " + String(pictureView.postSpaceLabel.y))
        label.frame = CGRectMake(center.x, center.y, 100, 20)
        label.transform = CGAffineTransformMakeTranslation(center.x, center.y)
        label.center = center
        label.textAlignment = NSTextAlignment.Center
        label.text = text
        self.view.addSubview(label)
     }
    
    // Receive action
    func labelAction(gr:UITapGestureRecognizer) {
        let searchlbl:UILabel = (gr.view as! UILabel) // Type cast it with the class for which you have added gesture
        
        if tapLabel != nil && tapLabel == searchlbl {
            tapLabel.textColor = .whiteColor()
            tapLabel = nil
        } else {
            if tapLabel != nil {
                tapLabel.textColor = .whiteColor()
            }
            tapLabel = searchlbl
            tapLabel.textColor = .orangeColor()
        }
    }
    
    func asFraction(number: Double) -> String {
        let fraction = number - Double(Int(number))
        var denominator = 32
        var numerator = Int(fraction * Double(denominator))
        
        while(numerator != 0 && numerator % 2 == 0) {
            numerator /= 2
            denominator /= 2
        }
        if(numerator == 0) {
            return String(Int(number))
        } else {
            return NSString(format: "%d %d/%d", Int(number), numerator, denominator) as String
        }
    }
    
    var startLocation: CGPoint!
    
    @IBAction func swiper(sender: UIPanGestureRecognizer) {
        var changeValue:Double
        var velocity:CGPoint
        var moveFactor: Double = 1
        if tapLabel != nil {
            changeValue = engine.getValue(tapLabel.tag)
        } else {
            return
        }
        if tapLabel.tag == 4 || tapLabel.tag == 5 {
            moveFactor = 5
        }
        if (sender.state == UIGestureRecognizerState.Began) {
            startLocation = sender.locationInView(self.view)
        } else if (sender.state == UIGestureRecognizerState.Changed) {
            let stopLocation: CGPoint = sender.locationInView(self.view)
            velocity = sender.velocityInView(self.view)
            let dx: CGFloat = stopLocation.x - startLocation.x
            let dy: CGFloat = stopLocation.y - startLocation.y
            let direction = dx*dx > dy*dy ? dx : dy
            var distance: CGFloat = sqrt(dx*dx + dy*dy)
            if (direction == dx && dx < 0) || (direction == dy && dy > 0) {
                distance = -distance
            }
            let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
            let slideMult = magnitude / 10
            let factor = (slideMult > 4 ? 0.2 : 0.01) * moveFactor
            var newValue = Double(changeValue) + Double(distance) * factor
            newValue = newValue <= 0 ? 0 : newValue
            engine.updateOperation(tapLabel.tag, newValue: newValue)
            updateValues()
            pictureView.rise = CGFloat(engine.getProject().rise)
            pictureView.spindles = engine.getProject().numSpindles
            startLocation = stopLocation
        }
    }
}
