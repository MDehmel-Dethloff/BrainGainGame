//
//  ManualViewController.swift
//  BrainGame
//
//  Created by Marko Dehmel-Dethloff on 28.02.20.
//  Copyright © 2020 Marko Dehmel-Dethloff. All rights reserved.
//

import UIKit

class ManualViewController: UIViewController {
    
    // Initialisierungsmethode
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .dark
        }
    }
    
    // Wechselt zum Starbildschirm zurück
    @IBAction func SegueToStartAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
