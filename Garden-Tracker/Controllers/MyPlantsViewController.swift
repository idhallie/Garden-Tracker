//
//  TableViewController.swift
//  Garden-Tracker
//
//  Created by Hallie Johnson on 1/5/20.
//  Copyright © 2020 Hallie Johnson. All rights reserved.
//

import UIKit

//var pets = ["dog", "cat", "rabbit"]
//var petDesc = ["dogs are cute. What happens if this description is a lot longer and I use a label field.", "cats are okay", "rabbits are wiley"]
//var myIndex = 0

class MyPlantsViewController: UITableViewController {
    
    var plants : [Plant] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self

        // Do any additional setup after loading the view.

        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }


    override func viewWillAppear(_ animated: Bool) {
        // load data from core data
        loadPlants()

        // reload the table view
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plants.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

        let plant = plants[indexPath.row]
        cell.textLabel?.text = plant.name!

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let plant = plants[indexPath.row]
        performSegue(withIdentifier: "detailSegue", sender: plant)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            let plant = plants[indexPath.row]
            context.delete(plant)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()

            do {
               plants = try context.fetch(Plant.fetchRequest())
            }
            catch {
                print("Fetching failed \(error)")
            }
        }

        tableView.reloadData()

    }

    // MARK: Model Manipulation Methods

    func savePlants() {
        do {
        try context.save()
        } catch {
           print("Error saving context \(error)")
        }

        self.tableView.reloadData()
    }


    func loadPlants() {

        do {
           plants = try context.fetch(Plant.fetchRequest())
        }
        catch {
            print("Fetching failed \(error)")
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            let destVC = segue.destination as! ViewController
            destVC.plant = sender as? Plant
        }
    }
    
    
    
    

//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Uncomment the following line to preserve selection between presentations
//        // self.clearsSelectionOnViewWillAppear = false
//
//        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//        // self.navigationItem.rightBarButtonItem = self.editButtonItem
//    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
    
    
    // REAL STUFF
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        return pets.count
//    }
//
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//
//        cell.textLabel?.text = pets[indexPath.row]
//
//        return cell
//    }
//
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        myIndex = indexPath.row
//        performSegue(withIdentifier: "detailSegue", sender: self)
//    }

}
