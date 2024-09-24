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
    
    private var apiKey: String {
        return "AIzaSyAvAaPcSL1SNPUguENa_p2P-SuRaxGUduw"
    }
    // https://places.googleapis.com/v1/places/ChIJ53I1Yn2AhYAR_Vl1vNygfMg/photos/AXCi2Q4lzgm8fCRtHZrfmjKZ32lu_B1MKl2fLSR9Vtr2v8Uk4RDL_wn9xSdSO8WxLe-1GgcoGoSwoFHcMefvh3lN1QvGckBpKqceIDrq-DTnFgyhybsYV4g43hqK1TyB-2d2h-Xb7Bjh8u9887ayW4xRNlAL7Rzau4XXfotG/media?maxWidthPx=400&key=AIzaSyAvAaPcSL1SNPUguENa_p2P-SuRaxGUduw
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
