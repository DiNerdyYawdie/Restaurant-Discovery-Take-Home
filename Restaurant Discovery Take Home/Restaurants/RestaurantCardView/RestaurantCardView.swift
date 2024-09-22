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
            Image(.placeholder)
                .resizable()
                .frame(width: 64, height: 72)
                .aspectRatio(contentMode: .fill)
            
            VStack(alignment: .leading, spacing: 8) {
                // Placeholder for restaurant name
                Text(restaurant.displayName.text)
                    .font(.headline)
                
                // Placeholder for rating and reviews
                HStack {
                    Image(.star)
                        .resizable()
                        .frame(width: 16, height: 16)
                    
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
                Image(.bookmarkResting)
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
    RestaurantCardView(restaurant: Restaurant(id: UUID().uuidString, types: ["Jamaican"], formattedAddress: "1 Hayes Lane", rating: 4.0, displayName: RestaurantDisplayName(text: "Jahmske"), photos: [RestaurantPhotos(name: "", widthPx: 1, heightPx: 1)])) { _ in
        
    }
}
