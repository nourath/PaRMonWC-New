//
//  PatientSignUpViewController.swift
//  PaRMonWC
//
//  Created by Noura Althenayan on 11/03/2020.
//  Copyright © 2020 Noura. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class PatientSignUpViewController: UIViewController {
    
    @IBOutlet weak var fNameTextField: UITextField!
    @IBOutlet weak var lNameTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var dobTextField: UITextField!
    @IBOutlet weak var diagnosisYearTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        self.dismissKeyboard()

    }

        func setUpElements(){
            errorLabel.alpha = 0 //hide error label
            //style elements using utilities class
            Utilities.styleTextField(fNameTextField)
            Utilities.styleTextField(lNameTextField)
            Utilities.styleTextField(genderTextField)
            Utilities.styleTextField(dobTextField)
            Utilities.styleTextField(diagnosisYearTextField)
            Utilities.styleTextField(phoneTextField)
            Utilities.styleTextField(emailTextField)
            Utilities.styleTextField(passwordTextField)
            Utilities.styleFilledButton(signUpButton)
        }
        
        // check fields and validate correctness if correct = nil, otherwise = error.
        func validateFields() -> String? {
            
            //check if filled or empty
            if  fNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                genderTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                dobTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                diagnosisYearTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                phoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
                {
                    return "Please fill out all the fields."
            }
        
            let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if Utilities.isPasswordValid(cleanedPassword) == false {
                //password not secure enough
                return "Please use at least 8 characters, contains a special character and a number."
            }
            
            return nil
        }
        
    @IBAction func returnnilsignUpButtonTapped(_ sender: Any) {
    
    //validate fields
            let error = validateFields()
            
            if error != nil{
                //error msg
                showError(error!)
        }

                else {
                    
                    //create clean version of data (no white spaces)
                    let fname = fNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    let lname = lNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    let gender = genderTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    let dob = dobTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    let diagnosisYear = diagnosisYearTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    let phone = phoneTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)


                    //create user
                    Auth.auth().createUser(withEmail: email, password: password) {
                                   (result, err) in
                                   
                                   //check errors
                    if  err != nil {
                                       //error in user creation
                                       self.showError("Error creating user")
                                }
                 
                    else{
                                    
                        // user was successfully created, storing info..

                        let db = Firestore.firestore()
                        db.collection("patients").addDocument(data:  ["fname":fname, "lname":lname, "gender":gender, "dob":dob, "diagnosisYear":diagnosisYear, "phone":phone, "uid":result!.user.uid]){ (error) in
                            
                            if error != nil {
                                        //show error msg
                                        self.showError("Could not store user's data")
                                    }
                                }
                                // transfer to home screen
                                self.transitionToHome()
                                }
            
            }
                }
            }
                        
                       func showError(_ message:String) {
                        
                        errorLabel.text = message
                        errorLabel.alpha = 1
                            
                            }
                        
               func transitionToHome(){
                             let patientHomeViewController =  storyboard?.instantiateViewController(identifier:Constants.Storyboard.patientHomeViewController) as? PatientHomeViewController
                             
                             view.window?.rootViewController = patientHomeViewController
                             view.window?.makeKeyAndVisible()
                             
                         }
        
    } //end of patient registeration

    
