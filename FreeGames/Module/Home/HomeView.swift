//
//  HomeView.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 16/01/26.
//

import SwiftUI

struct HomeView: View {
  @EnvironmentObject var presenter: HomePresenter
  
  var body: some View {
    ScrollView {
      VStack(alignment: .center, spacing: 16) {
        headerView
        
        if presenter.isLoading {
          ProgressView()
        } else {
          ForEach(presenter.games) { game in
            GameCard(
              game: game,
              isFavorite: presenter.isFavorite(game.id),
              onFavoriteToggle: {
                presenter.toggleFavorite(for: game.id)
              }
            )
          }
        }
      }
      .padding(.bottom, 16)
    }
    .task {
      await presenter.getGames()
    }
  }
  
  private var headerView: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text("Free Games")
        .font(.largeTitle)
        .fontWeight(.bold)
      
      Text("Discover amazing free games to play")
        .font(.subheadline)
        .foregroundStyle(.secondary)
    }
    .padding(.horizontal)
    .padding(.top, 8)
  }
}

#Preview {
  HomeView()
}
