//
//  PatientsLogsTableViewController.swift
//  PatientLogs
//
//  Created by Salma on 02/04/2020.
//  Copyright © 2020 Salma. All rights reserved.
//

import UIKit
import FirebaseDatabase
class PhysicianPatientLogsTableViewController: UIViewController{

    var status: [Status] = []
    var tempIndex = 0
      
       // RealTime database References
     let rootRef =  Database.database().reference()
     let statusDB = Database.database().reference(withPath: "Status")
     var statusCounter = 1



    
    @IBOutlet weak var tableView: UITableView!
        
    
   override func viewDidLoad() {
        super.viewDidLoad()
      
      statusDB.observe(.value, with: {
        snapshot in
          var newStatus: [Status] = []
          for item in snapshot.children {
              
            let status = Status(snapshot: item as! DataSnapshot)
                  newStatus.append(status)
              }
          
        self.status = newStatus
        self.tableView.reloadData()
      })
    
    }
}
    extension PhysicianPatientLogsTableViewController: UITableViewDataSource, UITableViewDelegate {


     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return status.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let cell = tableView.dequeueReusableCell(withIdentifier: "status entry cell", for: indexPath)
            print(status.count)

            let entry = status[indexPath.row]
            cell.textLabel?.text = entry.mood
            cell.textLabel?.text = entry.tremor
            cell.textLabel?.text = entry.date
            cell.detailTextLabel?.text = "Mood status: " + entry.mood + ", Tremor status: " + entry.tremor + "Timestamp: " + entry.date
            
            print(status.count)
            return cell

        }
    
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .disclosureIndicator{
              let editMedName = cell.textLabel!.text!
              let alert = UIAlertController(title: editMedName,
                                            message: nil,
                                          preferredStyle: .alert)
    
                
     /*       alert.addTextField { (statusTextField) in
                statusTextField.text = "Status: " + cell.textLabel!.text!
                statusTextField.placeholder = "Status:"
                statusTextField.isUserInteractionEnabled = false
            }*/
            alert.addTextField { (moodTextField) in
                moodTextField.text = "Mood Status: " + self.status[indexPath.row].mood
            //    moodTextField.placeholder = "Dose:"
                moodTextField.isUserInteractionEnabled = false
            }
            alert.addTextField { (tremorTextField) in
                tremorTextField.text = "Tremor Status: " + self.status[indexPath.row].tremor
            //    tremorTextField.placeholder = "Time:"
                tremorTextField.isUserInteractionEnabled = false
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

