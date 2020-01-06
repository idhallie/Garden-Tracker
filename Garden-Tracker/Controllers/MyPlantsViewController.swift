//
//  TableViewController.swift
//  Garden-Tracker
//
//  Created by Hallie Johnson on 1/5/20.
//  Copyright © 2020 Hallie Johnson. All rights reserved.
//

import UIKit
import CoreLocation

class MyPlantsViewController: UITableViewController {
    
    var plants : [Plant] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // for weather
    let locationManager = CLLocationManager()


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        // for weather
        self.locationManager.requestAlwaysAuthorization()

        // to find database file:
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }

    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Words go here"
//    }

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
    
    // MARK: Code for weather
    
    func getCurrentLocation() {
        // Ask user for permission
        self.locationManager.requestAlwaysAuthorization()
        
        // While using app
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }

}

extension MyPlantsViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else
            {return}
        print("locations = \(locValue.latitude) \(locValue.longitude)")

    }
}
