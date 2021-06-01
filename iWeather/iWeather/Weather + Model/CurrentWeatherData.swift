//
//  CurrentWeatherData.swift
//  iWeather
//
//  Created by Decagon on 28/04/2021.
//

import Foundation

struct CurrentWeatherData: Codable {
    var weather: [Weather]
    var main: Main
    var name: String
}


struct Weather: Codable {
    var id: Int
    var main: String
    var description: String
}

struct Main: Codable {
    var temp: Double
    var temp_min: Double
    var temp_max: Double
}
