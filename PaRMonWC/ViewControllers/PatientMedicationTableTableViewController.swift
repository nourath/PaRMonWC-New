//
//  Medication.swift
//  PaRMonWC
//
//  Author: Shoaa Alqarni
//  Copyright © 2020 Noura. All rights reserved.
//


import UIKit
import Firebase

class PatientMedicationTableViewController: UITableViewController {
  
  // MARK: Properties

  var patient: Patient!
  var items: [Medication] = []
  var user: User!
//  var userCountBarButtonItem: UIBarButtonItem!
    
    // RealTime database References
  let rootRef =  Database.database().reference()
  let med = Database.database().reference(withPath: "medication")
  var medCounter = 1
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    if let userId = Auth.auth().currentUser?.uid{
    med.observe(.value, with: {
      snapshot in
        var newItems: [Medication] = []
        for item in snapshot.children {
            
          let medication = Medication(snapshot: item as! DataSnapshot)
            if medication.pid == self.patient.uid {
                newItems.append(medication)
            }
        }
      self.items = newItems
      self.tableView.reloadData()
    })
  }
    }
  
  override func setEditing(_ editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: true)
    tableView.setEditing(tableView.isEditing, animated: true)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if items.count == 0
    {
        self.title = patient.fname + " " + patient.lname + " has no medications yet"
    }else{
        self.title = patient.fname + " " + patient.lname + " Medications"
    }
    return items.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
    print(items.count)
    
//    else
//    {
        let medication = items[indexPath.row]
        cell.textLabel?.text = medication.medName
        cell.detailTextLabel?.text = "Dose: " + medication.dose + ", Time: "
                                      + medication.time + ", Notes: "
                                      + medication.notes
    //}
    
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
          let medItem = items[indexPath.row]
          medItem.ref?.setValue(nil)
          items.remove(at: indexPath.row)
          tableView.reloadData()
    }
  }

  
}
