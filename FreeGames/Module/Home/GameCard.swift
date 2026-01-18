//
//  GameCard.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 17/01/26.
//

import SwiftUI
import CachedAsyncImage

struct GameCard: View {
  let game: GameModel
  let isFavorite: Bool
  let onFavoriteToggle: () -> Void
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      // Image
      ZStack(alignment: .topTrailing) {
        CachedAsyncImage(url: URL(string: game.thumbnail)) { image in
          image
            .resizable()
            .aspectRatio(contentMode: .fill)
        } placeholder: {
          ProgressView()
        }
        .frame(height: 200)
        .clipped()
        
        // Favorite Button
        Button {
          onFavoriteToggle()
        } label: {
          Image(systemName: isFavorite ? "heart.fill" : "heart")
            .foregroundStyle(isFavorite ? .red : .gray)
            .padding(8)
            .background(.ultraThinMaterial)
            .clipShape(Circle())
        }
        .padding(12)
      }
      
      // Content
      VStack(alignment: .leading, spacing: 16) {
        Text(game.title)
          .font(.headline)
          .foregroundColor(.primary)
        
        // Platforms
        FlowLayout(spacing: 6) {
          ForEach(game.platforms, id: \.self) { platform in
            Text(platform)
              .font(.caption)
              .fontWeight(.medium)
              .foregroundColor(.blue)
              .padding(.horizontal, 8)
              .padding(.vertical, 4)
              .background(Color.blue.opacity(0.1))
              .cornerRadius(8)
              .fixedSize(horizontal: true, vertical: false)
          }
        }
      }
      .padding(16)
    }
    .background(Color(.systemBackground))
    .cornerRadius(16)
    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    .padding(.horizontal)
    .padding(.vertical, 4)
  }
}

#Preview {
  let game = GameModel(
    id: 3458,
    title: "The Elder Scrolls Online: Experience Scroll Key Giveaway",
    price: "$4.99",
    thumbnail: "https://www.gamerpower.com/offers/1/696919eae6066.jpg",
    description: "Dumb Ways to Die is free this week on the Epic Games Store App for iPhone, iPad, and Android.",
    type: "Game",
    platforms: ["PC", "Playstation 4", "Xbox One", "Nintendo Switch", "Android", "iOS"],
    url: "https://www.gamerpower.com/dumb-ways-to-die-mobile-giveaway"
  )
  GameCard(game: game, isFavorite: false, onFavoriteToggle: {})
}
