//
//  Endpoints.swift
//  Restaurant Discovery Take Home
//
//  Created by Chad-Michael Muirhead on 9/20/24.
//

import Foundation

enum Endpoints {
    case restaurantsNearby
    case restaurantsSearch
    
    // Base URL for the Places API
    private var baseURL: String {
        return "https://places.googleapis.com/v1"
    }
    
    var apiKey: String {
        return "AIzaSyAvAaPcSL1SNPUguENa_p2P-SuRaxGUduw"
    }
    
    var endpoint: String {
        switch self {
            
        case .restaurantsNearby:
            // TODO: Update endpoint
            return "\(baseURL)/places:searchNearby"
        case .restaurantsSearch:
            return "\(baseURL)/places:searchText"
        }
    }
    
}
