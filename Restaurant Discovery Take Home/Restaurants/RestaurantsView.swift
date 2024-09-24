//
//  RestaurantsView.swift
//  Restaurant Discovery Take Home
//
//  Created by Chad-Michael Muirhead on 9/20/24.
//
import MapKit
import SwiftUI

struct RestaurantsView: View {
    
    @StateObject var viewModel: RestaurantsViewModel
    
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
            
                
                if viewModel.showMapView {
                    
                    Map(coordinateRegion: $viewModel.mapCoordinateRegion, showsUserLocation: true, annotationItems: viewModel.restaurants) { restaurant in
                        
                        MapAnnotation(coordinate: .init(latitude: restaurant.location.latitude, longitude: restaurant.location.longitude)) {
                            
                            Image(viewModel.selectedRestaurant == restaurant ? .pinSelected : .pinResting)
                                .resizable()
                                .frame(width: 26, height: 33)
                                .onTapGesture {
                                    viewModel.selectedRestaurant = restaurant
                                }
                        }
                    }
                    
                } else {
                    List(viewModel.restaurants) { restaurant in
                        
                        RestaurantCardView(restaurant: restaurant) { restaurant in
                            
                        }
                        .listRowBackground(Color.clear)
                        
                    }
                    .listStyle(.plain)
                    .background(Color(.systemGray6))
                }

        }
        .task {
            await viewModel.fetchNearbyRestaurants()
        }
        .overlay(alignment: .centerLastTextBaseline, content: {
            Button {
                viewModel.showMapView.toggle()
            } label: {
                Label(LocalizedStringKey(viewModel.showMapView ? "List" : "Map"), image: viewModel.showMapView ? .list : .map)
            }
            .tint(.green)
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .controlSize(.extraLarge)
            .frame(height: 48)
            .padding(.bottom, 24)
        })
    }
}

#Preview {
    RestaurantsView(viewModel: RestaurantsViewModel(restaurantServices: RestaurantServicesImpl(), locationServices: LocationServicesImpl()))
}
