//
//  ButtonBorder.swift
//  BrainGame
//
//  Created by Marko Dehmel-Dethloff on 24.02.20.
//  Copyright © 2020 Marko Dehmel-Dethloff. All rights reserved.
//

import UIKit

// Fügt den Buttons Einstellmöglichkeiten bezüglich der Ränder hinzu
@IBDesignable
class ButtonBorder: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
}
