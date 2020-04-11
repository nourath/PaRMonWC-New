//
//  PatientIntroViewController.swift
//  PaRMonWC
//
//  Created by Noura Althenayan on 11/03/2020.
//  Copyright © 2020 Noura. All rights reserved.
//

import UIKit

class PatientIntroViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
            super.viewDidLoad()
            
            setUpElements()
        }
    
       func setUpElements(){
           Utilities.styleFilledButton(signUpButton)
           Utilities.styleHollowButton(loginButton)
       }
    }




