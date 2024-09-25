//
//  MockLocationService.swift
//  Restaurant Discovery Take HomeTests
//
//  Created by Chad-Michael Muirhead on 9/24/24.
//
import Foundation
@testable import Restaurant_Discovery_Take_Home
import Combine

class MockLocationServiceImpl: LocationServices {
    var locationAuthorizationStatusPublisher = PassthroughSubject<Void, Never>()
    var mockLocationAuthStatus: LocationAuthorizationStatus = .notDetermined
    var authorizationRequested: Bool = false
    var userLocationResult: Result<RestaurantLocation, RestaurantServicesError>?
    
    func checkLocationAuthorization() -> Restaurant_Discovery_Take_Home.LocationAuthorizationStatus {
        return mockLocationAuthStatus
    }
    
    func requestWhenInUseAuthorization() {
        authorizationRequested = true
        mockLocationAuthStatus = .authorized
        locationAuthorizationStatusPublisher.send(())
    }
    
    func fetchCurrentLocation() throws -> RestaurantLocation {
        switch userLocationResult {
        case .success(let location):
            return location
        case .failure(let error):
            throw error
        case .none:
            throw RestaurantServicesError.unknown
        }
    }
    
    
}
