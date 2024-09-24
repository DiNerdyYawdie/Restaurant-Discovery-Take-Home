//
//  LocationAuthorizationStatus.swift
//  Restaurant Discovery Take Home
//
//  Created by Chad-Michael Muirhead on 9/24/24.
//

import Foundation

enum LocationAuthorizationStatus: String, Codable {
    case notDetermined
    case denied
    case authorized
}
