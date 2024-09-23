//
//  LocationServices.swift
//  Restaurant Discovery Take Home
//
//  Created by Chad-Michael Muirhead on 9/22/24.
//
import CoreLocation
import Foundation

protocol LocationServices {
    func checkLocationAuthorization()
    func fetchCurrentLocation() throws -> CLLocation
}

enum LocationServicesError: Error {
    case locationServicesNotAvailable
    case locationNotFound
}

class LocationServicesImpl: NSObject, LocationServices {
    
    var locationManager: CLLocationManager
    
    init(locationManager: CLLocationManager = CLLocationManager()) {
        
        self.locationManager = locationManager
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("restricted")
        case .denied:
            print("denied")
        case .authorizedAlways:
            print("authorized Always")
        case .authorizedWhenInUse:
            print("authorized wen in use")
        @unknown default:
            print("default")
        }
    }
    
    func fetchCurrentLocation() throws -> CLLocation {
        if locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedWhenInUse {
            
            guard let userLocation = locationManager.location else {
                throw LocationServicesError.locationNotFound
            }
            return userLocation
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
}
