//
//  FavoriteView.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 18/01/26.
//

import SwiftUI

struct FavoriteView: View {
  @EnvironmentObject var presenter: FavoritePresenter
  
  var body: some View {
    ScrollView {
      if presenter.isLoading {
        ProgressView()
      } else if presenter.games.isEmpty {
        emptyView
      } else {
        ForEach(presenter.games) { game in
          self.presenter.linkBuilder(for: game) {
            GameCard(
              game: game,
              isFavorite: presenter.isFavorite(game.id),
              onFavoriteToggle: {
                presenter.toggleFavorite(for: game.id)
              }
            )
          }
          .buttonStyle(.plain)
        }
      }
    }
    .padding(.bottom, 16)
    .task {
      await presenter.getGames()
    }
  }
  
  var emptyView: some View {
    VStack(alignment: .center, spacing: 16) {
      Image(systemName: "heart.slash")
        .font(.system(size: 64))
        .foregroundStyle(.gray.opacity(0.5))
      
      Text("No favorite game yet")
        .font(.title3)
        .foregroundStyle(.secondary)
      
      Text("Tap the heart icon to add games to favorites")
        .font(.subheadline)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, 100)
  }
}

#Preview {
  FavoriteView()
}
