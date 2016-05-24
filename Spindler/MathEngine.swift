//
//  MathEngine.swift
//  Spindler
//
//  Created by Scott Johnson on 5/21/16.
//  Copyright © 2016 Scott Johnson. All rights reserved.
//

import Foundation



class MathEngine {
    
    var postSpacing = 100.0
    var spindleWidth = 1.5
    var onCenter: (Double)
    var between: (Double)
    var angle = 0.0
    var rise = 0.0
    var run = 0.0
    var maxSpace = 4.0
    var numSpaces: (Int)
    var numSpindles: (Int)
    var units = false
    
    init(){
        numSpaces = Int(round((postSpacing) / (spindleWidth + maxSpace) + 1))
        numSpindles = numSpaces - 1
        between = (postSpacing - (Double(numSpindles) * spindleWidth)) / Double(numSpaces)
        onCenter = spindleWidth + between
        rise = postSpacing * sin(angle)
        run = postSpacing * cos(angle)
    }
    
    func updateOperation(sender: Int, newValue: Double) {
        switch sender {
            case 0: postChange(newValue)
                break
            case 1: spindleWidthChange(newValue)
                break
            case 2: maxSpaceChange(newValue)
                break
            case 3: numSpacesChange(newValue)
                break
            case 4: numSpindlesChange(newValue)
                break
            case 5: onCenterChange(newValue)
                break
            case 6: betweenChange(newValue)
                break
            case 7: angleChange(newValue)
                break
            case 8: riseChange(newValue)
                break
            case 9: runChange(newValue)
                break
        default: postChange(newValue)
        }
    }
    
    func postChange(newValue: Double) {
        postSpacing = newValue
        numSpaces = Int(round((postSpacing) / (spindleWidth + maxSpace) + 1))
        numSpindles = numSpaces - 1
        between = (postSpacing - (Double(numSpindles) * spindleWidth)) / Double(numSpaces)
        onCenter = spindleWidth + between
        rise = postSpacing * sin(angle)
        run = postSpacing * cos(angle)
    }
    
    func spindleWidthChange(newValue: Double) {
        spindleWidth = newValue
        numSpaces = Int((postSpacing) / (spindleWidth + maxSpace) + 1)
        numSpindles = numSpaces - 1
        between = (postSpacing - (Double(numSpindles) * spindleWidth)) / Double(numSpaces)
        onCenter = spindleWidth + between
    }
    
    func maxSpaceChange(newValue: Double) {
        maxSpace = newValue
        numSpaces = Int((postSpacing) / (spindleWidth + maxSpace) + 1)
        numSpindles = numSpaces - 1
        between = (postSpacing - (Double(numSpindles) * spindleWidth)) / Double(numSpaces)
        onCenter = spindleWidth + between
    }
    
    func numSpacesChange(newValue: Double) {
        numSpaces = Int(newValue)
        numSpindles = numSpaces - 1
        between = (postSpacing - (Double(numSpindles) * spindleWidth)) / Double(numSpaces)
        onCenter = spindleWidth + between
        if(between > maxSpace){
            maxSpace = between
        }
        
    }
    
    func numSpindlesChange(newValue: Double) {
        numSpindles = Int(newValue)
        numSpaces = numSpindles + 1
        between = (postSpacing - (Double(numSpindles) * spindleWidth)) / Double(numSpaces)
        onCenter = spindleWidth + between
        if(between > maxSpace){
            maxSpace = between
        }
    }
    
    func onCenterChange(newValue: Double) {
        onCenter = newValue
        between = onCenter - spindleWidth
        numSpaces = Int((postSpacing + spindleWidth)/(between + spindleWidth))
        numSpindles = numSpaces + 1
        if(between > maxSpace){
            maxSpace = between
        }
    }
    
    func betweenChange(newValue: Double) {
        between = newValue
        onCenter = between + spindleWidth
        numSpaces = Int((postSpacing + spindleWidth)/(between + spindleWidth))
        numSpindles = numSpaces + 1
        if(between > maxSpace){
            maxSpace = between
        }
    }
    
    func angleChange(newValue: Double) {
        angle = newValue
        rise = postSpacing * abs(sin(angle * M_PI / 180))
        run = postSpacing * abs(cos(angle * M_PI / 180))
        numSpaces = Int(round((run) / (spindleWidth + maxSpace) + 1))
        numSpindles = numSpaces - 1
        between = (run - (Double(numSpindles) * spindleWidth)) / Double(numSpaces)
        onCenter = spindleWidth + between
    }
    
    func riseChange(newValue: Double) {
        rise = newValue
        angle = asin(rise/postSpacing) * 180 /  M_PI
        if(angle < 90 && angle > 0) {
            run = sqrt(postSpacing*postSpacing - rise*rise)
            numSpaces = Int(round((run) / (spindleWidth + maxSpace) + 1))
            numSpindles = numSpaces - 1
            between = (run - (Double(numSpindles) * spindleWidth)) / Double(numSpaces)
            onCenter = spindleWidth + between
        }
    }
    
    func runChange(newValue: Double) {
        run = newValue
        if(run > postSpacing){
            postSpacing = run
        }
        angle = acos(run/postSpacing) * 180 /  M_PI
        rise = sqrt(postSpacing * postSpacing - run*run)
        numSpaces = Int(round((run) / (spindleWidth + maxSpace) + 1))
        numSpindles = numSpaces - 1
        between = (run - (Double(numSpindles) * spindleWidth)) / Double(numSpaces)
        onCenter = spindleWidth + between
    }
}


