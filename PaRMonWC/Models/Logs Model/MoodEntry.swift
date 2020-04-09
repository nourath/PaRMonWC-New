//
//  MoodEntry.swift
//  PatientLogs
//
//  Created by Salma on 02/04/2020.
//  Copyright © 2020 Salma. All rights reserved.
//

import UIKit
import Foundation
import UIKit.UIColor //color changing based on selection.
import Firebase



struct MoodEntry {
    
    enum Mood: Int {
        case none
        case happy
        case good
        case bad

        var stringValue: String {
            switch self {
            case .none:
                return ""
            case .happy:
                return "happy"
            case .good:
                return "Good"
            case .bad:
                return "bad"

            }
        }
        
        var colorValue: UIColor {
            switch self {
            case .none:
                return .clear
            case .happy:
                return .green
            case .good:
                return .orange
            case .bad:
                return .red
                
            }
        }
    }
    
    var mood: Mood
    var date: Date
    
    
}

