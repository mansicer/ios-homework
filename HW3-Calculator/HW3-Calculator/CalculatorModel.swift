//
//  CalculatorModel.swift
//  HW3-Calculator
//
//  Created by 张福翔 on 2020/11/1.
//

import Foundation

enum Operation {
    case NONE, PLUS, MINUS, STAR, DIV
}

class CalculatorModel {
    var text = "0"
    var finished = true
    var lastOperator: Double? = 0.0
    var lastOperation = Operation.NONE
    
    func isInteger(num: Double) -> Bool {
        return Double(Int(num)) == num
    }
    func isInteger(str: String) -> Bool {
        return Int(str) != nil
    }
    func checkCurrentText() -> Double? {
        if Double(text) == nil {
            return nil
        }
        else {
            return Double(text)
        }
    }
    
    func checkFinished() {
        if finished {
            modifyText(num: 0)
            finished = false
        }
        if text == "Error" {
            modifyText(num: 0)
        }
    }
    func modifyText(str: String) {
        if isInteger(str: str) {
            text = "\(Int(str)!)"
        }
        else {
            text = str
        }
    }
    func modifyText(num: Double) {
        if isInteger(num: num) {
            text = "\(Int(num))"
        }
        else {
            text = "\(num)"
        }
    }
    
    
    func addNumber(num: Int) {
        checkFinished()
        modifyText(str: text + String(num))
    }
    func addDot() {
        checkFinished()
        text += "."
    }
    
    func addOperation(op: Operation) {
        lastOperator = Double(text)
        lastOperation = op
        finished = true
    }
    
    
    func pressAC() {
        if finished {
            lastOperation = .NONE
            modifyText(str: "0")
        }
        else {
            modifyText(str: "0")
            finished = true
        }
    }
    func pressPi() {
        modifyText(num: Double.pi)
    }
    
    // function of calculation
    func calculate() {
        if lastOperator == nil {
            text = "Error"
            finished = true
            return
        }
        let right = checkCurrentText()
        if right == nil {
            finished = true
            return
        }
        var result = 0.0
        switch lastOperation {
        case .PLUS:
            result = lastOperator! + right!
        case .MINUS:
            result = lastOperator! - right!
        case .STAR:
            result = lastOperator! * right!
        case .DIV:
            if right == 0 {
                text = "Error"
                finished = true
                return
            }
            result = lastOperator! / right!
        case .NONE:
            result = right!
        }
        modifyText(num: result)
        finished = true
    }
    func addPercent() {
        let val = checkCurrentText()
        if val == nil {
            text = "Error"
        }
        else {
            modifyText(num: val! / 100)
        }
    }
    func addNeg() {
        let val = checkCurrentText()
        if val == nil {
            text = "Error"
        }
        else {
            modifyText(num: -val!)
        }
    }
    func square() {
        let val = checkCurrentText()
        if val == nil {
            text = "Error"
        }
        else {
            modifyText(num: pow(val!, 2))
        }
    }
    func cube() {
        let val = checkCurrentText()
        if val == nil {
            text = "Error"
        }
        else {
            modifyText(num: pow(val!, 3))
        }
    }
    func squareRoot() {
        let val = checkCurrentText()
        if val == nil {
            text = "Error"
        }
        else {
            modifyText(num: sqrt(val!))
        }
    }
    func cubeRoot() {
        let val = checkCurrentText()
        if val == nil {
            text = "Error"
        }
        else {
            modifyText(num: pow(val!, 1.0/3))
        }
    }
    func factorial() {
        let val = checkCurrentText()
        if val == nil {
            text = "Error"
        }
        else {
            if val! == Double(Int(val!)) {
                let currentNum = Int(val!)
                var fact = currentNum;
                for i in 1..<currentNum {
                    fact *= i
                }
                modifyText(num: Double(fact))
            }
            else {
                text = "Error"
            }
        }
    }
    func calLog() {
        let val = checkCurrentText()
        if val == nil {
            text = "Error"
        }
        else {
            if val! > 0 {
                modifyText(num: log(val!))
            }
            else {
                text = "Error"
            }
        }
    }
    func calSin() {
        let val = checkCurrentText()
        if val == nil {
            text = "Error"
        }
        else {
            modifyText(num: sin(val!))
        }
    }
    func calCos() {
        let val = checkCurrentText()
        if val == nil {
            text = "Error"
        }
        else {
            modifyText(num: cos(val!))
        }
    }
    func calTan() {
        let val = checkCurrentText()
        if val == nil {
            text = "Error"
        }
        else {
            modifyText(num: -tan(val!))
        }
    }
}
