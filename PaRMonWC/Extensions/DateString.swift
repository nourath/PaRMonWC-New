//
//  DateString.swift
//  PatientLogs
//
//  Created by salma on 02/04/2020.
//  Copyright © 2020 salma . All rights reserved.
//

import Foundation
extension Date {
    var stringValue: String {
        return DateFormatter.localizedString(from: self, dateStyle: .medium, timeStyle: .short)
    }
}
