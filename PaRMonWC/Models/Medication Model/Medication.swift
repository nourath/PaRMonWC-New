//
//  Medication.swift
//  PaRMonWC
//
//  Author: Shoaa Alqarni
//  Copyright © 2020 Noura. All rights reserved.
//

import Foundation
import Firebase

struct Medication {
  
  let key: String
  let pid: String
  let medName: String
  let dose: String
  let time: String
  let notes: String
  let ref: DatabaseReference?
  
  
    init(pid: String, name: String, dose: String, time: String, notes: String, key: String = "") {
    self.key = key
    self.pid = pid
    self.medName = name
    self.dose = dose
    self.time = time
    self.notes = notes
    self.ref = nil
  }
  
  init(snapshot: DataSnapshot) {
    key = snapshot.key
    let snapshotValue = snapshot.value as! [String: AnyObject]
    pid = snapshotValue["pid"] as! String
    medName = snapshotValue["medName"] as! String
    dose = snapshotValue["dose"] as! String
    time = snapshotValue["time"] as! String
    notes = snapshotValue["notes"] as! String
    ref = snapshot.ref
  }
  
  func toAnyObject() -> Any {
    return [
        "pid": pid,
      "medName": medName,
      "dose": dose,
      "time": time,
      "notes": notes
    ]
  }
  
}
