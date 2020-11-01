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
    
    func addNumber(num: Int) {
        if finished {
            text = "0"
            finished = false
        }
        text += String(num)
        
        if Int(text) != nil {
            text = "\(Int(text)!)"
        }
        else {
            text = "\(Double(text)!)"
        }
    }
    func addDot() {
        if finished {
            text = "0"
        }
        text += "."
    }
    func addOperation(op: Operation) {
        lastOperator = Double(text) ?? 0
        lastOperation = op
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
        text = "\(result)"
        finished = true
    }
}
