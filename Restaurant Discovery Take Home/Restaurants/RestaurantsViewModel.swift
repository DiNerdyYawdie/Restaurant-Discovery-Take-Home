//
//  RestaurantsViewModel.swift
//  Restaurant Discovery Take Home
//
//  Created by Chad-Michael Muirhead on 9/20/24.
//
import Foundation
import _MapKit_SwiftUI

@MainActor
class RestaurantsViewModel: ObservableObject {
    
    @Published var userLocation: CLLocation?
    
    @Published var restaurants: [Restaurant] = []
    @Published var selectedRestaurant: Restaurant?
    @Published var mapCoordinateRegion: MKCoordinateRegion = .init()
    
    @Published var searchText: String = ""
    
    @Published var showMapView: Bool = false
    
    @Published var isLoading: Bool = false
    
    let restaurantServices: RestaurantServices
    let locationServices: LocationServices
    
    init(restaurantServices: RestaurantServices, locationServices: LocationServices) {
        self.restaurantServices = restaurantServices
        self.locationServices = locationServices
    }
    
    @MainActor
    func fetchNearbyRestaurants() async {
        locationServices.checkLocationAuthorization()
        do {
            self.userLocation = try locationServices.fetchCurrentLocation()
            guard let userLocation = self.userLocation else { return }
            
            self.mapCoordinateRegion = .init(center: userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            
            let restaurants = try await restaurantServices.fetchNearbyRestaurants(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude, query: searchText)
            self.restaurants = restaurants
        } catch {
            print(error)
        }
    }
    
    @MainActor
    func searchRestaurants() async {
        do {
            isLoading = true
            self.restaurants = try await restaurantServices.searchRestaurants(with: searchText)
            isLoading = false
        } catch {
            isLoading = false
            print(error)
        }
    }
}
