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
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    self.parseJSON(weatherData: safeData)
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) {
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(WeatherData.self, from: weatherData)
            let temp = decodeData.list[0].main.temp
            let id = decodeData.list[0].weather[0].id
        
            let weather = WeatherModel(conditionId: id, temperature: temp)
            
            print(weather.conditionName)
        } catch {
            print(error)
        }
        
    }

}
