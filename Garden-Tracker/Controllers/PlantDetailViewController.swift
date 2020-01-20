//
//  ViewController.swift
//  Garden-Tracker
//
//  Created by Hallie Johnson on 1/4/20.
//  Copyright © 2020 Hallie Johnson. All rights reserved.
//

import UIKit

class PlantDetailViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var lightLabel: UILabel!
    @IBOutlet weak var floweringLabel: UILabel!
    @IBOutlet weak var descLabel: UITextView!
    @IBOutlet weak var plantImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var plant: Plant?
    var activities : [Activity] = []
    var tasks : [Activity] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.tableFooterView = UIView()
        
        titleLabel.text = plant?.name
        typeLabel.text = plant?.type
        lightLabel.text = plant?.light
        floweringLabel.text = plant?.flowering
        descLabel.text = plant?.notes
        
        if let data = plant?.image as Data? {
            plantImage.image = UIImage(data: data)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadActivites()
        filterActivities()

        tableView.reloadData()
    }
    
    
    @IBAction func editBtnPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "editPlantSegue", sender: plant)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! EditPlantViewController
        destVC.plant = plant
    }
    
    func filterActivities() {
        tasks = activities.filter({ return $0.parentPlant?.name == plant?.name})
        print("Plant tasks: \(tasks)")
    }
    
    func loadActivites() {
        do {
            activities = try context.fetch(Activity.fetchRequest())
        } catch {
            print("Error loading activities: \(error)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("tasks count: \(tasks.count)")
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = tasks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlantDetailTaskCell") as! PlantDetailTaskCell
        cell.setTask(activity: task)
        print("This cell is: \(cell)")

        return cell
    }

}
