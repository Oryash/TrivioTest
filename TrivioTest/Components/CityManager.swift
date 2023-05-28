//
//  CityManager.swift
//  TrivioTest
//
//  Created by Anvar Bagautdinov on 28.05.2023.
//

import Foundation
import CoreLocation

final class CityManager {
    static func getCityNameFromCoordinates(
        latitude: CLLocationDegrees,
        longitude: CLLocationDegrees,
        completion: @escaping (String) -> ()
    ) {
        let location = CLLocation(latitude: latitude, longitude: longitude)

        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first, error == nil else {
                print("Reverse geocoding failed: \(error?.localizedDescription ?? "Unknown Error")")
                return
            }

            if let cityName = placemark.locality {
                completion(cityName)
            } else {
                completion(Strings.noCity.getString())
            }
        }
    }
}
