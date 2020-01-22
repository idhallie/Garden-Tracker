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
    
    @IBOutlet weak var sortButton: UIButton!
    var sortOrder = true
    
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
        
        // for weather
        weatherManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self as CLLocationManagerDelegate
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestLocation()
        }
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
    
    
    @IBAction func sortBtnTapped(_ sender: UIButton) {
        if sortOrder == true {
            sortButton.setTitle("Sort: a - z", for: .normal)
            sortOrder = false
            loadPlants()
            tableView.reloadData()
        } else {
            sortButton.setTitle("Sort: z - a", for: .normal)
            sortOrder = true
            loadPlants()
            tableView.reloadData()
        }
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
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Plant>(entityName: "Plant")
        let sort = NSSortDescriptor(key: #keyPath(Plant.name), ascending: sortOrder)
        fetchRequest.sortDescriptors = [sort]
        do {
            plants = try context.fetch(fetchRequest)
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
