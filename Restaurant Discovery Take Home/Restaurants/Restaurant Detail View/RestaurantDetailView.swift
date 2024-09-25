//
//  RestaurantDetailView.swift
//  Restaurant Discovery Take Home
//
//  Created by Chad-Michael Muirhead on 9/25/24.
//
import SDWebImageSwiftUI
import SwiftUI

struct RestaurantDetailView: View {
    
    let restaurant: Restaurant
    @Binding var isPresented: Bool
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                closeButton
                
                
                Text(restaurant.displayName.text)
                    .font(.title)
                    .fontWeight(.bold)
                
                Label(LocalizedStringKey(restaurant.formattedAddress), systemImage: "mappin.circle")
                    .font(.subheadline)
                
                if let restaurantPhotoURL = restaurant.photoURL {
                    WebImage(url: restaurantPhotoURL) { image in
                        image
                            .resizable()
                            .frame(height: 300)
                            .frame(maxWidth: .infinity)
                            .cornerRadius(8)
                        
                    } placeholder: {
                        Image(.placeholder)
                            .resizable()
                            .frame(height: 300)
                            .frame(maxWidth: .infinity)
                            .cornerRadius(8)
                    }
                }
                
                restaurantReviewView
                
                // Call restaurant phone button
                // Try on a real device
                if let phoneNumber = restaurant.nationalPhoneNumber {
                    Link(destination: URL(string: "tel:\(phoneNumber)")!) {
                        Label(LocalizedStringKey(.callTitle), systemImage: "phone")
                            .font(.title3)
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                DisclosureGroup(LocalizedStringKey(.openingHoursTitle)) {
                    VStack(alignment: .leading) {
                        ForEach(restaurant.regularOpeningHours.weekdayDescriptions, id: \.self) { weekdayDescription in
                            Text(weekdayDescription)
                        }
                    }
                }
                .tint(.trailsGreen)
                
                
                // Description View
                Section {
                    VStack(alignment: .leading) {
                        GroupBox {
                            if let supportText = restaurant.generativeSummary?.overview?.text {
                                // Supporting text placeholder
                                Text(supportText)
                                    .font(.subheadline)
                                    .lineLimit(2)

                            }
                        }
                        
                        if let restaurantSummary = restaurant.generativeSummary?.description?.text {
                            Text(restaurantSummary)
                        }
                    }
                } header: {
                    
                    Text(verbatim: .descriptionTitle)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.top)
                }
                
                
            }
            .padding()
        }
    }
    
    var closeButton: some View {
        Button {
            isPresented.toggle()
        } label: {
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .frame(width: 40, height: 40)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .tint(.gray)
    }
    
    var restaurantReviewView: some View {
        HStack {
            Image(.star)
                .resizable()
                .frame(width: 16, height: 16)
            
            Text(String(restaurant.rating ?? 0))
            
            Text("•")
            
            Text("(\(restaurant.userRatingCount ?? 0)) \(.reviewsText)")
                .foregroundColor(.gray)
        }
        .font(.title3)
    }
}

#Preview {
    RestaurantDetailView(restaurant: Restaurant(id: "1234", formattedAddress: "1 Highway Ave", rating: 4, userRatingCount: 4, displayName: RestaurantLocalizedText(text: "Ms Lilys"), photos: [], location: RestaurantLocation(latitude: 40.730610, longitude: -73.935242), generativeSummary: nil, regularOpeningHours: RegularOpeningHours(openNow: true, weekdayDescriptions: [""]), nationalPhoneNumber: "800123456789"), isPresented: .constant(true))
}
