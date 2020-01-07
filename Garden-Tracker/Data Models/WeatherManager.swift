//
//  WeatherManager.swift
//  Garden-Tracker
//
//  Created by Hallie Johnson on 1/6/20.
//  Copyright © 2020 Hallie Johnson. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/forecast?"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(latitude: Double, longitude: Double) {
        let urlString = "\(weatherURL)lat=\(latitude)&lon=\(longitude)&appid=\(weatherApiKey)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode(WeatherData.self, from: weatherData)
            let temp = decodeData.list[0].main.temp
            let id = decodeData.list[0].weather[0].id
        
            let weather = WeatherModel(conditionId: id, temperature: temp)
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
