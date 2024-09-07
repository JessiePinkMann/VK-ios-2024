//
//  WeatherService.swift
//  VK_mimiApps
//
//  Created by Egor Anoshin on 07.09.2024.
//

import Foundation
import CoreLocation

class WeatherService {
    private let apiKey = "e66317dd50eef4d922376e6430689704"
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                completion(.success(weatherResponse))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
