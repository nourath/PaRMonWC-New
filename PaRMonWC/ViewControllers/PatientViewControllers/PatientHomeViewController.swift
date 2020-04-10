//
//  PatientHomeViewController.swift
//  PaRMonWC
//
//  Created by Noura Althenayan on 11/03/2020.
//  Copyright © 2020 Noura. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
class PatientHomeViewController: UIViewController {

    @IBOutlet weak var getNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        readArray()
    }
    
        func readArray(){
          
            if let userId = Auth.auth().currentUser?.uid {
            
            let db = Firestore.firestore()
            db.collection("patients").getDocuments { (snapshot, err) in
               if let err = err {
                   print("Error getting patient's name: \(err)")
               } else {

                if let currentUserDoc = snapshot?.documents.first(where: {($0["uid"] as? String) == userId }) {       let getName = currentUserDoc["fname"] as! String
                       self.getNameLabel.text = getName
                    }
                }
            }
        }

    }

}
