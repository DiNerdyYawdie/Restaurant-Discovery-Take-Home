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
                
                TextField(LocalizedStringKey(.textFieldPlaceholder), text: $viewModel.searchText)
                    .padding(.vertical, 6)
                    .submitLabel(.search)
                    .onSubmit {
                        Task {
                            await viewModel.searchRestaurants()
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
                
                
            } else {
                List(viewModel.restaurants) { restaurant in
                    
                    RestaurantCardView(viewModel: RestaurantCardViewModel(restaurant: restaurant,
                                                                          isFavorite: viewModel.checkIfFavorite(restaurant: restaurant),
                                                                          onFavoriteSelected: { favoritedRestaurant in
                        viewModel.updateFavorite(restaurant: favoritedRestaurant)
                    }))
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    
                }
                .listStyle(.plain)
                .background(Color("background-color"))
            }
            
        }
        .task {
            await viewModel.checkLocationAuthorization()
        }
        .overlay(content: {
            if viewModel.isLoading {
                ProgressView()
                    .tint(Color(.trailsGreen))
            }
        })
        .overlay(alignment: .centerLastTextBaseline, content: {
            Button {
                DispatchQueue.main.async {
                    viewModel.showMapView.toggle()
                }
            } label: {
                Label(LocalizedStringKey(viewModel.showMapView ? .listButtonTitle : .mapButtonTitle), image: viewModel.showMapView ? .whiteList : .whiteMap)
            }
            .tint(Color(.trailsGreen))
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .controlSize(.extraLarge)
            .frame(width: 117, height: 48)
            .padding(.bottom, 24)
        })
        .alert(isPresented: $viewModel.showPermissionsAlert) {
            Alert(title: Text(viewModel.permissionsAlertTitle), primaryButton: .default(Text(verbatim: .goToSettingsButtonTitle), action: {
                viewModel.openSettingsToEnableLocationServices()
            }), secondaryButton: .cancel())
        }
    }
}

#Preview {
    RestaurantsView(viewModel: RestaurantsViewModel(restaurantServices: RestaurantServicesImpl(), locationServices: LocationServicesImpl()))
}
