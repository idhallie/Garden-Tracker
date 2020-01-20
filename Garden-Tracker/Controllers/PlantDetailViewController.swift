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
    var activities : [Activity] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = plant?.name
        typeLabel.text = plant?.type
        lightLabel.text = plant?.light
        floweringLabel.text = plant?.flowering
        descLabel.text = plant?.notes
        
        if let data = plant?.image as Data? {
            plantImage.image = UIImage(data: data)
        }
        loadActivites()
        filterActivities()
    }
    
    
    @IBAction func editBtnPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "editPlantSegue", sender: plant)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! EditPlantViewController
        destVC.plant = plant
    }
    
    
    func filterActivities() {
        let tasks = activities.filter({ return $0.parentPlant?.name == plant?.name})
        print("Plant tasks: \(tasks)")
    }
    
    func loadActivites() {
        do {
            activities = try context.fetch(Activity.fetchRequest())
        } catch {
            print("Error loading activities: \(error)")
        }
    }
}

