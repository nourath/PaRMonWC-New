//
//  TremorEntryTableViewCell.swift
//  PatientLogs
//
//  Created by Salma on 02/04/2020.
//  Copyright © 2020  Salma . All rights reserved.
//

import UIKit

class tremorEntryTableViewCell: UITableViewCell {

    @IBOutlet weak var LabelTremorTitle: UILabel!
    @IBOutlet weak var LabelTremorDate: UILabel!
    @IBOutlet weak var ImageViewTremorColor: UIImageView!
    
    func configure(_ entry: TremorEntry) {
    ImageViewTremorColor.backgroundColor = entry.tremor.colorValue
    LabelTremorTitle.text = entry.tremor.stringValue
    LabelTremorDate.text = entry.date
}
}
