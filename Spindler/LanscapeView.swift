//
//  ViewController.swift
//  Spindler
//
//  Created by Scott Johnson on 5/21/16.
//  Copyright © 2016 Scott Johnson. All rights reserved.
//

import UIKit

class LanscapeView: UIViewController, UIGestureRecognizerDelegate, UIPopoverPresentationControllerDelegate {
    
    var engine = MathEngine()
    
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

    @IBOutlet var unitsSelector: UISwitch!
    @IBOutlet var slopeSelector: UISwitch!
    
    @IBOutlet var info: UIButton!
    var getInfo = false;
    
    var metric = false
    var slope = false
    var landscape = false
    var stepAdjust = UIStepper(frame:CGRectMake(110, 250, 0, 0))
    
    @IBOutlet var pictureView: SpindleDiagram!
    
    var tapLabel: UILabel!
    var labelColor: UIColor!
    
    var btnDone = UIBarButtonItem()

    override func viewDidLoad() {
        super.viewDidLoad()
        btnDone = UIBarButtonItem(title: "Done", style: .Done, target: self, action: #selector(LanscapeView.dismiss))
        stepAdjust.wraps = true
        stepAdjust.autorepeat = true
        stepAdjust.maximumValue = 100
        stepAdjust.backgroundColor = .lightGrayColor()
        stepAdjust.addTarget(self, action: #selector(LanscapeView.setStepper), forControlEvents: .ValueChanged)
        self.view.addSubview(stepAdjust)
        stepAdjust.hidden = true
        stepAdjust.layer.cornerRadius = 5;
        
        // Do any additional setup after loading the view, typically from a nib.

        
        pictureView.rise = CGFloat(engine.getProject().rise.getMetricMeasure())
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
                let tap = UITapGestureRecognizer(target: self, action: #selector(LanscapeView.labelAction))
                taggedLabel.addGestureRecognizer(tap)
                tap.delegate = self // Remember to extend your class with UIGestureRecognizerDelegate
                taggedLabel.layer.cornerRadius = 5.0
                taggedLabel.layer.masksToBounds = true
            }
        }

        pictureView.userInteractionEnabled = true
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(LanscapeView.labelFinish))
        pictureView.addGestureRecognizer(tap2)
        tap2.delegate = self
        
        rise.hidden = !slope
        run.hidden = !slope
        angle.hidden = !slope
        
    }
    
    override func viewDidAppear(animated: Bool) {
        updateValues()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
//        dismiss()
        UIApplication.sharedApplication().sendAction(btnDone.action, to: btnDone.target, from: self, forEvent: nil)
        landscape = !landscape
        pictureView.landscapeView = landscape
        info.hidden = landscape
        if tapLabel != nil {
            stepAdjust.center = CGPointMake(CGRectGetMaxX(tapLabel.frame) + stepAdjust.frame.width/2,CGRectGetMidY(tapLabel.frame))
        }
        let delay = 0.025
        NSTimer.scheduledTimerWithTimeInterval(delay, target: self, selector: #selector(updateValues), userInfo: nil, repeats: false)
    }
    
    @IBAction func getInfo(sender: UIButton) {
        getInfo = true
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("Popover View")
        vc.modalPresentationStyle = UIModalPresentationStyle.Popover
        let popover: UIPopoverPresentationController = vc.popoverPresentationController!
        let viewForSource = sender as UIView
        popover.sourceView = viewForSource
        
        // the position of the popover where it's showed
        popover.sourceRect = viewForSource.bounds
        popover.delegate = self
        presentViewController(vc, animated: true, completion:nil)
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        //        return UIModalPresentationStyle.FullScreen
        if getInfo {
            return UIModalPresentationStyle.Popover
        } else {
            return UIModalPresentationStyle.None
        }
    }
    
    func presentationController(controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        let navigationController = UINavigationController(rootViewController: controller.presentedViewController)
//        let btnDone = UIBarButtonItem(title: "Done", style: .Done, target: self, action: #selector(LanscapeView.dismiss))
        navigationController.topViewController!.navigationItem.rightBarButtonItem = btnDone
        return navigationController
    }
    
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
        getInfo = false
    }

    
    func updateValues() {
        postSpacing.attributedText = engine.getProject().postSpacing.asString(metric)
        spindleWidth.attributedText = engine.getProject().spindleWidth.asString(metric)
        maxSpace.attributedText = engine.getProject().maxSpace.asString(metric)
        spaces.text = " " + String(engine.getProject().numSpaces) + " "
        spindles.text = " " + String(engine.getProject().numSpindles) + " "
        onCenter.attributedText = engine.getProject().onCenter.asString(metric)
        between.attributedText = engine.getProject().between.asString(metric)
        angle.text = String(format: " %.0f\u{00B0} ",engine.getProject().angle)
        rise.attributedText = engine.getProject().rise.asString(metric)
        run.attributedText = engine.getProject().run.asString(metric)
        rise.sizeToFit()
        postSpacing.sizeToFit()
        spindleWidth.sizeToFit()
        between.sizeToFit()
        angle.sizeToFit()
        run.sizeToFit()
        if engine.getProject().maxSpace.getMetricMeasure() < engine.getProject().between.getMetricMeasure() {
            maxSpace.textColor = .redColor()
        } else {
            maxSpace.textColor = .blackColor()
        }
        pictureView.rise = CGFloat(engine.getProject().rise.getMetricMeasure())
        pictureView.spindles = engine.getProject().numSpindles
        updatePositions()
    }
    
