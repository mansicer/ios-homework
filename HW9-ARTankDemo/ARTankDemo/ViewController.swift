//
//  ViewController.swift
//  ARTankDemo
//
//  Created by 张福翔 on 2020/12/21.
//

import UIKit
import RealityKit

class ViewController: UIViewController {
    
    @IBOutlet weak var arView: ARView!
    var tankAnchor: TinyToyTank._TinyToyTank?
    var isActionPlaying = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the "Box" scene from the "Experience" Reality File
        tankAnchor = try! TinyToyTank.load_TinyToyTank();
        tankAnchor!.cannon?.setParent(tankAnchor!.tank, preservingWorldTransform: true)
        tankAnchor!.actions.actionComplete.onAction = { _ in
            self.isActionPlaying = false
        }
        // Add the box anchor to the scene
        arView.scene.anchors.append(tankAnchor!)
    }
    
    @IBAction func touchTankLeft(_ sender: Any) {
        if isActionPlaying {
            return
        } else {
            tankAnchor!.notifications.tankLeft.post()
            isActionPlaying = true
        }
    }
    
    @IBAction func touchTankForward(_ sender: Any) {
        if isActionPlaying {
            return
        } else {
            tankAnchor!.notifications.tankForward.post()
            isActionPlaying = true
        }
    }
    
    @IBAction func touchTankRight(_ sender: Any) {
        if isActionPlaying {
            return
        } else {
            tankAnchor!.notifications.tankRight.post()
            isActionPlaying = true
        }
    }
    
    @IBAction func touchCannonFire(_ sender: Any) {
        if isActionPlaying {
            return
        } else {
            tankAnchor!.notifications.cannonFire.post()
            isActionPlaying = true
        }
    }
    
    @IBAction func torchTurretLeft(_ sender: Any) {
        if isActionPlaying {
            return
        } else {
            tankAnchor!.notifications.turretLeft.post()
            isActionPlaying = true
        }
    }
    
    @IBAction func touchTurretRight(_ sender: Any) {
        if isActionPlaying {
            return
        } else {
            tankAnchor!.notifications.turretRight.post()
            isActionPlaying = true
        }
    }
}
