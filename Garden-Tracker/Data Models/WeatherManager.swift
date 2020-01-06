//
//  WeatherManager.swift
//  Garden-Tracker
//
//  Created by Hallie Johnson on 1/6/20.
//  Copyright © 2020 Hallie Johnson. All rights reserved.
//

import Foundation

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/forecast?"
    
    func fetchWeather(latitude: Double, longitude: Double) {
        let urlString = "\(weatherURL)lat=\(latitude)&lon=\(longitude)&appid=\(weatherApiKey)"
        print(urlString)
    }
}
