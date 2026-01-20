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
      VStack(alignment: .leading, spacing: 16) {
        headerView
        if presenter.isLoading {
          ProgressView()
        } else {
          gameList
        }
      }
      .frame(maxWidth: .infinity, alignment: .center)
      .padding(.horizontal, 16)
    }
    .task {
      await presenter.getGames()
    }
  }
  
  var headerView: some View {
    HeaderView(
      title: "Free Games",
      subtitle: "Discover amazing free games to play"
    )
  }
  
  var gameList: some View {
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

#Preview {
  HomeView()
}
