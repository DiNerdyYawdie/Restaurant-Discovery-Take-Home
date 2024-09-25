//
//  Mocks.swift
//  Restaurant Discovery Take HomeTests
//
//  Created by Chad-Michael Muirhead on 9/24/24.
//

import Foundation
@testable import Restaurant_Discovery_Take_Home

class MockRestaurantServicesImpl: RestaurantServices {
    
    var nearbyRestaurantsResult: Result<[Restaurant], RestaurantServicesError>?
    var searchRestaurantsResult: Result<[Restaurant], RestaurantServicesError>?
    
    func fetchNearbyRestaurants(latitude: Double, longitude: Double, query: String) async throws -> [Restaurant] {
        switch nearbyRestaurantsResult {
        case .success(let restaurants):
            return restaurants
        case .failure(let error):
            throw error
        case .none:
            throw RestaurantServicesError.unknown
        }
    }
    
    func searchRestaurants(with query: String) async throws -> [Restaurant] {
        switch searchRestaurantsResult {
        case .success(let restaurants):
            return restaurants
        case .failure(let error):
            throw error
        case .none:
            throw RestaurantServicesError.unknown
        }
    }
}
