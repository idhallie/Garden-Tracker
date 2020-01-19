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

    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet weak var conditionImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    @IBOutlet weak var preWeatherStack: UIStackView!
    @IBOutlet weak var weatherStack: UIStackView!
    
    
    var plants: [Plant] = []
    var filterCriteria: FilterCriteria?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // for weather
    let locationManager = CLLocationManager()
    var weatherManager = WeatherManager()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            tableView.dataSource = self
            tableView.delegate = self
            
            // Hide the back button that may appear after navigating away and returning.
//            let backButton = UIBarButtonItem(title: "", style: .plain, target: navigationController, action: nil)
//            navigationItem.leftBarButtonItem = backButton

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
        
    func filter() {
        switch filterCriteria?.category {
        case "type":
        plants = plants.filter({return $0.type == filterCriteria?.item})
        case "light":
        plants = plants.filter({return $0.light == filterCriteria?.item})
        case "flowering":
        plants = plants.filter({return $0.flowering == filterCriteria?.item})
        default:
            print("No category found.")
        }
    }

        override func viewWillAppear(_ animated: Bool) {
            // load data from core data
            loadPlants()
            if filterCriteria != nil {
                filterButton.isHidden = true
                clearButton.isHidden = false
                filter()}
            
            // reload the table view
            tableView.reloadData()
        }
    
    @IBAction func filterBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "FilterSegue", sender: nil)
    }
    
    @IBAction func clearBtnTapped(_ sender: UIButton) {
        filterCriteria = nil
        viewWillAppear(false)
        clearButton.isHidden = true
        filterButton.isHidden = false
    }
    
    @IBAction func unwindToHome(_ sender: UIStoryboardSegue) {}
    
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
            self.preWeatherStack.isHidden = true
            self.weatherStack.isHidden = false
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
