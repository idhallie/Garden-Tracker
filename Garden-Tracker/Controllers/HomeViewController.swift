//
//  HomeViewController.swift
//  Garden-Tracker
//
//  Created by Hallie Johnson on 1/6/20.
//  Copyright © 2020 Hallie Johnson. All rights reserved.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, WeatherManagerDelegate {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    var plants : [Plant] = []
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // for weather
        let locationManager = CLLocationManager()
        var longitude : Double = 0.0
        var latitude : Double = 0.0
        var weatherManager = WeatherManager()

        
        override func viewDidLoad() {
            super.viewDidLoad()
            tableView.dataSource = self
            tableView.delegate = self
            tableView.rowHeight = 100

            // for weather
            weatherManager.delegate = self as? WeatherManagerDelegate
            locationManager.requestWhenInUseAuthorization()
            
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self as? CLLocationManagerDelegate
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.requestLocation()
            }
            
            
            // to find database file:
            //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        }
        
        // MARK: Weather functions
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
                longitude = location.coordinate.longitude
                latitude = location.coordinate.latitude
                
                print(location.coordinate.longitude)
                print(location.coordinate.latitude)
                weatherManager.fetchWeather(latitude: latitude, longitude: longitude)
                
                // reload the table view
                tableView.reloadData()
                
            }
        }
        
        func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
            print(weather.temperature)
        }

        func didFailWithError(error: Error) {
            print(error)
        }
        

    //    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        let cell =
    //
    //        latitudeLabel.text = "\(latitude)"
    //        longitudeLabel.text = "\(longitude)"
    //
    //    }
        
        // header for weather details
    //    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        return "locations = Latitude: \(latitude) Longitude: \(longitude)"
    //    }

        override func viewWillAppear(_ animated: Bool) {
            // load data from core data
            loadPlants()

            // reload the table view
            tableView.reloadData()
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return plants.count
        }


        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = UITableViewCell()

            let plant = plants[indexPath.row]
            cell.textLabel?.text = plant.name!

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


    }
