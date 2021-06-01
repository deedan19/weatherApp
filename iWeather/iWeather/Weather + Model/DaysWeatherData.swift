//
//  DaysWeatherData.swift
//  iWeather
//
//  Created by Decagon on 28/04/2021.
//

import Foundation

struct DaysWeatherData: Codable {
    let daily: [Daily]
}

struct Daily: Codable {
    var dt: Int
    var temp: Temperature
    var weather: [DayWeather]
}

struct Temperature: Codable {
    var day: Double
    var min: Double
}

struct  DayWeather: Codable {
    var main: String
    var description: String
}
