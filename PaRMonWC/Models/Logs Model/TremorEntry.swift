//
//  TremorEntry.swift
//  PatientLogs
//
//  Created by Salma on 02/04/2020.
//  Copyright © 2020 Salma. All rights reserved.
//

import UIKit
import Foundation
import UIKit.UIColor //color changing based on selection.
import Firebase

    struct TremorEntry {
        
        enum Tremor: Int {
            case none
            case dysk
            case on
            case off
            
            var stringValue: String {
                switch self {
                case .none:
                    return ""
                case .dysk:
                    return "dysk"
                case .on:
                    return "on"
                case .off:
                    return "off"

                }
            }
            
            var colorValue: UIColor {
                switch self {
                case .none:
                    return .clear
                case .dysk:
                    return .yellow
                case .on:
                    return .green
                case .off:
                    return .red
                    
                }
            }
        }
        
        var tremor: Tremor
        var date: Date
        
           func toAnyObject() -> Any {
             return [
                 "tremor": tremor,
               "date": date
             ]
           }
           
    }


