//
//  PlantDetailTaskCell.swift
//  Garden-Tracker
//
//  Created by Hallie Johnson on 1/20/20.
//  Copyright © 2020 Hallie Johnson. All rights reserved.
//

import UIKit

class PlantDetailTaskCell: UITableViewCell {

    @IBOutlet weak var taskDate: UILabel!
    @IBOutlet weak var taskName: UILabel!
    
    func setTask(activity: Activity) {
        taskName.text = activity.task
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-YY"
        taskDate.text = formatter.string(from:activity.date!)
    }
    
}
