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
                    .padding(.vertical, 6)
                    .submitLabel(.search)
                    .onSubmit {
                        Task {
                            await viewModel.fetchNearbyRestaurants()
                        }
                    }
            }
            .padding(.horizontal)
            .background(Color("background-color"))
            .cornerRadius(25)
            .shadow(radius: 1)
            .padding(.horizontal)
            .padding(.bottom, 15)
            
            
            if viewModel.showMapView {
                
                Map(coordinateRegion: $viewModel.mapCoordinateRegion,
                    showsUserLocation: true,
                    annotationItems: viewModel.restaurants) { restaurant in
                    
                    MapAnnotation(coordinate: .init(latitude: restaurant.location.latitude,
                                                    longitude: restaurant.location.longitude)) {
                        
                        VStack {
                            
                            Button {
                                viewModel.selectedRestaurant = restaurant
                                
                                withAnimation {
                                    viewModel.mapCoordinateRegion.center = .init(latitude: restaurant.location.latitude, longitude: restaurant.location.longitude)
                                }
                            } label: {
                                Image(viewModel.selectedRestaurant == restaurant ? .pinSelected : .pinResting)
                                    .resizable()
                                    .frame(width: 26, height: 33)
                            }
                            .buttonStyle(.plain)
                            
                        }
                        .overlay(alignment: .bottom) {
                            if viewModel.selectedRestaurant == restaurant {
                                withAnimation {
                                    RestaurantCardView(isFavorite: .constant(viewModel.checkIfFavorite(restaurant: restaurant)), restaurant: restaurant) { restaurant in
                                        viewModel.updateFavorite(restaurant: restaurant)
                                    }
                                    .frame(width: UIScreen.main.bounds.width - 30)
                                    .offset(y: -50)
                                }
                                
                            }
                        }
                    }
                }
                
                
            } else {
                List(viewModel.restaurants) { restaurant in
                    
                    RestaurantCardView(isFavorite: .constant(viewModel.checkIfFavorite(restaurant: restaurant)), restaurant: restaurant) { restaurant in
                        viewModel.updateFavorite(restaurant: restaurant)
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    
                }
                .listStyle(.plain)
                .background(Color("background-color"))
            }
            
        }
        .task {
            await viewModel.fetchNearbyRestaurants()
        }
        .overlay(alignment: .centerLastTextBaseline, content: {
            Button {
                DispatchQueue.main.async {
                    viewModel.showMapView.toggle()
                }
            } label: {
                Label(LocalizedStringKey(viewModel.showMapView ? "List" : "Map"), image: viewModel.showMapView ? .whiteList : .whiteMap)
            }
            .tint(Color("trails-green"))
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .controlSize(.extraLarge)
            .frame(width: 117, height: 48)
            .padding(.bottom, 24)
        })
    }
}

#Preview {
    RestaurantsView(viewModel: RestaurantsViewModel(restaurantServices: RestaurantServicesImpl(), locationServices: LocationServicesImpl()))
}
