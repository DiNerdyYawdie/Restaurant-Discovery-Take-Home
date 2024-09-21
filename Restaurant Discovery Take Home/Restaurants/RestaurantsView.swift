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
            
            Image(.logoLockup)

            TextField("Search", text: $viewModel.searchText)
                .padding(.horizontal)
                .textFieldStyle(.roundedBorder)
                .onSubmit {
                    Task {
                        await viewModel.fetchRestaurants()
                    }
                }
            
            List(viewModel.restaurants) { restaurant in
                
                RestaurantCardView(restaurant: restaurant) { restaurant in
                    
                }
                .listRowBackground(Color.clear)
                
            }
            .listStyle(.plain)
            .background(Color(red: 239, green: 239, blue: 236))
           
        }
        .task {
            await viewModel.fetchRestaurants()
        }
    }
}

#Preview {
    RestaurantsView(viewModel: RestaurantsViewModel(restaurantServices: RestaurantServicesImpl()))
}
