//
//  PatientsLogsTableViewController.swift
//  PatientLogs
//
//  Created by Salma on 02/04/2020.
//  Copyright © 2020 Salma. All rights reserved.
//

import UIKit
import Firebase

class PatientLogsTableViewController: UIViewController{

        var patient: Patient!
        var moodEntries: [MoodEntry] = []
        var tremorEntries: [TremorEntry] = []
        var statusList : [Status] = []
        var tempIndex = 0
          
        // RealTime database References
           let rootRef =  Database.database().reference()
           let statusDB = Database.database().reference(withPath: "Status")
        
        override func viewDidLoad() {
               super.viewDidLoad()
            
            
          let userId = Auth.auth().currentUser?.uid

           statusDB.observe(.value, with: {
             snapshot in
                self.moodEntries.removeAll()
                self.tremorEntries.removeAll()
                self.statusList.removeAll()
               for item in snapshot.children {
                   
                    let status = Status(snapshot: item as! DataSnapshot)
                    if status.pid == userId
                    {
                        self.statusList.append(status)
                    }
               }
                for status in self.statusList
                {
                    //initial value of mood
                    let moodItem = MoodEntry(mood: self.getMoodValue(mood: status.mood), date: status.date)
                    self.moodEntries.append(moodItem)

                    //initial value of tremor
                    let tremorItem = TremorEntry(tremor: self.getTremorValue(tremor: status.tremor), date: status.date)
                    self.tremorEntries.append(tremorItem)
                }
            
               self.MoodTableView.reloadData()
               self.TremorTableView.reloadData()
           })
               // print(statusList.count)
    //            print("Mood List: " + String(moodEntries.count))
    //            print("Tremor List: " + String(tremorEntries.count))
           }
        
           override func viewWillAppear(_ animated: Bool) {
               super.viewWillAppear(animated)
           
               if  let selectedIndexPath = MoodTableView.indexPathForSelectedRow {
                   MoodTableView.deselectRow(at: selectedIndexPath, animated: true)
               }
               else if let selectedIndexPath = TremorTableView.indexPathForSelectedRow {
                   TremorTableView.deselectRow(at: selectedIndexPath, animated: true)
             }
           }
        
         //Mood Table View
    //       func createMoodEntry(mood: MoodEntry.Mood, date: Date) {
    //           let newEntry = MoodEntry(mood: mood, date: date.stringValue)
    //           //moodEntries.insert(newEntry, at: 0)
    ////            moodEntries.append(newEntry)
    //           MoodTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    //       }
           
           func updateMoodEntry(mood: MoodEntry.Mood, date: Date, at index: Int) {
               moodEntries[index].mood = mood
                moodEntries[index].date = date.stringValue
               MoodTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
           }
           
           func deleteMoodEntry(at index: Int) {
               moodEntries.remove(at: index)
               MoodTableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
           }
           
           // Tremor Table View
        func createTremorEntry(tremor: TremorEntry.Tremor, date: Date) {
            let newEntry = TremorEntry(tremor: tremor, date: date.stringValue)
            tremorEntries.insert(newEntry, at: 0)
    //        tremorEntries.append(newEntry)
            TremorTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }
        
