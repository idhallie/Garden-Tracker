//
//  ViewController.swift
//  Garden-Tracker
//
//  Created by Hallie Johnson on 1/4/20.
//  Copyright © 2020 Hallie Johnson. All rights reserved.
//

import UIKit

class PlantDetailViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var lightLabel: UILabel!
    @IBOutlet weak var floweringLabel: UILabel!
    @IBOutlet weak var descLabel: UITextView!
    @IBOutlet weak var plantImage: UIImageView!
    
    var plant: Plant?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = plant?.name
        typeLabel.text = plant?.type
        lightLabel.text = plant?.light
        floweringLabel.text = plant?.flowering
        descLabel.text = plant?.notes

        if let data = plant?.image as Data? {
            plantImage.image = UIImage(data: data)
        } else {
            plantImage.image = UIImage(named: "NoImage.png")
        }
    }
  
}

