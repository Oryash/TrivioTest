//
//  Strings.swift
//  TrivioTest
//
//  Created by Anvar Bagautdinov on 28.05.2023.
//

import Foundation

enum Strings: String {
    case lat = "Lat: ;"
    case lon = "Lon: ;"
    case city = "City: "
    case temperature = "Temperature: "
    case noCity = "Нет города поблизости"
    case buttonImageName = "Button"
    case pinImageName = "Pin"
    case location = "Локации"
    case map = "Карта"
    case locationServicesTitle = "Geolocation Services Are Offline"
    case locationServicesMessage = "Turn on location services to allow application to determine your location"
    case permissionTitle = "Geolocation Permission is not granted"
    case permissionMessage = "Change permission status to 'Always' or 'On Usage' in order to continue using this app"


    func getString() -> String {
        return self.rawValue
    }
}
