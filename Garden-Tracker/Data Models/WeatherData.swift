//
//  WeatherData.swift
//  Garden-Tracker
//
//  Created by Hallie Johnson on 1/6/20.
//  Copyright © 2020 Hallie Johnson. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let cod: String
    let list: [List]
    
}

struct List: Codable {
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let id: Int
}
