//
//  WeatherViewController.swift
//  VK_mimiApps
//
//  Created by Egor Anoshin on 07.09.2024.
//

// WeatherViewController.swift
import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    private let locationManager = CLLocationManager()  // Для получения геолокации
    private let weatherService = WeatherService()      // Сервис для работы с API
    
    private let weatherLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Fetching weather..."
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "primaryBackground")
        view.addSubview(weatherLabel)
        
        setupLayout()
        setupLocationManager()
    }

    // Настройка расположения лейбла
    private func setupLayout() {
        NSLayoutConstraint.activate([
            weatherLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weatherLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            weatherLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            weatherLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    // Настройка менеджера геолокации
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    // Обновление интерфейса на основе полученных данных о погоде
    private func updateWeatherUI(with weatherResponse: WeatherResponse) {
        let city = weatherResponse.name
        let temperature = weatherResponse.main.temp
        let description = weatherResponse.weather.first?.description ?? "No description"
        
        weatherLabel.text = """
        Weather in \(city):
        \(temperature)°C, \(description)
        """
    }
}

// MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    // Обработка обновления местоположения
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            locationManager.stopUpdatingLocation()  // Останавливаем обновление локации
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            // Вызов API для получения данных о погоде
            weatherService.fetchWeather(latitude: latitude, longitude: longitude) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let weatherResponse):
                        self?.updateWeatherUI(with: weatherResponse)
                    case .failure(let error):
                        self?.weatherLabel.text = "Failed to fetch weather: \(error.localizedDescription)"
                    }
                }
            }
        }
    }
    
    // Обработка ошибок геолокации
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error fetching location: \(error)")
        weatherLabel.text = "Failed to get location."
    }
}
