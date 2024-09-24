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
    let userDefaults: UserDefaults
    
    let restaurantServices: RestaurantServices
    let locationServices: LocationServices
    
    init(restaurantServices: RestaurantServices, locationServices: LocationServices, userDefaults: UserDefaults = .standard) {
        self.restaurantServices = restaurantServices
        self.locationServices = locationServices
        self.userDefaults = userDefaults
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
            dump(restaurants)
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
    
    func updateFavorite(restaurant: Restaurant) {
        // Get previously Favorited restaurants from `userDefaults`
        var favoriteRestaurants = userDefaults.getFavorites()
        
        if let index = restaurants.firstIndex(where: { $0.id == restaurant.id }) {
            
            // If the restaurant was Favorited, it will now be toggled to Unfavorite
            if restaurant.isFavorite {
                if let indexToRemove = favoriteRestaurants.firstIndex(where: { $0 == restaurant.id }) {
                    favoriteRestaurants.remove(at: indexToRemove)
                    
                    // Remove Restaurant ID from Favorites
                    userDefaults.removeFavorite(restaurant: restaurant)
                }
            } else {

                favoriteRestaurants.append(restaurant.id)
                // Add Restaurant ID from Favorites
                userDefaults.saveFavorite(restaurant: restaurant)
            }

            // Toggle the image flafg for the bookmark(favorite) button
            restaurants[index].isFavorite.toggle()
            
        }
    }
    
    func checkIfFavorite(restaurant: Restaurant) -> Bool {
        let favoriteRestaurants = userDefaults.getFavorites()
        return favoriteRestaurants.contains(restaurant.id)
    }
}
