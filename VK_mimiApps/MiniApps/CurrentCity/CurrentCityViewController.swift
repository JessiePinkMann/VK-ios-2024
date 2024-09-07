//
//  CurrentCityViewController.swift
//  VK_mimiApps
//
//  Created by Egor Anoshin on 07.09.2024.
//
// CurrentCityViewController.swift
import UIKit
import MapKit

class CurrentCityViewController: UIViewController {

    private let cityLocationService = CityLocationService()
    
    private var cityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.text = "Your current city is: Unknown"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var mapView: MKMapView = {
        let map = MKMapView()
        map.layer.cornerRadius = 20  // Скругляем углы карты
        map.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]  // Скругляем только верхние углы
        map.clipsToBounds = true  // Чтобы не было "вылезания" карты за границы
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "primaryBackground")
        
        view.addSubview(cityLabel)
        view.addSubview(mapView)
        
        setupLayout()
        setupLocationService()
    }
    
    // Настройка сервиса геолокации
    private func setupLocationService() {
        cityLocationService.onCityFound = { [weak self] city, coordinates in
            DispatchQueue.main.async {
                self?.cityLabel.text = "Your current city is: \(city.name)"
                
                // Обновляем карту, устанавливаем регион
                let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 10000, longitudinalMeters: 10000)
                self?.mapView.setRegion(region, animated: true)
            }
        }
        
        cityLocationService.onError = { [weak self] error in
            DispatchQueue.main.async {
                self?.cityLabel.text = "Failed to get location: \(error.localizedDescription)"
            }
        }
        
        cityLocationService.requestLocation()
    }
    
    // Настройка лейаута
    private func setupLayout() {
        NSLayoutConstraint.activate([
            cityLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            cityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cityLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6)
        ])
    }
}
