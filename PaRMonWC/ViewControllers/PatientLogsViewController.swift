//
//  PatientsLogsViewController.swift
//  PatientLogs
//
//  Created by Salma on 02/04/2020.
//  Copyright © 2020 Salma. All rights reserved.
//

import UIKit
import Firebase

class PatientLogsViewController: UIViewController {

    @IBOutlet weak var buttonHappyMood: UIButton!
    @IBOutlet weak var buttonGoodMood: UIButton!
    @IBOutlet weak var buttonBadMood: UIButton!
    
    @IBOutlet weak var buttonDysk: UIButton!
    @IBOutlet weak var buttonOn: UIButton!
    @IBOutlet weak var buttonOff: UIButton!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    var date: Date!
    var mood: MoodEntry.Mood!
    var tremor: TremorEntry.Tremor!
    var index : Int!
    var isEditingEntry = false
    
    private func updateUI() {
        updateMood(to: mood)
        updateTremor(to: tremor)
        datePicker.date = date
    }
    
    private func updateMood(to newMood: MoodEntry.Mood) {
        let unselectedColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        switch newMood {
        case .none:
                buttonHappyMood.backgroundColor = unselectedColor
                buttonGoodMood.backgroundColor = unselectedColor
                buttonBadMood.backgroundColor = unselectedColor
        case .happy:
                       buttonHappyMood.backgroundColor = newMood.colorValue
                       buttonGoodMood.backgroundColor = unselectedColor
                       buttonBadMood.backgroundColor = unselectedColor
        case .good:
                       buttonHappyMood.backgroundColor = unselectedColor
                       buttonGoodMood.backgroundColor = newMood.colorValue
                       buttonBadMood.backgroundColor = unselectedColor
            
        case .bad:
                       buttonHappyMood.backgroundColor = unselectedColor
                       buttonGoodMood.backgroundColor = unselectedColor
                       buttonBadMood.backgroundColor = newMood.colorValue

        }
        
        mood = newMood
    }
    
    private func updateTremor(to newTremor: TremorEntry.Tremor) {
           let unselectedColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
           switch newTremor {
           case .none:
                   buttonDysk.backgroundColor = unselectedColor
                   buttonOn.backgroundColor = unselectedColor
                   buttonOff.backgroundColor = unselectedColor
           case .dysk:
                   buttonDysk.backgroundColor = newTremor.colorValue
                   buttonOn.backgroundColor = unselectedColor
                   buttonOff.backgroundColor = unselectedColor
        
           case .on:
                   buttonDysk.backgroundColor = unselectedColor
                   buttonOn.backgroundColor = newTremor.colorValue
                   buttonOff.backgroundColor = unselectedColor
           case .off:
                   buttonDysk.backgroundColor = unselectedColor
                   buttonOn.backgroundColor = unselectedColor
                   buttonOff.backgroundColor = newTremor.colorValue
        }

            tremor = newTremor
        }
    
    @IBAction func pressMood(_ button: UIButton) {
        
        switch button.tag {
            
           case 0:
                updateMood(to: .none)
            case 1:
                updateMood(to: .happy)
            case 2:
                updateMood(to: .good)
            case 3:
                updateMood(to: .bad)
            
            default:
                
            //NOTE: error handling
            print("unhandled button tag")
    }
    }
    
    
    @IBAction func pressTremor(_ button: UIButton) {
        switch button.tag {
        
        case 0:
            updateTremor(to: .none)
        case 1:
            updateTremor(to: .dysk)
        case 2:
            updateTremor(to: .on)
        case 3:
            updateTremor(to: .off)
        
        default:
            
        //NOTE: error handling
        print("unhandled button tag")
        }
    }
    
    @IBAction func datePickerDidChangeValue(_ sender: Any) {
        date = datePicker.date
    }
    
    
    @IBAction func pressSave(_ sender: UIBarButtonItem) {

            //creating reference to fire base database
            let ref = Database.database().reference()
            //putting data inside a dictionary
            let dict = ["tremor":tremor.stringValue,"mood":mood.stringValue,"date":date.stringValue]
            //inserting value to firebase
            ref.child("Status/\(index!)").setValue(dict)
        performSegue(withIdentifier: "unwind from save", sender: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
    }
    

}
