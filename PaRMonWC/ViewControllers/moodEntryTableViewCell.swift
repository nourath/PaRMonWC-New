//
//  MoodEntryTableViewCell.swift
//  PatientLogs
//
//  Created by Salma on 02/04/2020.
//  Copyright © 2020 Salma. All rights reserved.
//

import UIKit

class moodEntryTableViewCell: UITableViewCell {

    
    @IBOutlet weak var LabelMoodTitle: UILabel!
    @IBOutlet weak var LabelMoodDate: UILabel!
    @IBOutlet weak var ImageViewMoodColor: UIImageView!
    

    func configure(_ entry: MoodEntry){
        ImageViewMoodColor.backgroundColor = entry.mood.colorValue
        LabelMoodTitle.text = entry.mood.stringValue
        LabelMoodDate.text = entry.date.stringValue

    }
}
