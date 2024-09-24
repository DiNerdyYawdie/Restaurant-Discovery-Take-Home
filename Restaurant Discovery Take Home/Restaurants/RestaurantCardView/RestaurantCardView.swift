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
                    .font(.callout)
                    .fontWeight(.bold)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                
                // Placeholder for rating and reviews
                HStack {
                    Image(.star)
                        .resizable()
                        .frame(width: 16, height: 16)
                    
                    Text(String(restaurant.rating ?? 0))
                        
                    Text("•")
                    
                    Text("(\(restaurant.userRatingCount ?? 0))")
                        .foregroundColor(.gray)
                }
                .font(.footnote)
                
                if let supportText = restaurant.generativeSummary?.overview?.text {
                    // Supporting text placeholder
                    Text(supportText)
                        .font(.footnote)
                        .lineLimit(1)
                        .foregroundColor(.gray)
                }
                
            }
            
            Spacer()
            
            // Bookmark icon placeholder
            Button(action: {
                onFavoriteSelected(restaurant)
            }) {
                Image(.bookmarkResting)
                    .foregroundColor(.green)
                    .frame(width: 24, height: 24)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color("card-shadow").opacity(0.2), radius: 5, x: 0, y: 16)
    }
}


#Preview {
    RestaurantCardView(restaurant: Restaurant(id: UUID().uuidString, types: ["Jamaican"], formattedAddress: "1 Hayes Lane", rating: 4.0, userRatingCount: 100, displayName: RestaurantLocalizedText(text: "Jahmske"), photos: [RestaurantPhotos(name: "", widthPx: 1, heightPx: 1)], location: RestaurantLocation(latitude: 0, longitude: 0), generativeSummary: nil)) { _ in
        
    }
}
