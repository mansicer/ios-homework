//
//  ViewController.swift
//  HW3-Calculator
//
//  Created by 张福翔 on 2020/10/26.
//

import UIKit

class ViewController: UIViewController {
    var model = CalculatorModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var acBtn: RoundedButton!
    
    func flushDisplay() {
        label.text = model.text
        if model.finished {
            acBtn.setTitle("AC", for: .normal)
        }
        else {
            acBtn.setTitle("C", for: .normal)
        }
    }
    
    @IBAction func touchXSquare(_ sender: Any) {
        model.square()
        flushDisplay()
    }
    @IBAction func touchXCube(_ sender: Any) {
        model.cube()
        flushDisplay()
    }
    @IBAction func touchSquareRoot(_ sender: Any) {
        model.squareRoot()
        flushDisplay()
    }
    @IBAction func touchCubeRoot(_ sender: Any) {
        model.cubeRoot()
        flushDisplay()
    }
    @IBAction func touchFactorial(_ sender: Any) {
        model.factorial()
        flushDisplay()
    }
    @IBAction func touchLog(_ sender: Any) {
        model.calLog()
        flushDisplay()
    }
    @IBAction func touchSin(_ sender: Any) {
        model.calSin()
        flushDisplay()
    }
    @IBAction func touchCos(_ sender: Any) {
        model.calCos()
        flushDisplay()
    }
    @IBAction func touchTan(_ sender: Any) {
        model.calTan()
        flushDisplay()
    }
    @IBAction func touchPi(_ sender: Any) {
        model.pressPi()
        flushDisplay()
    }
    
    
    @IBAction func touchAC(_ sender: Any) {
        model.pressAC()
        flushDisplay()
    }
    @IBAction func touchPercent(_ sender: Any) {
        model.addPercent()
        flushDisplay()
    }
    @IBAction func touchNeg(_ sender: Any) {
        model.addNeg()
        flushDisplay()
    }
    
    @IBAction func touchPlus(_ sender: Any) {
        model.addOperation(op: .PLUS)
        flushDisplay()
    }
    @IBAction func touchMinus(_ sender: Any) {
        model.addOperation(op: .MINUS)
        flushDisplay()
    }
    @IBAction func touchStar(_ sender: Any) {
        model.addOperation(op: .STAR)
        flushDisplay()
    }
    @IBAction func touchDiv(_ sender: Any) {
        model.addOperation(op: .DIV)
        flushDisplay()
    }
    @IBAction func touchEqual(_ sender: Any) {
        model.calculate()
        flushDisplay()
    }
    
    @IBAction func touchNum0(_ sender: Any) {
        model.addNumber(num: 0)
        flushDisplay()
    }
    @IBAction func touchNum1(_ sender: Any) {
        model.addNumber(num: 1)
        flushDisplay()
    }
    @IBAction func touchNum2(_ sender: Any) {
        model.addNumber(num: 2)
        flushDisplay()
    }
    @IBAction func touchNum3(_ sender: Any) {
        model.addNumber(num: 3)
        flushDisplay()
    }
    @IBAction func tourchNum4(_ sender: Any) {
        model.addNumber(num: 4)
        flushDisplay()
    }
    @IBAction func tourchNum5(_ sender: Any) {
        model.addNumber(num: 5)
        flushDisplay()
    }
    @IBAction func tourchNum6(_ sender: Any) {
        model.addNumber(num: 6)
        flushDisplay()
    }
    @IBAction func touchNum7(_ sender: Any) {
        model.addNumber(num: 7)
        flushDisplay()
    }
    @IBAction func touchNum8(_ sender: Any) {
        model.addNumber(num: 8)
        flushDisplay()
    }
    @IBAction func touchNum9(_ sender: Any) {
        model.addNumber(num: 9)
        flushDisplay()
    }
    @IBAction func touchDot(_ sender: Any) {
        model.addDot()
        flushDisplay()
    }
}

