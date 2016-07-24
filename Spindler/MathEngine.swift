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
    
    func updateOperation(sender: Int, newValue: Measurement) {
        switch sender {
            case 1: postChange(newValue)
                break
            case 2: spindleWidthChange(newValue)
                break
            case 3: maxSpaceChange(newValue)
                break
            case 6: onCenterChange(newValue)
                break
            case 7: betweenChange(newValue)
                break
            case 9: riseChange(newValue)
                break
            case 10: runChange(newValue)
                break
        default: postChange(newValue)
        }
    }
    
    func updateOperation(sender: Int, newValue: Double) {
        switch sender {
        case 4: numSpacesChange(newValue)
            break
        case 5: numSpindlesChange(newValue)
            break
        case 8: angleChange(newValue)
            break
        default: break
        }
    }
    
    func getValue(sender: Int)-> Double {
        switch sender {
        case 1: return newProject.postSpacing.getRealMeasure()
        case 2: return newProject.spindleWidth.getRealMeasure()
        case 3: return newProject.maxSpace.getRealMeasure()
        case 4: return Double(newProject.numSpaces)
        case 5: return Double(newProject.numSpindles)
        case 6: return newProject.onCenter.getRealMeasure()
        case 7: return newProject.between.getRealMeasure()
        case 8: return newProject.angle
        case 9: return newProject.rise.getRealMeasure()
        case 10: return newProject.run.getRealMeasure()
        default: return newProject.postSpacing.getRealMeasure()
        }
    }
    
    func postChange(newValue: Measurement) {
        newProject.postSpacing.update(newValue.getRealMeasure())
        newProject.numSpaces = Int(round((newProject.postSpacing.getRealMeasure()) / (newProject.spindleWidth.getRealMeasure() + newProject.maxSpace.getRealMeasure()) + 1))
        newProject.numSpindles = newProject.numSpaces - 1
        newProject.between.update((newProject.postSpacing.getRealMeasure() - (Double(newProject.numSpindles) * newProject.spindleWidth.getRealMeasure())) / Double(newProject.numSpaces))
        newProject.onCenter.update(newProject.spindleWidth.getRealMeasure() + newProject.between.getRealMeasure())
        newProject.rise.update(newProject.postSpacing.getRealMeasure() * abs(sin(newProject.angle)))
        newProject.run.update(newProject.postSpacing.getRealMeasure() * abs(cos(newProject.angle)))
    }
    
    func spindleWidthChange(newValue: Measurement) {
        newProject.spindleWidth.update(newValue)
        newProject.numSpaces = Int((newProject.postSpacing.getRealMeasure()) / (newProject.spindleWidth.getRealMeasure() + newProject.maxSpace.getRealMeasure()) + 1)
        newProject.numSpindles = newProject.numSpaces - 1
        if newProject.numSpaces > 0 {
            newProject.between.update((newProject.postSpacing.getRealMeasure() - (Double(newProject.numSpindles) * newProject.spindleWidth.getRealMeasure())) / Double(newProject.numSpaces))
        }
        newProject.onCenter.update(newProject.spindleWidth.getRealMeasure() + newProject.between.getRealMeasure())
    }
    
    func maxSpaceChange(newValue: Measurement) {
        newProject.maxSpace.update(newValue)
        if (newProject.spindleWidth.getRealMeasure() + newProject.maxSpace.getRealMeasure()) > 0 {
            newProject.numSpaces = Int((newProject.postSpacing.getRealMeasure()) / (newProject.spindleWidth.getRealMeasure() + newProject.maxSpace.getRealMeasure()) + 1)
        }
        newProject.numSpindles = newProject.numSpaces - 1
        newProject.between.update((newProject.postSpacing.getRealMeasure() - (Double(newProject.numSpindles) * newProject.spindleWidth.getRealMeasure())) / Double(newProject.numSpaces))
        newProject.onCenter.update(newProject.spindleWidth.getRealMeasure() + newProject.between.getRealMeasure())
    }
    
    func numSpacesChange(newValue: Double) {
        newProject.numSpaces = Int(newValue) >= 1 ? Int(newValue) : 1
        newProject.numSpindles = newProject.numSpaces - 1
        if newProject.numSpaces > 0 {
            newProject.between.update((newProject.postSpacing.getRealMeasure() - (Double(newProject.numSpindles) * newProject.spindleWidth.getRealMeasure())) / Double(newProject.numSpaces))
        }
        newProject.onCenter.update(newProject.spindleWidth.getRealMeasure() + newProject.between.getRealMeasure())
    }
    
    func numSpindlesChange(newValue: Double) {
        newProject.numSpindles = Int(newValue) >= 0 ? Int(newValue) : 0
        newProject.numSpaces = newProject.numSpindles + 1
        if newProject.numSpaces > 0 {
            newProject.between.update((newProject.postSpacing.getRealMeasure() - (Double(newProject.numSpindles) * newProject.spindleWidth.getRealMeasure())) / Double(newProject.numSpaces))
        }
        newProject.onCenter.update(newProject.spindleWidth.getRealMeasure() + newProject.between.getRealMeasure())
    }
    
    func onCenterChange(newValue: Measurement) {
        newProject.onCenter.update(newValue)
        newProject.between.update(newProject.onCenter.getRealMeasure() - newProject.spindleWidth.getRealMeasure())
        if (newProject.between.getRealMeasure() + newProject.spindleWidth.getRealMeasure()) > 0 {
            newProject.numSpaces = Int((newProject.postSpacing.getRealMeasure() + newProject.spindleWidth.getRealMeasure())/(newProject.between.getRealMeasure() + newProject.spindleWidth.getRealMeasure()))
        }
        newProject.numSpindles = newProject.numSpaces + 1
        if(newProject.between.getRealMeasure() > newProject.maxSpace.getRealMeasure()){
            newProject.maxSpace = newProject.between
        }
    }
    
    func betweenChange(newValue: Measurement) {
        newProject.between.update(newValue)
        newProject.onCenter.update(newProject.between.getRealMeasure() + newProject.spindleWidth.getRealMeasure())
        if (newProject.between.getRealMeasure() + newProject.spindleWidth.getRealMeasure()) > 0 {
            newProject.numSpaces = Int((newProject.postSpacing.getRealMeasure()
                + newProject.spindleWidth.getRealMeasure())/(newProject.between.getRealMeasure() + newProject.spindleWidth.getRealMeasure()))
        }
        newProject.numSpindles = newProject.numSpaces + 1
    }
    
    func angleChange(newValue: Double) {
        newProject.angle =  newValue > 0 ? (newValue > 75 ? 75: newValue): 0
        newProject.rise.update(newProject.postSpacing.getRealMeasure() * abs(sin(newProject.angle * M_PI / 180)))
        newProject.run.update(newProject.postSpacing.getRealMeasure() * abs(cos(newProject.angle * M_PI / 180)))
        if (newProject.spindleWidth.getRealMeasure() + newProject.maxSpace.getRealMeasure()) > 0 {
            newProject.numSpaces = Int(round((newProject.run.getRealMeasure()) / (newProject.spindleWidth.getRealMeasure() + newProject.maxSpace.getRealMeasure()) + 1))
        }
        newProject.numSpindles = newProject.numSpaces - 1
        if newProject.numSpaces > 0 {
            newProject.between.update((newProject.run.getRealMeasure() - (Double(newProject.numSpindles) * newProject.spindleWidth.getRealMeasure())) / Double(newProject.numSpaces))
        }
        newProject.onCenter.update(newProject.spindleWidth.getRealMeasure() + newProject.between.getRealMeasure())
    }
    
    func riseChange(newValue: Measurement) {
        newProject.rise.update(newValue)
        let newAngle = abs(asin(newProject.rise.getRealMeasure()/newProject.postSpacing.getRealMeasure())) * 180 /  M_PI
        newProject.angle = newAngle > 0 ? (newAngle > 75 ? 75: newAngle): 0
        if(newProject.angle < 90 && newProject.angle > 0) {
            newProject.run.update(sqrt(pow(newProject.postSpacing.getRealMeasure(),2) - pow(newProject.rise.getRealMeasure(), 2)))
            if (newProject.spindleWidth.getRealMeasure() + newProject.maxSpace.getRealMeasure()) > 0 {
                newProject.numSpaces = Int(round((newProject.run.getRealMeasure()) / (newProject.spindleWidth.getRealMeasure() + newProject.maxSpace.getRealMeasure()) + 1))
            }
            newProject.numSpindles = newProject.numSpaces - 1
            if newProject.numSpaces > 0 {
                newProject.between.update((newProject.run.getRealMeasure() - (Double(newProject.numSpindles) * newProject.spindleWidth.getRealMeasure())) / Double(newProject.numSpaces))
            }
            newProject.onCenter.update(newProject.spindleWidth.getRealMeasure() + newProject.between.getRealMeasure())
        }
    }
    
    func runChange(newValue: Measurement) {
        newProject.run.update(newValue)
        if(newProject.run.getRealMeasure() > newProject.postSpacing.getRealMeasure()){
            newProject.postSpacing.update(newProject.run.getRealMeasure())
        }
        let newAngle = abs(acos(newProject.run.getRealMeasure()/newProject.postSpacing.getRealMeasure())) * 180 /  M_PI
        newProject.angle =  newAngle > 0 ? (newAngle > 75 ? 75: newAngle): 0
        newProject.rise.update(sqrt(pow(newProject.postSpacing.getRealMeasure(), 2) - pow(newProject.run.getRealMeasure(), 2)))
        if (newProject.spindleWidth.getRealMeasure() + newProject.maxSpace.getRealMeasure()) > 0 {
            newProject.numSpaces = Int(round((newProject.run.getRealMeasure()) / (newProject.spindleWidth.getRealMeasure() + newProject.maxSpace.getRealMeasure()) + 1))
        }
        newProject.numSpindles = newProject.numSpaces - 1
        if newProject.numSpaces > 0 {
            newProject.between.update((newProject.run.getRealMeasure() - (Double(newProject.numSpindles) * newProject.spindleWidth.getRealMeasure())) / Double(newProject.numSpaces))
        }
        newProject.onCenter.update(newProject.spindleWidth.getRealMeasure() + newProject.between.getRealMeasure())
    }
}


