//
//  NetworkManager.swift
//  TrivioTest
//
//  Created by Anvar Bagautdinov on 27.05.2023.
//

import Foundation

class NetworkManager {
    static func fetch (lat: Double, lon: Double, completion: @escaping (Double) -> ()) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=6c274174defd036850d86ea40bc2bc70"
        guard let url = URL(string: urlString) else { return }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }

            guard let data = data else { return }
            if let model = parseJson(data) {
                completion(model.main.temp)
            }
        }

        task.resume()
    }

    static func parseJson(_ response: Data) -> WeatherData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: response)
            return .init(main: .init(temp: decodedData.main.temp))
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}

