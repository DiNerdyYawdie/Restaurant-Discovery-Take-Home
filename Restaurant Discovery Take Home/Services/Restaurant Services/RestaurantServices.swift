//
//  RestaurantServices.swift
//  Restaurant Discovery Take Home
//
//  Created by Chad-Michael Muirhead on 9/20/24.
//

import Foundation

protocol RestaurantServices {
    func searchRestaurants(with query: String) async throws -> [Restaurant]
    func fetchNearbyRestaurants(latitude: Double, longitude: Double, query: String) async throws -> [Restaurant]
}

enum RestaurantServicesError: Error {
    case urlError
    case decodeError
    case httpError
    case unknown
    
    // Can be used to show readbale error messages in an Alert
    var errorMessage: String {
        switch self {
        case .urlError: return "There was an error creating the URL"
        case .decodeError: return "There was an error decoding the response."
        case .httpError: return "There was an error with the HTTP request."
        case .unknown: return "An unknown error occurred."
        }
    }
}

class RestaurantServicesImpl: RestaurantServices {
    
    private let apiKey: String = "AIzaSyAvAaPcSL1SNPUguENa_p2P-SuRaxGUduw"
    
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // Search for restaurants by text/query
    func searchRestaurants(with query: String) async throws -> [Restaurant] {
        guard let url = URL(string: Endpoints.restaurantsSearch.endpoint) else {
            throw RestaurantServicesError.urlError
        }
        
        // Create request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Add headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(apiKey, forHTTPHeaderField: "X-Goog-Api-Key")
        request.addValue("*", forHTTPHeaderField: "X-Goog-FieldMask")
        
        // Create the JSON body
        let requestBody: [String: Any] = ["textQuery": query,
                                          "includedType": "restaurant"]
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw RestaurantServicesError.httpError
            }
            
            let restaurantResponse = try JSONDecoder().decode(RestaurantResponse.self, from: data)
            return restaurantResponse.places ?? []
        } catch let decodingError as DecodingError {
            print(decodingError)
            throw RestaurantServicesError.decodeError
        } catch is URLError {
            throw RestaurantServicesError.urlError
        } catch {
            throw RestaurantServicesError.unknown
        }
    }
    
    // Find restaurants nearby based on user location
    func fetchNearbyRestaurants(latitude: Double, longitude: Double, query: String) async throws -> [Restaurant] {
        guard let url = URL(string: Endpoints.restaurantsNearby.endpoint) else {
            throw RestaurantServicesError.urlError
        }
        
        // Create request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Add headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(apiKey, forHTTPHeaderField: "X-Goog-Api-Key")
        request.addValue("*", forHTTPHeaderField: "X-Goog-FieldMask")
        
        // Create the JSON body
        let requestBody = NearbyRequest(includedTypes: ["restaurant"], locationRestriction: LocationRestriction(circle: LocationCircle(center: LocationCircleCoordinates(latitude: latitude, longitude: longitude), radius: 500.0)))
                request.httpBody = try JSONEncoder().encode(requestBody)
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw RestaurantServicesError.httpError
            }
            
            let restaurantResponse = try JSONDecoder().decode(RestaurantResponse.self, from: data)
            return restaurantResponse.places ?? []
        } catch let decodingError as DecodingError {
            print(decodingError)
            throw RestaurantServicesError.decodeError
        } catch is URLError {
            throw RestaurantServicesError.urlError
        } catch {
            throw RestaurantServicesError.unknown
        }
    }
}

