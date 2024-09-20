//
//  RestaurantServices.swift
//  Restaurant Discovery Take Home
//
//  Created by Chad-Michael Muirhead on 9/20/24.
//

import Foundation

protocol RestaurantServices {
    func searchRestaurants(with query: String) async throws -> [Restaurant]
    func fetchNearbyRestaurants() async throws -> [Restaurant]
}

enum RestaurantServicesError: Error {
    case urlError
    case decodeError
    case httpError
    case unknown
}

class RestaurantServicesImpl: RestaurantServices {
    
    private let apiKey: String = "AIzaSyAvAaPcSL1SNPUguENa_p2P-SuRaxGUduw"
    
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
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
        let requestBody: [String: Any] = ["textQuery": query]
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw RestaurantServicesError.httpError
            }
            
            let restaurantResponse = try JSONDecoder().decode(RestaurantResponse.self, from: data)
            return restaurantResponse.places
        } catch let decodingError as DecodingError {
            print(decodingError)
            throw RestaurantServicesError.decodeError
        } catch is URLError {
            throw RestaurantServicesError.urlError
        } catch {
            throw RestaurantServicesError.unknown
        }
    }
    
    func fetchNearbyRestaurants() async throws -> [Restaurant] {
        return []
    }
}
