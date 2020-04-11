//
//  PaRMonWC
//
//  Author: Shoaa Alqarni
//  Copyright © 2020 Noura. All rights reserved.
//

import Foundation
import Firebase

struct Status {
 
    
  let key: String
  let mood: String
  let tremor: String
  let date: String
  let pid: String
  let ref: DatabaseReference?
  
  
    init(mood: String, tremor: String, date: String, pid: String, key: String = "") {
    self.key = key
    self.mood = mood
    self.tremor = tremor
    self.date = date
    self.pid = pid
    self.ref = nil
        
  }
  
  init(snapshot: DataSnapshot) {
    key = snapshot.key
    let snapshotValue = snapshot.value as! [String: AnyObject]
    mood = snapshotValue["mood"] as! String
    tremor = snapshotValue["tremor"] as! String
    date = snapshotValue["date"] as! String
    if snapshotValue["uid"] == nil{
        pid = "n/a"
    }
    else
    {
        pid = snapshotValue["uid"] as! String
    }
    ref = snapshot.ref
  }
    
  func toAnyObject() -> Any {
    return [
        "mood": mood,
      "tremor": tremor,
      "date": date,
      "uid": pid
    ]
  }
  
}
