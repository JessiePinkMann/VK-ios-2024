//
//  CityLocationService.swift
//  VK_mimiApps
//
//  Created by Egor Anoshin on 07.09.2024.
//
// CityLocationService.swift
import Foundation
import CoreLocation

class CityLocationService: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    var onCityFound: ((City, CLLocationCoordinate2D) -> Void)?
    var onError: ((Error) -> Void)?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            locationManager.stopUpdatingLocation()
            
            geocoder.reverseGeocodeLocation(location, preferredLocale: Locale(identifier: "en_US")) { [weak self] placemarks, error in
                if let error = error {
                    self?.onError?(error)
                    return
                }
                
                if let placemark = placemarks?.first, let cityName = placemark.locality {
                    let city = City(name: cityName)
                    let coordinates = location.coordinate
                    self?.onCityFound?(city, coordinates)
                } else {
                    let error = NSError(domain: "CityLocationService", code: 404, userInfo: [NSLocalizedDescriptionKey: "City not found"])
                    self?.onError?(error)
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        onError?(error)
    }
}
