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
                .padding(.top, 20)
                .padding(.bottom, 16)
            
            HStack(spacing: 8) {
                Image(.search)
                
                TextField("Search restaurants", text: $viewModel.searchText)
                    .submitLabel(.search)
                    .onSubmit {
                        Task {
                            await viewModel.fetchNearbyRestaurants()
                        }
                    }
            }
            .padding(.horizontal)
            .background(Color(.systemGray6))
            .cornerRadius(25)
            .shadow(radius: 1)
            .padding(.horizontal)
            .padding(.bottom, 15)
            ZStack(alignment: .centerLastTextBaseline) {
                
                if viewModel.showMapView {
                    Text("Map")
                } else {
                    List(viewModel.restaurants) { restaurant in
                        
                        RestaurantCardView(restaurant: restaurant) { restaurant in
                            
                        }
                        .listRowBackground(Color.clear)
                        
                    }
                    .listStyle(.plain)
                    .background(Color(.systemGray6))
                }
                
                Button {
                    viewModel.showMapView.toggle()
                } label: {
                    Label(LocalizedStringKey("Map"), image: .map)
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
            }
            
        }
        .task {
            await viewModel.fetchNearbyRestaurants()
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
    }
}

#Preview {
    RestaurantsView(viewModel: RestaurantsViewModel(restaurantServices: RestaurantServicesImpl(), locationServices: LocationServicesImpl()))
}
