//
//  PatientSettingsViewController.swift
//  PaRMonWC
//
//  Created by Noura Althenayan on 11/04/2020.
//  Copyright © 2020 Noura. All rights reserved.
//

import UIKit
import Firebase

class PatientSettingsViewController: UIViewController {

    @IBOutlet weak var fullNameLabel: UILabel!
    
    @IBOutlet weak var genderLabel: UILabel!
    
    @IBOutlet weak var dobLabel: UILabel!
    
    @IBOutlet weak var dyLabel: UILabel!
    
    @IBOutlet weak var phoneLabel: UILabel!
    
     @IBOutlet weak var editButton: UIButton!
    
    var fname: String = ""
    var lname: String = ""
       

    override func viewDidLoad() {
        super.viewDidLoad()

        getPatientInfo()
    }
    
    func getPatientInfo(){
             
               if let userId = Auth.auth().currentUser?.uid {
               
               let db = Firestore.firestore()
               db.collection("patients").getDocuments { (snapshot, err) in
                  if let err = err {
                      print("Error getting patient's name: \(err)")
                  } else {

                   if let currentUserDoc = snapshot?.documents.first(where: {($0["uid"] as? String) == userId }) {
                     print("We are here!")
                     self.fname = currentUserDoc["fname"] as! String
                       self.lname = currentUserDoc["lname"] as! String
                       self.fullNameLabel.text = self.fname + " " + self.lname
                       self.genderLabel.text = currentUserDoc["gender"] as? String
                       self.dyLabel.text = currentUserDoc["diagnosisYear"] as? String
                       self.dobLabel.text = currentUserDoc["dob"] as? String
                       self.phoneLabel.text = currentUserDoc["phone"] as? String
                       }
                   }
               }
           }

       }
     
    @IBAction func onClickEditBtn(_ sender: Any) {
        
        let editMedName = "Update profile information"
                          let alert = UIAlertController(title: editMedName,
                                                        message: nil,
                                                      preferredStyle: .alert)
                //          print(indexPath.row)
                        alert.addTextField { (fnameTextField) in
                            fnameTextField.text = self.fname
                            fnameTextField.placeholder = "First name"
                        }
                        alert.addTextField { (lnameTextField) in
                            lnameTextField.text = self.lname
                            lnameTextField.placeholder = "Last name:"
                        }
                        alert.addTextField { (genderTextField) in
                            genderTextField.text = self.genderLabel.text
                            genderTextField.placeholder = "Gender:"
                        }
                        alert.addTextField { (dobTextField) in
                            dobTextField.text = self.dobLabel.text
                            dobTextField.placeholder = "Hospital:"
                        }
                        alert.addTextField { (dyTextField) in
                           dyTextField.text = self.dyLabel.text
                           dyTextField.placeholder = "Speciality:"
                        }
                        alert.addTextField { (phoneTextField) in
                           phoneTextField.text = self.phoneLabel.text
                           phoneTextField.placeholder = "Work ID:"
                        }
                
                        let updateAction = UIAlertAction(title: "Update",
                                                       style: .default) { action in
                          let fnameTextField = alert.textFields![0]
                          let lnameTextField = alert.textFields![1]
                          let genderTextField = alert.textFields![2]
                          let dobTextField = alert.textFields![3]
                          let dyTextField = alert.textFields![4]
                          let phoneTextField = alert.textFields![5]
                                                        
                          
                          
                                                        
                          // Inserting to Database.
                            if let userId = Auth.auth().currentUser?.uid {

                                       let db = Firestore.firestore()
                                       db.collection("physicians").getDocuments { (snapshot, err) in
                                          if let err = err {
                                              print("Error getting patient's name: \(err)")
                                          } else {
                                            let currentUserDoc = snapshot?.documents.first(where: {($0["uid"] as? String) == userId })
                                            let frankDocRef = db.collection("Physicians").document(currentUserDoc?.documentID as! String)
                                            
                                            frankDocRef.setData(["fname": fnameTextField.text!,
                                                                 "lname": lnameTextField.text!,
                                                                 "gender": genderTextField.text!,
                                                                 "hospital": dobTextField.text!,
                                                                 "speciality": dyTextField.text!,
                                                                 "wordID": phoneTextField.text!
                                            ]);
                                           }
                                       }
                                   }
                        }
                        
                        let cancelAction = UIAlertAction(title: "Cancel",
                                                         style: .default)
                        
                        
                        alert.addAction(updateAction)
                        alert.addAction(cancelAction)
                        
                        present(alert, animated: true, completion: nil)
    }
}
