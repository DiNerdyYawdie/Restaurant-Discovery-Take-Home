//
//  RestaurantCardView.swift
//  Restaurant Discovery Take Home
//
//  Created by Chad-Michael Muirhead on 9/20/24.
//

import SwiftUI

struct RestaurantCardView: View {
    
    @ObservedObject var viewModel: RestaurantCardViewModel
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            
            AsyncImage(url: viewModel.createRestaurantPhotoURL()) { image in
                image
                    .resizable()
                    .frame(width: 64, height: 72)
                    .aspectRatio(contentMode: .fill)
                
            } placeholder: {
                // Image placeholder
                Image(.placeholder)
                    .resizable()
                    .frame(width: 64, height: 72)
                    .aspectRatio(contentMode: .fill)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                // Placeholder for restaurant name
                Text(viewModel.restaurant.displayName.text)
                    .font(.callout)
                    .fontWeight(.bold)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                
                // Placeholder for rating and reviews
                HStack {
                    Image(.star)
                        .resizable()
                        .frame(width: 16, height: 16)
                    
                    Text(String(viewModel.restaurant.rating ?? 0))
                        
                    Text("•")
                    
                    Text("(\(viewModel.restaurant.userRatingCount ?? 0))")
                        .foregroundColor(.gray)
                }
                .font(.footnote)
                
                if let supportText = viewModel.restaurant.generativeSummary?.overview?.text {
                    // Supporting text placeholder
                    Text(supportText)
                        .font(.footnote)
                        .lineLimit(1)
                        .foregroundColor(.gray)
                }
                
            }
            
            Spacer()

            Image(viewModel.isFavorite ? .bookmarkSaved : .bookmarkResting)
                .foregroundColor(.green)
                .frame(width: 24, height: 24)
                .onTapGesture {
                    viewModel.onFavoriteSelected(viewModel.restaurant)
                }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color("card-shadow").opacity(0.2), radius: 5, x: 0, y: 16)
    }
}
