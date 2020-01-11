//
//  ActivityCell.swift
//  Garden-Tracker
//
//  Created by Hallie Johnson on 1/11/20.
//  Copyright © 2020 Hallie Johnson. All rights reserved.
//

import UIKit

class ActivityCell: UITableViewCell {


    @IBOutlet weak var plantLabel: UILabel!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func setActivity(activity: Activity) {
        plantLabel.text = activity.parentPlant?.name
        taskLabel.text = activity.task
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-YY"
        dateLabel.text = formatter.string(from:activity.date!)
    }
}
