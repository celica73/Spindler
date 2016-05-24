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
            case 1: postChange(newValue)
                break
            case 2: spindleWidthChange(newValue)
                break
            case 3: maxSpaceChange(newValue)
                break
            case 4: numSpacesChange(newValue)
                break
            case 5: numSpindlesChange(newValue)
                break
            case 6: onCenterChange(newValue)
                break
            case 7: betweenChange(newValue)
                break
            case 8: angleChange(newValue)
                break
            case 9: riseChange(newValue)
                break
            case 10: runChange(newValue)
                break
        default: postChange(newValue)
        }
    }
    
    func getValue(sender: Int)-> Double {
        switch sender {
        case 1: return postSpacing
        case 2: return spindleWidth
        case 3: return maxSpace
        case 4: return Double(numSpaces)
        case 5: return Double(numSpindles)
        case 6: return onCenter
        case 7: return between
        case 8: return angle
        case 9: return rise
        case 10: return run
        default: return postSpacing
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
        angle =  newValue > 0 ? (newValue > 75 ? 75: newValue): 0
        rise = postSpacing * abs(sin(angle * M_PI / 180))
        run = postSpacing * abs(cos(angle * M_PI / 180))
        numSpaces = Int(round((run) / (spindleWidth + maxSpace) + 1))
        numSpindles = numSpaces - 1
        between = (run - (Double(numSpindles) * spindleWidth)) / Double(numSpaces)
        onCenter = spindleWidth + between
    }
    
    func riseChange(newValue: Double) {
        rise = newValue
        let newAngle = asin(rise/postSpacing) * 180 /  M_PI
        angle =  newAngle > 0 ? (newAngle > 75 ? 75: newAngle): 0
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
        let newAngle = acos(run/postSpacing) * 180 /  M_PI
        angle =  newAngle > 0 ? (newAngle > 75 ? 75: newAngle): 0
        rise = sqrt(postSpacing * postSpacing - run*run)
        numSpaces = Int(round((run) / (spindleWidth + maxSpace) + 1))
        numSpindles = numSpaces - 1
        between = (run - (Double(numSpindles) * spindleWidth)) / Double(numSpaces)
        onCenter = spindleWidth + between
    }
}


