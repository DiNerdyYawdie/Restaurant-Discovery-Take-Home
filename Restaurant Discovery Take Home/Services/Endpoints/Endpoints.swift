//
//  Endpoints.swift
//  Restaurant Discovery Take Home
//
//  Created by Chad-Michael Muirhead on 9/20/24.
//

import Foundation

enum Endpoints {
    case restaurantsNearby(latitude: Double, longitude: Double)
    case restaurantsSearch
    
    // Base URL for the Places API
    private var baseURL: String {
        return "https://places.googleapis.com/v1"
    }
    
    // API Key for Google Places
    private var apiKey: String {
        return "AIzaSyAvAaPcSL1SNPUguENa_p2P-SuRaxGUduw"
    }

    var endpoint: String {
        switch self {
        
        case .restaurantsNearby(latitude: let latitude, longitude: let longitude):
            // TODO: Update endpoint
            return "\(baseURL)/places:searchNearby?fields=*&key=\(apiKey)&location=\(latitude),\(longitude)&language=en"
        case .restaurantsSearch:
            return "\(baseURL)/places:searchText"
        }
    }
    
}
