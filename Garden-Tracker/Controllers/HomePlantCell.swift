//
//  HomePlantCell.swift
//  Garden-Tracker
//
//  Created by Hallie Johnson on 1/14/20.
//  Copyright © 2020 Hallie Johnson. All rights reserved.
//

import UIKit

class HomePlantCell: UITableViewCell {


    @IBOutlet weak var plantImage: UIImageView!
    @IBOutlet weak var plantNameLabel: UILabel!
    
    func setPlant(plant: Plant) {
        if let data = plant.image as Data? {
            self.plantImage.image = UIImage(data: data)
        }
        plantNameLabel.text = plant.name
    }
}
