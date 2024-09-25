//
//  LocationServices.swift
//  Restaurant Discovery Take Home
//
//  Created by Chad-Michael Muirhead on 9/22/24.
//
import CoreLocation
import Foundation
import Combine

protocol LocationServices {
    var locationAuthorizationStatusPublisher: PassthroughSubject<Void, Never> { get }
    func checkLocationAuthorization() -> LocationAuthorizationStatus
    func requestWhenInUseAuthorization()
    func fetchCurrentLocation() throws -> RestaurantLocation
}

enum LocationServicesError: Error {
    case locationServicesNotAvailable
    case locationNotFound
}

class LocationServicesImpl: NSObject, LocationServices {
    
    var locationAuthorizationStatusPublisher = PassthroughSubject<Void, Never>()
    var locationManager: CLLocationManager
    
    init(locationManager: CLLocationManager = CLLocationManager()) {
        
        self.locationManager = locationManager
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationAuthorization() -> LocationAuthorizationStatus {
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            return LocationAuthorizationStatus.notDetermined
        case .restricted, .denied:
            return LocationAuthorizationStatus.denied
        case .authorizedAlways, .authorizedWhenInUse:
            return LocationAuthorizationStatus.authorized
        @unknown default:
            return LocationAuthorizationStatus.denied
        }
    }
    
    func requestWhenInUseAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func fetchCurrentLocation() throws -> RestaurantLocation {
        if locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedWhenInUse {
            
            guard let userLocation = locationManager.location else {
                throw LocationServicesError.locationNotFound
            }
            return RestaurantLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        } else {
            throw LocationServicesError.locationServicesNotAvailable
        }
    }
}

extension LocationServicesImpl: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Send update that the location permissions have changed
        locationAuthorizationStatusPublisher.send(())
    }
}
