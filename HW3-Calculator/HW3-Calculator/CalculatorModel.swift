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
    var lastOperator = 0.0
    var lastOperation = Operation.NONE
    
    func isInteger(num: Double) -> Bool {
        return Double(Int(num)) == num
    }
    func isInteger(str: String) -> Bool {
        return Int(str) != nil
    }
    func checkFinished() {
        if finished {
            modifyText(str: "0")
            finished = false
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
    func addPercent() {
        checkFinished()
        let num = Double(text)!
        modifyText(num: num / 100)
    }
    func addNeg() {
        checkFinished()
        let num = Double(text)!
        modifyText(num: -num)
    }
    
    func addOperation(op: Operation) {
        lastOperator = Double(text)!
        lastOperation = op
        finished = true
    }
    func calculate() {
        var result = 0.0
        switch lastOperation {
        case .PLUS:
            result = lastOperator + (Double(text) ?? 0)
        case .MINUS:
            result = lastOperator - (Double(text) ?? 0)
        case .STAR:
            result = lastOperator * (Double(text) ?? 0)
        case .DIV:
            result = lastOperator / (Double(text) ?? 0)
        case .NONE:
            result = Double(text) ?? 0
        }
        modifyText(num: result)
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
}
