//
//  PatientDosegeTableViewController.swift
//  PaRMonWC
//
//  Created by Shoaa Alqarni on 15/08/1441 AH.
//  Copyright © 1441 Noura. All rights reserved.
//


import UIKit
import Firebase
class PatientDosageTableViewController: UITableViewController {
   // MARK: Properties

      
      var items: [Medication] = []
      var user: User!
    
        
        // RealTime database References
      let rootRef =  Database.database().reference()
      let med = Database.database().reference(withPath: "medication")
      var medCounter = 1
      
      
      override func viewDidLoad() {
        super.viewDidLoad()
        
 
        
      let userId = Auth.auth().currentUser?.uid
   

        user = User(uid: "HDG12MLOQsY6AU6B3lhyogvZYAX2", email: "shoaa22n@gmail.com")
        
        med.observe(.value, with: {
          snapshot in
            var newItems: [Medication] = []
            for item in snapshot.children {
                
              let medication = Medication(snapshot: item as! DataSnapshot)
                if medication.pid == userId {
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
      
     
        
        // View Medication
      override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .disclosureIndicator{
              let editMedName = cell.textLabel!.text!
              let alert = UIAlertController(title: editMedName,
                                            message: nil,
                                          preferredStyle: .alert)
    
                
            alert.addTextField { (medNameTextField) in
                medNameTextField.text = "Med name: " + cell.textLabel!.text!
                medNameTextField.placeholder = "Name:"
                medNameTextField.isUserInteractionEnabled = false
            }
            alert.addTextField { (doseTextField) in
                doseTextField.text = "Dose: " + self.items[indexPath.row].dose
                doseTextField.placeholder = "Dose:"
                doseTextField.isUserInteractionEnabled = false
            }
            alert.addTextField { (timeTextField) in
                timeTextField.text = "Time: " + self.items[indexPath.row].time
                timeTextField.placeholder = "Time:"
                timeTextField.isUserInteractionEnabled = false
            }
            alert.addTextField { (notesTextField) in
                notesTextField.text = "Notes: " + self.items[indexPath.row].notes
                notesTextField.placeholder = "Notes:"
                notesTextField.isUserInteractionEnabled = false
            }
          
            let cancelAction = UIAlertAction(title: "Cancel",
                style: .default)
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
            
              
          } else {
            cell.accessoryType = .none
          }
          tableView.deselectRow(at: indexPath, animated: true)
        }
      }
        
        
       
      
    }
