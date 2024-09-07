//
//  WeatherModel.swift
//  VK_mimiApps
//
//  Created by Egor Anoshin on 07.09.2024.
//

import Foundation

struct WeatherResponse: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
}

