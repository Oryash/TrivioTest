//
//  WeatherData.swift
//  TrivioTest
//
//  Created by Anvar Bagautdinov on 27.05.2023.
//

import Foundation

struct WeatherData: Decodable {
    let main: Main
}

struct Main: Decodable {
    let temp: Double
}
