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
    
    func flushDisplay() {
        label.text = model.text
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

