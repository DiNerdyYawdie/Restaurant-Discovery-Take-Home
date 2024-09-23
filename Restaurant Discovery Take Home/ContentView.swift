//
//  ContentView.swift
//  Restaurant Discovery Take Home
//
//  Created by Chad-Michael Muirhead on 9/20/24.
//

import SwiftUI

struct ContentView: View {
    
    let restaurantServices: RestaurantServices = RestaurantServicesImpl()
    
    var body: some View {
        RestaurantsView(viewModel: RestaurantsViewModel(restaurantServices: restaurantServices, locationServices: LocationServicesImpl()))
    }
}

#Preview {
    ContentView()
}
