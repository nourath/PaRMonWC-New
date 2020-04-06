//
//  Utilities.swift
//  PaRMonWC
//
//  Created by Noura Althenayan on 11/03/2020.
//  Copyright © 2020 Noura. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    
    static func styleTextField(_ textfield:UITextField) {
       
        textfield.textColor = UIColor.white
        // Create the bottom line
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        bottomLine.backgroundColor = UIColor.white.cgColor
        // Remove border on text field
        textfield.borderStyle = .none
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        
    }
    
    static func styleFilledButton(_ button:UIButton) {
        
        // Filled rounded corner style
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.init(red: 62/255, green: 178/255, blue: 240/255, alpha: 1)

    }
    
    static func styleHollowButton(_ button:UIButton) {
        // Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.init(red: 62/255, green: 178/255, blue: 240/255, alpha: 1)

    }
    
    static func styleErrorLabel(_ label: UILabel){
        label.backgroundColor = UIColor.white
    }
    
    static func isPasswordValid(_ password : String) -> Bool {
        //password pattern
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
}
