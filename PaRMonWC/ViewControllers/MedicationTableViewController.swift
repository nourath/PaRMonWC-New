//
//  Medication.swift
//  PaRMonWC
//
//  Author: Shoaa Alqarni
//  Copyright © 2020 Noura. All rights reserved.
//


import UIKit
import Firebase

class MedicationTableViewController: UITableViewController {
  
  // MARK: Properties

  var patient: Patient!
  var items: [Medication] = []
  var user: User!

    
  // MARK: RealTime database References
  let rootRef =  Database.database().reference()
  let med = Database.database().reference(withPath: "medication")
  var medCounter = 1
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let tabVC = self.tabBarController as! PhysicianPatientsTabBarController
    
    self.patient = tabVC.patient
    
    user = User(uid: "HDG12MLOQsY6AU6B3lhyogvZYAX2", email: "shoaa22n@gmail.com")
    
    // MARK:  Retrieve medications from database and preview them in the screen.
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
    
    let medication = items[indexPath.row]
    cell.textLabel?.text = medication.medName
    cell.detailTextLabel?.text = "Dose: " + medication.dose + ", Time: "
                                  + medication.time + ", Notes: "
                                  + medication.notes
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
  
    
  // MARK: Update Medication
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let cell = tableView.cellForRow(at: indexPath) {
        if cell.accessoryType == .detailDisclosureButton{
          let editMedName = "Update: " + cell.textLabel!.text!
          let alert = UIAlertController(title: editMedName,
                                        message: nil,
                                      preferredStyle: .alert)
            
        alert.addTextField { (medNameTextField) in
            medNameTextField.text = cell.textLabel!.text!
            medNameTextField.placeholder = "Name:"
        }
        alert.addTextField { (doseTextField) in
          doseTextField.text = self.items[indexPath.row].dose
            doseTextField.placeholder = "Dose:"
        }
        alert.addTextField { (timeTextField) in
          timeTextField.text = self.items[indexPath.row].time
            timeTextField.placeholder = "Time:"
        }
        alert.addTextField { (notesTextField) in
          notesTextField.text = self.items[indexPath.row].notes
            notesTextField.placeholder = "Notes:"
        }
        let updateAction = UIAlertAction(title: "Update",
                                       style: .default) { action in
          let medNameTextField = alert.textFields![0]
          let doseTextField = alert.textFields![1]
          let timeTextField = alert.textFields![2]
          let notesTextField = alert.textFields![3]
                                        
                                        let medication = Medication(pid: self.patient.uid,
            name: medNameTextField.text!,
           dose: doseTextField.text!,
           time: timeTextField.text!,
            notes: notesTextField.text!)
          
          
          self.items.append(medication)
          self.tableView.reloadData()
                                        
          // Inserting to Database.
          let medRef = self.med.child(String(self.items[indexPath.row].key))
        let values: [String: Any] = [ "pid": self.patient.uid,
                                      "medName": medNameTextField.text!.lowercased(),
        "dose": doseTextField.text!.lowercased(),
        "time": timeTextField.text!.lowercased(),
            "notes": notesTextField.text!.lowercased()]
            medRef.setValue(values)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        
        alert.addAction(updateAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
          
      } else {
        cell.accessoryType = .none
      }
      tableView.deselectRow(at: indexPath, animated: true)
    }
  }
    
    
    
    // MARK: Add Medication
  
  @IBAction func addButtonDidTouch(_ sender: AnyObject) {
    let medRef = self.rootRef.child("medication")
    let qRef = medRef.queryLimited(toLast: 1)

    qRef.observeSingleEvent(of: .value, with: { snapshot in
        for child in snapshot.children {
            let medItem = child as! DataSnapshot
          self.medCounter = Int(medItem.key) ?? 1
          self.medCounter = self.medCounter + 1
        }
    })
    
    let alert = UIAlertController(title: "Add Medication",
                                  message: nil,
                                  preferredStyle: .alert)
    
    alert.addTextField { (medNameTextField) in
        medNameTextField.text = ""
        medNameTextField.placeholder = "Name:"
    }
    alert.addTextField { (doseTextField) in
        doseTextField.text = ""
        doseTextField.placeholder = "Dose:"
    }
    alert.addTextField { (timeTextField) in
        timeTextField.text = ""
        timeTextField.placeholder = "Time:"
    }
    alert.addTextField { (notesTextField) in
        notesTextField.text = ""
        notesTextField.placeholder = "Notes:"
    }
    let saveAction = UIAlertAction(title: "Save",
                                   style: .default) { action in
      let medNameTextField = alert.textFields![0]
      let doseTextField = alert.textFields![1]
      let timeTextField = alert.textFields![2]
      let notesTextField = alert.textFields![3]
                                    
                                    let medication = Medication(pid: self.patient.uid,
                 name: medNameTextField.text!,
                dose: doseTextField.text!,
                time: timeTextField.text!,
                 notes: notesTextField.text!)
                                    
      self.items.append(medication)
      self.tableView.reloadData()
      
      let medRef = self.med.child(String(self.medCounter))
      let values: [String: Any] = [ "pid": self.patient.uid,
                                    "medName": medNameTextField.text!.lowercased(),
                                    "dose": doseTextField.text!.lowercased(),
                                    "time": timeTextField.text!.lowercased(),
        "notes": notesTextField.text!.lowercased()]
        medRef.setValue(values)
                    
      
    }
    
    let cancelAction = UIAlertAction(title: "Cancel",
                                     style: .default)
    
    
    alert.addAction(saveAction)
    alert.addAction(cancelAction)
    
    present(alert, animated: true, completion: nil)
  }
}
