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

class PatientProfileController: UIViewController {

    @IBOutlet weak var fullNameLabel: UILabel!
    
    @IBOutlet weak var dobLabel: UILabel!
    
    @IBOutlet weak var genderLabel: UILabel!
    
    
    
    @IBOutlet weak var diagnosisYearLabel: UILabel!
    
    @IBOutlet weak var PhoneLabel: UILabel!
    
    
    var fname: String = ""
    var lname: String = ""
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPatientInfo()

}

    func getPatientInfo(){
          let tabVC = self.tabBarController as! PhysicianPatientsTabBarController
            if let userId = Auth.auth().currentUser?.uid {
            
            let db = Firestore.firestore()
            db.collection("patients").getDocuments { (snapshot, err) in
               if let err = err {
                   print("Error getting patient's name: \(err)")
               } else {

                if let currentUserDoc = snapshot?.documents.first(where: {($0["uid"] as? String) == tabVC.patient.uid }) {
                    self.fname = currentUserDoc["fname"] as! String
                    self.lname = currentUserDoc["lname"] as! String
                    self.fullNameLabel.text = self.fname + " " + self.lname
                    self.genderLabel.text = currentUserDoc["gender"] as? String
                    self.dobLabel.text = currentUserDoc["dob"] as? String
                    self.diagnosisYearLabel.text = currentUserDoc["diagnosisYear"] as? String
                    self.PhoneLabel.text = currentUserDoc["phone"] as? String
                    }
                }
            }
        }

    }
}
