//
//  ViewController.swift
//  HW2
//
//  Created by 张福翔 on 2020/9/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet var myView: UIView!
    @IBOutlet weak var myButton: UIButton!
    var btnState = false
    
    @IBAction func buttonSwitch(_ sender: Any) {
        if (btnState) {
            btnState = false
            view.backgroundColor = UIColor.black
            myButton.setTitleColor(UIColor.white, for: .normal)
            myButton.setTitle("ON", for: .normal)
        }
        else {
            btnState = true
            view.backgroundColor = UIColor.white
            myButton.setTitleColor(UIColor.black, for: .normal)
            myButton.setTitle("OFF", for: .normal)
        }
    }
}