        func updateTremorEntry(tremor: TremorEntry.Tremor, date: Date, at index: Int) {
            tremorEntries[index].tremor = tremor
            tremorEntries[index].date = date.stringValue
            TremorTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
        
        func deleteTremorEntry(at index: Int) {
            tremorEntries.remove(at: index)
            TremorTableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
        
        //Cases of adding new patient mood/tremor status or view an old one
           override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
               if let identifier = segue.identifier {
                   switch identifier {
                   case "show new entry":
                  
                       guard let EntryViewController = segue.destination as? PatientLogsViewController else {
                           
                           //NOTE: error handling
                           return print("storyboard not set up correctly, 'show entry details' segue needs to segue to a 'MoodDetailedViewController'")
                       }
                       
                       EntryViewController.mood = MoodEntry.Mood.none
                       EntryViewController.tremor = TremorEntry.Tremor.none
                       EntryViewController.date = Date()
    //                   EntryViewController.counter = moodEntries.count
                        // stop here
                    
                   case "show mood entry details":
                        
                       guard
                        let selectedCell = sender as? UITableViewCell, let indexPath = MoodTableView.indexPath(for: selectedCell) else {
                               return print("failed to locate index path from sender")
                       }
                       
                       guard let moodEntryViewController = segue.destination as? PatientLogsViewController else {
                           return print("storyboard not set up correctly, 'show entry details' segue needs to segue to a 'PatientLogsViewController'")
                       }
                       
                       let moodEntry = moodEntries[indexPath.row]
                       moodEntryViewController.mood = moodEntry.mood
                       moodEntryViewController.date = Date()
                       moodEntryViewController.isEditingEntry = true
                
                    case "show tremor entry details":
                  
                    guard
                        let selectedCell = sender as? UITableViewCell,
                        let indexPath = TremorTableView.indexPath(for: selectedCell) else {
                            return print("failed to locate index path from sender")
                    }
                    
                    guard
                        let tremorEntryViewController = segue.destination as? PatientLogsViewController else {
                        return print("storyboard not set up correctly, 'show entry details' segue needs to segue to a 'PatientLogsViewController'")
                    }
                    
                    let tremorEntry = tremorEntries[indexPath.row]
                    tremorEntryViewController.tremor = tremorEntry.tremor
                    tremorEntryViewController.date = Date()
                    tremorEntryViewController.isEditingEntry = true
                  
                   default: break
                   }
               }
           }
        
    @IBOutlet weak var MoodTableView: UITableView!
    
    @IBOutlet weak var TremorTableView: UITableView!
    
    
        func getMoodValue(mood: String) -> MoodEntry.Mood
        {
               switch mood {
                   case "happy":
                   return MoodEntry.Mood.happy
                   case "good":
                    return MoodEntry.Mood.good
                   case "bad":
                    return MoodEntry.Mood.bad
                   case "none":
                    return MoodEntry.Mood.none
                
                   default:
                    return MoodEntry.Mood.none
                }
        }
        
        func getTremorValue(tremor: String) -> TremorEntry.Tremor
           {
                  switch tremor {
                      case "dysk":
                        return TremorEntry.Tremor.dysk
                      case "off":
                        return TremorEntry.Tremor.off
                      case "on":
                        return TremorEntry.Tremor.on
                      case "none":
                        return TremorEntry.Tremor.none
                   
                      default:
                        return TremorEntry.Tremor.none
                   }
           }
        
        @IBAction func unwindToHome(_ segue: UIStoryboardSegue) {
            guard let identifier = segue.identifier else {
                return
            }
            
            guard let detailedEntryViewController = segue.source as? PatientLogsViewController else {
                return print("storyboard unwind segue not set up correctly")
            }
            
            switch identifier {
            case "unwind from save":
                let newMood: MoodEntry.Mood = detailedEntryViewController.mood
                let newTremor: TremorEntry.Tremor = detailedEntryViewController.tremor
                let newDate: Date = detailedEntryViewController.date

                if detailedEntryViewController.isEditingEntry {
                     
                     guard let moodSelectedIndexPath = MoodTableView.indexPathForSelectedRow
                    else  {
                        return
                    }
                     guard let tremorSelectedIndexPath = TremorTableView.indexPathForSelectedRow
                    else  {
                        return
                    }

    //                updateMoodEntry(mood: newMood, date: newDate, at: moodSelectedIndexPath.row)
    //                updateTremorEntry(tremor: newTremor, date: newDate, at: tremorSelectedIndexPath.row)

                } else {
    //                createMoodEntry(mood: newMood, date: newDate)
    //                createTremorEntry(tremor: newTremor, date: newDate)
                }
        
            case "unwind from cancel":
                print("from cancel button")
                
            default:
                break
            }
        }
    }

    extension PatientLogsTableViewController: UITabBarDelegate, UITableViewDataSource{

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        var numberOfRow = 1
    //
    //        switch tableView {
    //
    //        case  MoodTableView:
    //              numberOfRow = moodEntries.count
    //
    //        case TremorTableView:
    //             numberOfRow = tremorEntries.count
    //
    //        default:
    //            print("Something's Wrong!!")
    //        }
            return statusList.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
            switch tableView {
            case MoodTableView:
                let cell = MoodTableView.dequeueReusableCell(withIdentifier: "mood entry cell", for: indexPath) as! moodEntryTableViewCell
                
                let entry = moodEntries[indexPath.row]
                cell.configure(entry)
                return cell
                
            case TremorTableView:
                let cell = TremorTableView.dequeueReusableCell(withIdentifier: "tremor entry cell", for: indexPath) as! tremorEntryTableViewCell
                
                let entry = tremorEntries[indexPath.row]
                cell.configure(entry)
                
                return cell
            default:
                print("Somthing's Wrong..")
            }
                   return UITableViewCell()
            }
             
        
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            switch tableView {
            case  MoodTableView:
                let selectedEntry = moodEntries[indexPath.row]
                print("Selected mood was \(selectedEntry.mood.stringValue)")
            
            case  TremorTableView:
            let selectedEntry = tremorEntries[indexPath.row]
            print("Selected status was \(selectedEntry.tremor.stringValue)")
        
            default:
                print("No selection..")

            }
      }
        // to delete from two tables and from fire base also
    //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //
    //        switch editingStyle {
    //        case .delete:
    //            if(indexPath.row > tempIndex ){
    //                tempIndex += 1
    //            }
    //            //delete from first table
    //            deleteMoodEntry(at: indexPath.row)
    //            //delete from second table
    //            deleteTremorEntry(at: indexPath.row)
    //            //remove from fire base
    ////            let ref = Database.database().reference().child("Status")
    ////            ref.child("\(indexPath.row)").removeValue()
    //            self.statusList.remove(at: indexPath.row)
    //        default:
    //            break
    //            }
    //        }
    }
