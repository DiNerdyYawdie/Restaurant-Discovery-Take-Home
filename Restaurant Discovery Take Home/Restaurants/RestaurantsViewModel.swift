//
//  RestaurantsViewModel.swift
//  Restaurant Discovery Take Home
//
//  Created by Chad-Michael Muirhead on 9/20/24.
//
import Foundation
import _MapKit_SwiftUI
import Combine

@MainActor
class RestaurantsViewModel: ObservableObject {
    
    @Published var userLocation: CLLocation?
    
    @Published var restaurants: [Restaurant] = []
    @Published var selectedRestaurant: Restaurant?
    @Published var mapCoordinateRegion: MKCoordinateRegion = .init()
    
    @Published var searchText: String = ""
    
    @Published var showMapView: Bool = false
    
    @Published var permissionsAlertTitle: String = .goToSettingsTitle
    @Published var showPermissionsAlert: Bool = false
    
    @Published var isLoading: Bool = false
    let userDefaults: UserDefaults
    
    let restaurantServices: RestaurantServices
    let locationServices: LocationServices
    
    var cancellables: Set<AnyCancellable> = []
    
    init(restaurantServices: RestaurantServices, locationServices: LocationServices, userDefaults: UserDefaults = .standard) {
        self.restaurantServices = restaurantServices
        self.locationServices = locationServices
        self.userDefaults = userDefaults
        
        listenForLocationAuthorizationChanges()
    }
    
    // Check if there was any change to the user location authorization permissions
    func checkLocationAuthorization() async {
        let locationAuthorizationStatus = locationServices.checkLocationAuthorization()
        
        switch locationAuthorizationStatus {
        case .authorized:
            await fetchNearbyRestaurants()
        case .denied:
            showPermissionsAlert.toggle()
        case .notDetermined:
            locationServices.requestWhenInUseAuthorization()
        }
    }
    
    // Listen for any changes to users location permissions
    /// Using Delegate function `didChangeAuthorization` from `CoreLocation`
    func listenForLocationAuthorizationChanges() {
        locationServices.locationAuthorizationStatusPublisher
            .receive(on: RunLoop.main)
            .dropFirst()
            .sink { [weak self] in
                Task {
                    await self?.checkLocationAuthorization()
                }
            }
            .store(in: &cancellables)
    }
    
    /// Find restaurants based on user location
    func fetchNearbyRestaurants() async {
        do {
            self.userLocation = try locationServices.fetchCurrentLocation()
            guard let userLocation = self.userLocation else { return }
            
            self.mapCoordinateRegion = .init(center: userLocation.coordinate,
                                             latitudinalMeters: 1000,
                                             longitudinalMeters: 1000)
            
            let restaurants = try await restaurantServices.fetchNearbyRestaurants(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude, query: searchText)
            self.restaurants = restaurants
        } catch {
            print(error)
        }
    }
    
    // Search for restaurants based on user search term in Textfield
    @MainActor
    func searchRestaurants() async {
        do {
            isLoading = true
            self.restaurants = try await restaurantServices.searchRestaurants(with: searchText)
            if let restaurantLocation = restaurants.first?.location {
                self.mapCoordinateRegion = .init(center: .init(latitude: restaurantLocation.latitude, longitude: restaurantLocation.longitude),
                                                 latitudinalMeters: 10000,
                                                 longitudinalMeters: 10000)
            }
            
            isLoading = false
        } catch {
            isLoading = false
            print(error)
        }
    }
    
    // Navigate to Settings to toggle location persmissions
    func openSettingsToEnableLocationServices() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(settingsURL)
    }
}

// MARK: Favoriting a Restaurant
// Saved locally using UserDefaults
extension RestaurantsViewModel {
    
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
