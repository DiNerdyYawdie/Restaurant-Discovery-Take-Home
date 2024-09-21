//
//  RestaurantCardView.swift
//  Restaurant Discovery Take Home
//
//  Created by Chad-Michael Muirhead on 9/20/24.
//

import SwiftUI

struct RestaurantCardView: View {
    
    let restaurant: Restaurant
    let onFavoriteSelected: (Restaurant) -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            
            // Image placeholder
            Image(systemName: "photo")
                .resizable()
                .frame(width: 80, height: 80)
                .aspectRatio(contentMode: .fill)
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 8) {
                // Placeholder for restaurant name
                Text(restaurant.displayName.text)
                    .font(.headline)
                
                // Placeholder for rating and reviews
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.green)
                    Text(String(restaurant.rating))
                    Text("•")
                    Text("(reviews)")
                        .foregroundColor(.gray)
                }
                .font(.subheadline)
                
                // Supporting text placeholder
                Text("{supporting text}")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Bookmark icon placeholder
            Button(action: {
                onFavoriteSelected(restaurant)
            }) {
                Image(systemName: "bookmark")
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}


#Preview {
    RestaurantCardView(restaurant: Restaurant(id: UUID().uuidString, types: ["Jamaican"], formattedAddress: "1 Hayes Lane", rating: 4.0, displayName: RestaurantDisplayName(text: "Jahmske"))) { _ in
        
    }
}
