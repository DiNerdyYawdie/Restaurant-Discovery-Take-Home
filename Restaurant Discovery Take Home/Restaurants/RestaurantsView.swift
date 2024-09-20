//
//  RestaurantsView.swift
//  Restaurant Discovery Take Home
//
//  Created by Chad-Michael Muirhead on 9/20/24.
//

import SwiftUI

struct RestaurantsView: View {
    
    @ObservedObject var viewModel: RestaurantsViewModel
    
    var body: some View {
        VStack {
            Text("Restaurants")
        }
        .task {
            await viewModel.fetchRestaurants()
        }
    }
}

#Preview {
    RestaurantsView(viewModel: RestaurantsViewModel(restaurantServices: RestaurantServicesImpl()))
}
