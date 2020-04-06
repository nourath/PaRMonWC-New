//
//  PhysicianLoginViewController.swift
//  PaRMonWC
//
//  Created by Noura Althenayan on 11/03/2020.
//  Copyright © 2020 Noura. All rights reserved.
//

import UIKit
import FirebaseAuth

class PhysicianLoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        self.dismissKeyboard()
    }
    
    func setUpElements(){
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
            //validate text fields
            
            
            //clean version of text fields
            let email = emailTextField!.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //signing in
            Auth.auth().signIn(withEmail: email, password: password){
                (result, error) in

                if error != nil{
                    self.errorLabel.text = error!.localizedDescription
                    self.errorLabel.alpha = 1
            }
                else {
                    self.transitionToHome()
                }
            }
    }
    
  func transitionToHome(){
       let physicianHomeViewController =  storyboard?.instantiateViewController(identifier:Constants.Storyboard.physicianHomeViewController)
       
       view.window?.rootViewController = physicianHomeViewController
       view.window?.makeKeyAndVisible()
       
   }
} //end of physician login
