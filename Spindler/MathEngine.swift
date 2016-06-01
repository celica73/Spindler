//
//  MathEngine.swift
//  Spindler
//
//  Created by Scott Johnson on 5/21/16.
//  Copyright © 2016 Scott Johnson. All rights reserved.
//

import Foundation


private let sharedEngine = MathEngine()

class MathEngine {
    class var sharedInstance: MathEngine {
        return sharedEngine
    }
    var newProject: Project
    
    init(){
        self.newProject = Project()
        updateOperation(1, newValue: newProject.postSpacing)
    }
    
    func getProject() -> Project {
        return self.newProject
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
        case 1: return newProject.postSpacing
        case 2: return newProject.spindleWidth
        case 3: return newProject.maxSpace
        case 4: return Double(newProject.numSpaces)
        case 5: return Double(newProject.numSpindles)
        case 6: return newProject.onCenter
        case 7: return newProject.between
        case 8: return newProject.angle
        case 9: return newProject.rise
        case 10: return newProject.run
        default: return newProject.postSpacing
        }
    }
    
    func postChange(newValue: Double) {
        newProject.postSpacing = newValue
        newProject.numSpaces = Int(round((newProject.postSpacing) / (newProject.spindleWidth + newProject.maxSpace) + 1))
        newProject.numSpindles = newProject.numSpaces - 1
        newProject.between = (newProject.postSpacing - (Double(newProject.numSpindles) * newProject.spindleWidth)) / Double(newProject.numSpaces)
        newProject.onCenter = newProject.spindleWidth + newProject.between
        newProject.rise = newProject.postSpacing * abs(sin(newProject.angle))
        newProject.run = newProject.postSpacing * abs(cos(newProject.angle))
    }
    
    func spindleWidthChange(newValue: Double) {
        newProject.spindleWidth = newValue
        newProject.numSpaces = Int((newProject.postSpacing) / (newProject.spindleWidth + newProject.maxSpace) + 1)
        newProject.numSpindles = newProject.numSpaces - 1
        if newProject.numSpaces > 0 {
            newProject.between = (newProject.postSpacing - (Double(newProject.numSpindles) * newProject.spindleWidth)) / Double(newProject.numSpaces)
        }
        newProject.onCenter = newProject.spindleWidth + newProject.between
    }
    
    func maxSpaceChange(newValue: Double) {
        newProject.maxSpace = newValue
        if (newProject.spindleWidth + newProject.maxSpace) > 0 {
            newProject.numSpaces = Int((newProject.postSpacing) / (newProject.spindleWidth + newProject.maxSpace) + 1)
        }
        newProject.numSpindles = newProject.numSpaces - 1
        newProject.between = (newProject.postSpacing - (Double(newProject.numSpindles) * newProject.spindleWidth)) / Double(newProject.numSpaces)
        newProject.onCenter = newProject.spindleWidth + newProject.between
    }
    
    func numSpacesChange(newValue: Double) {
        newProject.numSpaces = Int(newValue) >= 1 ? Int(newValue) : 1
        newProject.numSpindles = newProject.numSpaces - 1
        if newProject.numSpaces > 0 {
            newProject.between = (newProject.postSpacing - (Double(newProject.numSpindles) * newProject.spindleWidth)) / Double(newProject.numSpaces)
        }
        newProject.onCenter = newProject.spindleWidth + newProject.between
    }
    
    func numSpindlesChange(newValue: Double) {
        newProject.numSpindles = Int(newValue) >= 0 ? Int(newValue) : 0
        newProject.numSpaces = newProject.numSpindles + 1
        if newProject.numSpaces > 0 {
            newProject.between = (newProject.postSpacing - (Double(newProject.numSpindles) * newProject.spindleWidth)) / Double(newProject.numSpaces)
        }
        newProject.onCenter = newProject.spindleWidth + newProject.between
    }
    
    func onCenterChange(newValue: Double) {
        newProject.onCenter = newValue
        newProject.between = newProject.onCenter - newProject.spindleWidth
        if (newProject.between + newProject.spindleWidth) > 0 {
            newProject.numSpaces = Int((newProject.postSpacing + newProject.spindleWidth)/(newProject.between + newProject.spindleWidth))
        }
        newProject.numSpindles = newProject.numSpaces + 1
        if(newProject.between > newProject.maxSpace){
            newProject.maxSpace = newProject.between
        }
    }
    
    func betweenChange(newValue: Double) {
        newProject.between = newValue
        newProject.onCenter = newProject.between + newProject.spindleWidth
        if (newProject.between + newProject.spindleWidth) > 0 {
            newProject.numSpaces = Int((newProject.postSpacing + newProject.spindleWidth)/(newProject.between + newProject.spindleWidth))
        }
        newProject.numSpindles = newProject.numSpaces + 1
    }
    
    func angleChange(newValue: Double) {
        newProject.angle =  newValue > 0 ? (newValue > 75 ? 75: newValue): 0
        newProject.rise = newProject.postSpacing * abs(sin(newProject.angle * M_PI / 180))
        newProject.run = newProject.postSpacing * abs(cos(newProject.angle * M_PI / 180))
        if (newProject.spindleWidth + newProject.maxSpace) > 0 {
            newProject.numSpaces = Int(round((newProject.run) / (newProject.spindleWidth + newProject.maxSpace) + 1))
        }
        newProject.numSpindles = newProject.numSpaces - 1
        if newProject.numSpaces > 0 {
            newProject.between = (newProject.run - (Double(newProject.numSpindles) * newProject.spindleWidth)) / Double(newProject.numSpaces)
        }
        newProject.onCenter = newProject.spindleWidth + newProject.between
    }
    
    func riseChange(newValue: Double) {
        newProject.rise = newValue
        let newAngle = abs(asin(newProject.rise/newProject.postSpacing)) * 180 /  M_PI
        newProject.angle = newAngle > 0 ? (newAngle > 75 ? 75: newAngle): 0
        if(newProject.angle < 90 && newProject.angle > 0) {
            newProject.run = sqrt(newProject.postSpacing*newProject.postSpacing - newProject.rise*newProject.rise)
            if (newProject.spindleWidth + newProject.maxSpace) > 0 {
                newProject.numSpaces = Int(round((newProject.run) / (newProject.spindleWidth + newProject.maxSpace) + 1))
            }
            newProject.numSpindles = newProject.numSpaces - 1
            if newProject.numSpaces > 0 {
                newProject.between = (newProject.run - (Double(newProject.numSpindles) * newProject.spindleWidth)) / Double(newProject.numSpaces)
            }
            newProject.onCenter = newProject.spindleWidth + newProject.between
        }
    }
    
    func runChange(newValue: Double) {
        newProject.run = newValue
        if(newProject.run > newProject.postSpacing){
            newProject.postSpacing = newProject.run
        }
        let newAngle = abs(acos(newProject.run/newProject.postSpacing)) * 180 /  M_PI
        newProject.angle =  newAngle > 0 ? (newAngle > 75 ? 75: newAngle): 0
        newProject.rise = sqrt(newProject.postSpacing * newProject.postSpacing - newProject.run*newProject.run)
        if (newProject.spindleWidth + newProject.maxSpace) > 0 {
            newProject.numSpaces = Int(round((newProject.run) / (newProject.spindleWidth + newProject.maxSpace) + 1))
        }
        newProject.numSpindles = newProject.numSpaces - 1
        if newProject.numSpaces > 0 {
            newProject.between = (newProject.run - (Double(newProject.numSpindles) * newProject.spindleWidth)) / Double(newProject.numSpaces)
        }
        newProject.onCenter = newProject.spindleWidth + newProject.between
    }
}


