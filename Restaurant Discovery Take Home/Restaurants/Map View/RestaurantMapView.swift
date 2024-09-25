//
//  RestaurantMapView.swift
//  Restaurant Discovery Take Home
//
//  Created by Chad-Michael Muirhead on 9/25/24.
//
import MapKit
import SwiftUI

struct RestaurantMapView: View {
    
    @ObservedObject var viewModel: RestaurantsViewModel
    
    var body: some View {
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
                            RestaurantCardView(viewModel: RestaurantCardViewModel(restaurant: restaurant,
                                                                                  isFavorite: viewModel.checkIfFavorite(restaurant: restaurant),
                                                                                  onFavoriteSelected: { favoritedRestaurant in
                                viewModel.updateFavorite(restaurant: favoritedRestaurant)
                            }))
                            .frame(width: UIScreen.main.bounds.width - 30)
                            .offset(y: -50)
                        }
                        
                    }
                }
            }
        }
    }
}


