//
//  Medication.swift
//  PaRMonWC
//
//  Author: Shoaa Alqarni
//  Copyright © 2020 Noura. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class PhysicianProfileViewController: UIViewController {

    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var hospitalLabel: UILabel!
    @IBOutlet weak var specialityLabel: UILabel!
    @IBOutlet weak var wordIDLabel: UILabel!
    
    @IBOutlet weak var updateProfileBtn: UIButton!
    
    var fname: String = ""
    var lname: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPhysicianInfo()

}

    func getPhysicianInfo(){
          
            if let userId = Auth.auth().currentUser?.uid {
            
            let db = Firestore.firestore()
            db.collection("physicians").getDocuments { (snapshot, err) in
               if let err = err {
                   print("Error getting patient's name: \(err)")
               } else {

                if let currentUserDoc = snapshot?.documents.first(where: {($0["uid"] as? String) == userId }) {
                    self.fname = currentUserDoc["fname"] as! String
                    self.lname = currentUserDoc["lname"] as! String
                    self.fullNameLabel.text = self.fname + " " + self.lname
                    self.genderLabel.text = currentUserDoc["gender"] as? String
                    self.hospitalLabel.text = currentUserDoc["hospital"] as? String
                    self.specialityLabel.text = currentUserDoc["speciality"] as? String
                    self.wordIDLabel.text = currentUserDoc["workID"] as? String
                    }
                }
            }
        }

    }
    
    @IBAction func onClickedUpdateProfileBtn(_ sender: Any)
    {
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
                alert.addTextField { (hospitalTextField) in
                    hospitalTextField.text = self.hospitalLabel.text
                    hospitalTextField.placeholder = "Hospital:"
                }
                alert.addTextField { (specialityTextField) in
                   specialityTextField.text = self.specialityLabel.text
                   specialityTextField.placeholder = "Speciality:"
                }
                alert.addTextField { (workIDTextField) in
                   workIDTextField.text = self.wordIDLabel.text
                   workIDTextField.placeholder = "Work ID:"
                }
        
                let updateAction = UIAlertAction(title: "Update",
                                               style: .default) { action in
                  let fnameTextField = alert.textFields![0]
                  let lnameTextField = alert.textFields![1]
                  let genderTextField = alert.textFields![2]
                  let hospitalTextField = alert.textFields![3]
                  let specialityTextField = alert.textFields![4]
                  let workIDTextField = alert.textFields![5]
                                                
//                  let medication = Medication(pid: self.patient.uid,
//                    name: medNameTextField.text!,
//                   dose: doseTextField.text!,
//                   time: timeTextField.text!,
//                    notes: notesTextField.text!)
                  
                  
                  
                                                
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
                                                         "hospital": hospitalTextField.text!,
                                                         "speciality": specialityTextField.text!,
                                                         "wordID": workIDTextField.text!
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
