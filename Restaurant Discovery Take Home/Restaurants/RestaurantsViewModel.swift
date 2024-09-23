//
//  RestaurantsViewModel.swift
//  Restaurant Discovery Take Home
//
//  Created by Chad-Michael Muirhead on 9/20/24.
//

import Foundation

class RestaurantsViewModel: ObservableObject {
    
    @Published var restaurants: [Restaurant] = []
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
            let location = try locationServices.fetchCurrentLocation()
            
            let restaurants = try await restaurantServices.fetchNearbyRestaurants(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, query: searchText)
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
