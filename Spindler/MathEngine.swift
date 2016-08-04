//
//  MathEngine.swift
//  Spindler
//
//  Created by Scott Johnson on 5/21/16.
//  Copyright © 2016 Scott Johnson. All rights reserved.
//

import Foundation

class MathEngine {
    var newProject: Project
    //var metric: Bool
    
    init(){
        self.newProject = Project()
        //self.true = false
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
        case 1: return newProject.postSpacing.getMetricMeasure()
        case 2: return newProject.spindleWidth.getMetricMeasure()
        case 3: return newProject.maxSpace.getMetricMeasure()
        case 4: return Double(newProject.numSpaces)
        case 5: return Double(newProject.numSpindles)
        case 6: return newProject.onCenter.getMetricMeasure()
        case 7: return newProject.between.getMetricMeasure()
        case 8: return newProject.angle
        case 9: return newProject.rise.getMetricMeasure()
        case 10: return newProject.run.getMetricMeasure()
        default: return newProject.postSpacing.getMetricMeasure()
        }
    }
    
    func postChange(newValue: Measurement) {
        newProject.postSpacing.update(newValue)
        
        newProject.numSpaces = Int((newProject.postSpacing.getMetricMeasure()) / (newProject.spindleWidth.getMetricMeasure() + newProject.maxSpace.getMetricMeasure()) + 1)

        
        newProject.numSpindles = newProject.numSpaces - 1
        newProject.between.update((newProject.postSpacing.getMetricMeasure() - (Double(newProject.numSpindles) * newProject.spindleWidth.getMetricMeasure())) / Double(newProject.numSpaces), metricInput: true)
        newProject.onCenter.update(newProject.spindleWidth.getMetricMeasure() + newProject.between.getMetricMeasure(), metricInput: true)
        newProject.rise.update(newProject.postSpacing.getMetricMeasure() * abs(sin(newProject.angle)), metricInput: true)
        newProject.run.update(newProject.postSpacing.getMetricMeasure() * abs(cos(newProject.angle)), metricInput: true)
    }
    
    func spindleWidthChange(newValue: Measurement) {
        newProject.spindleWidth.update(newValue)
        newProject.numSpaces = Int((newProject.postSpacing.getMetricMeasure()) / (newProject.spindleWidth.getMetricMeasure() + newProject.maxSpace.getMetricMeasure()) + 1)
        newProject.numSpindles = newProject.numSpaces - 1
        if newProject.numSpaces > 0 {
            newProject.between.update((newProject.postSpacing.getMetricMeasure() - (Double(newProject.numSpindles) * newProject.spindleWidth.getMetricMeasure())) / Double(newProject.numSpaces), metricInput: true)
        }
        newProject.onCenter.update(newProject.spindleWidth.getMetricMeasure() + newProject.between.getMetricMeasure(), metricInput: true)
    }
    
    func maxSpaceChange(newValue: Measurement) {
        newProject.maxSpace.update(newValue)
        if (newProject.spindleWidth.getMetricMeasure() + newProject.maxSpace.getMetricMeasure()) > 0 {
            newProject.numSpaces = Int((newProject.postSpacing.getMetricMeasure()) / (newProject.spindleWidth.getMetricMeasure() + newProject.maxSpace.getMetricMeasure()) + 1)
        }
        newProject.numSpindles = newProject.numSpaces - 1
        newProject.between.update((newProject.postSpacing.getMetricMeasure() - (Double(newProject.numSpindles) * newProject.spindleWidth.getMetricMeasure())) / Double(newProject.numSpaces), metricInput: true)
        newProject.onCenter.update(newProject.spindleWidth.getMetricMeasure() + newProject.between.getMetricMeasure(), metricInput: true)
    }
    
    func numSpacesChange(newValue: Double) {
        newProject.numSpaces = Int(newValue) >= 1 ? Int(newValue) : 1
        newProject.numSpindles = newProject.numSpaces - 1
        if newProject.numSpaces > 0 {
            newProject.between.update((newProject.postSpacing.getMetricMeasure() - (Double(newProject.numSpindles) * newProject.spindleWidth.getMetricMeasure())) / Double(newProject.numSpaces), metricInput: true)
        }
        newProject.onCenter.update(newProject.spindleWidth.getMetricMeasure() + newProject.between.getMetricMeasure(), metricInput: true)
    }
    
    func numSpindlesChange(newValue: Double) {
        newProject.numSpindles = Int(newValue) >= 0 ? Int(newValue) : 0
        newProject.numSpaces = newProject.numSpindles + 1
        if newProject.numSpaces > 0 {
            newProject.between.update((newProject.postSpacing.getMetricMeasure() - (Double(newProject.numSpindles) * newProject.spindleWidth.getMetricMeasure())) / Double(newProject.numSpaces), metricInput: true)
        }
        newProject.onCenter.update(newProject.spindleWidth.getMetricMeasure() + newProject.between.getMetricMeasure(), metricInput: true)
    }
    
    func onCenterChange(newValue: Measurement) {
        newProject.onCenter.update(newValue)
        newProject.between.update(newProject.onCenter.getMetricMeasure() - newProject.spindleWidth.getMetricMeasure(), metricInput: true)
        if (newProject.between.getMetricMeasure() + newProject.spindleWidth.getMetricMeasure()) > 0 {
            newProject.numSpaces = Int((newProject.postSpacing.getMetricMeasure() + newProject.spindleWidth.getMetricMeasure())/(newProject.between.getMetricMeasure() + newProject.spindleWidth.getMetricMeasure()))
        }
        newProject.numSpindles = newProject.numSpaces + 1
        if(newProject.between.getMetricMeasure() > newProject.maxSpace.getMetricMeasure()){
            newProject.maxSpace = newProject.between
        }
    }
    
    func betweenChange(newValue: Measurement) {
        newProject.between.update(newValue)
        newProject.onCenter.update(newProject.between.getMetricMeasure() + newProject.spindleWidth.getMetricMeasure(), metricInput: true)
        if (newProject.between.getMetricMeasure() + newProject.spindleWidth.getMetricMeasure()) > 0 {
            newProject.numSpaces = Int((newProject.postSpacing.getMetricMeasure()
                + newProject.spindleWidth.getMetricMeasure())/(newProject.between.getMetricMeasure() + newProject.spindleWidth.getMetricMeasure()))
        }
        newProject.numSpindles = newProject.numSpaces + 1
    }
    
    func angleChange(newValue: Double) {
        newProject.angle =  newValue > 0 ? (newValue > 75 ? 75: newValue): 0
        newProject.rise.update(newProject.postSpacing.getMetricMeasure() * abs(sin(newProject.angle * M_PI / 180)), metricInput: true)
        newProject.run.update(newProject.postSpacing.getMetricMeasure() * abs(cos(newProject.angle * M_PI / 180)), metricInput: true)
        if (newProject.spindleWidth.getMetricMeasure() + newProject.maxSpace.getMetricMeasure()) > 0 {
            newProject.numSpaces = Int((newProject.run.getMetricMeasure()) / (newProject.spindleWidth.getMetricMeasure() + newProject.maxSpace.getMetricMeasure()) + 1)
        }
        newProject.numSpindles = newProject.numSpaces - 1
        if newProject.numSpaces > 0 {
            newProject.between.update((newProject.run.getMetricMeasure() - (Double(newProject.numSpindles) * newProject.spindleWidth.getMetricMeasure())) / Double(newProject.numSpaces), metricInput: true)
        }
        newProject.onCenter.update(newProject.spindleWidth.getMetricMeasure() + newProject.between.getMetricMeasure(), metricInput: true)
    }
    
    func riseChange(newValue: Measurement) {
        newProject.rise.update(newValue)
        let newAngle = abs(asin(newProject.rise.getMetricMeasure()/newProject.postSpacing.getMetricMeasure())) * 180 /  M_PI
        newProject.angle = newAngle > 0 ? (newAngle > 75 ? 75: newAngle): 0
        if(newProject.angle < 90 && newProject.angle > 0) {
            newProject.run.update(sqrt(pow(newProject.postSpacing.getMetricMeasure(),2) - pow(newProject.rise.getMetricMeasure(), 2)), metricInput: true)
            if (newProject.spindleWidth.getMetricMeasure() + newProject.maxSpace.getMetricMeasure()) > 0 {
                newProject.numSpaces = Int((newProject.run.getMetricMeasure()) / (newProject.spindleWidth.getMetricMeasure() + newProject.maxSpace.getMetricMeasure()) + 1)
            }
            newProject.numSpindles = newProject.numSpaces - 1
            if newProject.numSpaces > 0 {
                newProject.between.update((newProject.run.getMetricMeasure() - (Double(newProject.numSpindles) * newProject.spindleWidth.getMetricMeasure())) / Double(newProject.numSpaces), metricInput: true)
            }
            newProject.onCenter.update(newProject.spindleWidth.getMetricMeasure() + newProject.between.getMetricMeasure(), metricInput: true)
        }
    }
    
    func runChange(newValue: Measurement) {
        newProject.run.update(newValue)
        if(newProject.run.getMetricMeasure() > newProject.postSpacing.getMetricMeasure()){
            newProject.postSpacing.update(newProject.run)
        }
        let newAngle = abs(acos(newProject.run.getMetricMeasure()/newProject.postSpacing.getMetricMeasure())) * 180 /  M_PI
        newProject.angle =  newAngle > 0 ? (newAngle > 75 ? 75: newAngle): 0
        newProject.rise.update(sqrt(pow(newProject.postSpacing.getMetricMeasure(), 2) - pow(newProject.run.getMetricMeasure(), 2)), metricInput: true)
        if (newProject.spindleWidth.getMetricMeasure() + newProject.maxSpace.getMetricMeasure()) > 0 {
            newProject.numSpaces = Int((newProject.run.getMetricMeasure()) / (newProject.spindleWidth.getMetricMeasure() + newProject.maxSpace.getMetricMeasure()) + 1)
        }
        newProject.numSpindles = newProject.numSpaces - 1
        if newProject.numSpaces > 0 {
            newProject.between.update((newProject.run.getMetricMeasure() - (Double(newProject.numSpindles) * newProject.spindleWidth.getMetricMeasure())) / Double(newProject.numSpaces), metricInput: true)
        }
        newProject.onCenter.update(newProject.spindleWidth.getMetricMeasure() + newProject.between.getMetricMeasure(), metricInput: true)
    }
}


