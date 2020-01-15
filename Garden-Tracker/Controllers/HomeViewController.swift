//
//  HomeViewController.swift
//  Garden-Tracker
//
//  Created by Hallie Johnson on 1/6/20.
//  Copyright © 2020 Hallie Johnson. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class HomeViewController: UIViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet weak var conditionImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var plants: [Plant] = []
    
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // for weather
        let locationManager = CLLocationManager()
        var weatherManager = WeatherManager()

        
        override func viewDidLoad() {
            super.viewDidLoad()
            tableView.dataSource = self
            tableView.delegate = self

            // for weather
            weatherManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self as CLLocationManagerDelegate
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.requestLocation()
            }
            
            // to find database file:
            // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        }
        

        override func viewWillAppear(_ animated: Bool) {
            // load data from core data
            loadPlants()

            // reload the table view
            tableView.reloadData()
        }

//        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            return plants.count
//        }
//
//
//        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//            let cell = UITableViewCell()
//
//            let plant = plants[indexPath.row]
//            cell.textLabel?.text = plant.name!
//
//            return cell
//        }

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
                print("Error loading plants: \(error)")
            }
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "detailSegue" {
                let destVC = segue.destination as! PlantDetailViewController
                destVC.plant = sender as? Plant
            }
        }
    }

// MARK: - WeatherManagerDelegate

extension HomeViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        print(weather.conditionName)
        DispatchQueue.main.async {
            self.tempLabel.text = "\(weather.temperatureString)ºF"
            self.cityLabel.text = weather.cityName
            self.conditionImage.image = UIImage(systemName: weather.conditionName)
        }
    }

    func didFailWithError(error: Error) {
        print(error)
    }
}

// MARK: - CLLocationManagerDelegate

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print("error: \(error.localizedDescription)")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            print(latitude)
            print(longitude)
            weatherManager.fetchWeather(latitude: latitude, longitude: longitude)

            // reload the table view
            tableView.reloadData()
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plants.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let plant = plants[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomePlantCell") as! HomePlantCell
        cell.setPlant(plant: plant)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let plant = plants[indexPath.row]
        performSegue(withIdentifier: "detailSegue", sender: plant)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

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
}
