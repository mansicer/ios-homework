//
//  ViewController.swift
//  HW1
//
//  Created by 张福翔 on 2020/9/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    var btnState: Bool = false
    @IBOutlet var myView: UIView!
    @IBOutlet weak var myButton: UIButton!
    
    @IBAction func buttonSwitch(_ sender: Any) {
        if (btnState) {
            btnState = false
            myView.backgroundColor = UIColor.black
            myButton.setTitleColor(UIColor.white, for: .normal)
            myButton.setTitle("ON", for: .normal)
        }
        else {
            btnState = true
            myView.backgroundColor = UIColor.white
            myButton.setTitleColor(UIColor.black, for: .normal)
            myButton.setTitle("OFF", for: .normal)
        }
    }

}
