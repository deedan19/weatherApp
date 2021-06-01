//
//  DayWeatherData.swift
//  iWeather
//
//  Created by Decagon on 28/04/2021.
//

import Foundation


struct DayWeatherData: Codable {
    let list: [List]
}

struct List: Codable {
    var dt: Int
    var main: DailyMain
    var weather: [DailyWeather]
}

struct DailyMain: Codable {
    var temp: Double
}

struct DailyWeather: Codable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}
