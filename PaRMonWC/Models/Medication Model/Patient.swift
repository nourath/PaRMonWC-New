//
//  Medication.swift
//  PaRMonWC
//
//  Author: Shoaa Alqarni
//  Copyright © 2020 Noura. All rights reserved.
//

import Foundation
import Firebase

struct Patient {
  
  let key: String
  let fname: String
  let lname: String
  let gender: String
  let phone: String
  let dob: String
  let diagnosisYear: String
  let uid: String
  let ref: DocumentReference?
  
  
    init(fname: String, lname: String, gender: String, phone: String, dob: String, diagnosisYear: String, uid: String, key: String = "") {
    self.key = key
    self.fname = fname
    self.lname = lname
    self.gender = gender
    self.phone = phone
    self.dob = dob
    self.diagnosisYear = diagnosisYear
    self.uid = uid
    self.ref = nil
  }
  
  init(snapshot: QueryDocumentSnapshot) {
    key = snapshot.documentID
    let snapshotValue = snapshot.data() as! [String: AnyObject]
    fname = snapshotValue["fname"] as! String
    lname = snapshotValue["lname"] as! String
    gender = snapshotValue["gender"] as! String
    phone = snapshotValue["phone"] as! String
    dob = snapshotValue["dob"] as! String
    diagnosisYear = snapshotValue["diagnosisYear"] as! String
    uid = snapshotValue["uid"] as! String
    ref = snapshot.reference
  }
  
  func toAnyObject() -> Any {
    return [
      "fname": fname,
      "lname": lname,
      "gender": gender,
      "phone": phone,
      "dob": dob,
      "diagnosisYear": diagnosisYear,
      "uid": uid
    ]
  }
  
}