    func updatePositions() {
        let center = CGPointMake(view.frame.midX, view.frame.midY)
        let viewCenter = CGPointMake(pictureView.frame.midX, pictureView.frame.midY)
        let xOffset = center.x - viewCenter.x
        let yOffset = center.y - viewCenter.y
        rise.center = pictureView.pointShift(pictureView.riseLocation, xshift: xOffset - rise.frame.width/2, yshift: yOffset)
        run.center = pictureView.pointShift(pictureView.runLocation, xshift: xOffset, yshift: yOffset)
        postSpacing.center = pictureView.pointShift(pictureView.slopeLocation, xshift: xOffset, yshift: yOffset)
        between.center = pictureView.pointShift(pictureView.spaceLocation, xshift: xOffset, yshift: yOffset)
        spindleWidth.center = pictureView.pointShift(pictureView.picketLocation, xshift: xOffset, yshift: yOffset)
        angle.center = pictureView.pointShift(pictureView.angleLocation, xshift: xOffset, yshift: yOffset)
    }
    
    func measurementPopover(view: UIView){
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("Popover")
        vc.modalPresentationStyle = UIModalPresentationStyle.Popover
        let popover: UIPopoverPresentationController = vc.popoverPresentationController!
        let viewForSource = view
        popover.sourceView = viewForSource
        
        // the position of the popover where it's showed
        popover.sourceRect = viewForSource.bounds
        popover.delegate = self
        presentViewController(vc, animated: true, completion:nil)
    }
    
    // Receive action
    func labelAction(gr:UITapGestureRecognizer) {
        let searchlbl = (gr.view as! UILabel) // Type cast it with the class for which you have added gesture
//        feetPicker.reloadAllComponents()
        
        measurementPopover(gr.view!)
        
        if tapLabel != nil && tapLabel == searchlbl {
            tapLabel.textColor = .blackColor()
            tapLabel = nil
            stepAdjust.hidden = true
        } else {
            if tapLabel != nil {
                tapLabel.textColor = .blackColor()
                stepAdjust.hidden = true
            }
            tapLabel = searchlbl
            let labelFrame: CGRect = tapLabel.frame
            if tapLabel.tag != 4 && tapLabel.tag != 5 && tapLabel.tag != 8 {
                tapLabel.textColor = .orangeColor()
//                setPickerValues()
            } else {
                tapLabel.textColor = .orangeColor()
                stepAdjust.center = CGPointMake(CGRectGetMaxX(labelFrame) + stepAdjust.frame.width/2,CGRectGetMidY(labelFrame))
                stepAdjust.hidden = false
                stepAdjust.value = engine.getValue(tapLabel.tag)
            }
        }
    }
    
    func labelFinish(gr:UITapGestureRecognizer) {
        if tapLabel != nil {
            tapLabel.textColor = .blackColor()
            tapLabel = nil
            stepAdjust.hidden = true
        }
    }
    
    @IBAction func setStepper(sender: UIStepper) {
        engine.updateOperation(tapLabel.tag, newValue: stepAdjust.value)
        between.hidden = !Bool(engine.getProject().numSpindles)
        spindleWidth.hidden = !Bool(engine.getProject().numSpindles)
        onCenter.hidden = !Bool(engine.getProject().numSpindles)
        let delay = 0.025
        NSTimer.scheduledTimerWithTimeInterval(delay, target: self, selector: #selector(updateValues), userInfo: nil, repeats: false)
        updateValues()
    }


    
    @IBAction func slopeChanger(sender: UISwitch) {
        slope = !slope
        pictureView.slopeChange = slope

        if !slope {
            engine.getProject().rise.update(0, metricInput: true)
            engine.updateOperation(rise.tag, newValue: engine.getProject().rise)
            pictureView.rise = 0
        }
        rise.hidden = !slope
        angle.hidden = !slope
        run.hidden = !slope
        let delay = 0.025
        NSTimer.scheduledTimerWithTimeInterval(delay, target: self, selector: #selector(updateValues), userInfo: nil, repeats: false)
    }
    
    @IBAction func unitsChange(sender: UISwitch) {
        metric = !metric
        updateValues()
    }
}
