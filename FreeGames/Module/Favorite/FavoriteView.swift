//
//  FavoriteView.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 18/01/26.
//

import SwiftUI
import Game
import Core

struct FavoriteView: View {
  @ObservedObject var presenter: GetListPresenter<
    Any,
    GameModel,
    Interactor<
      Any,
      [GameModel],
      GetFavoriteGamesRepository<
        GetFavoriteGamesLocalDataSource,
        GamesTransformer
      >
    >
  >
  
  var body: some View {
    ScrollView {
      VStack(alignment: .center, spacing: 16) {
        headerView
        if presenter.isLoading {
          ProgressView()
        } else if presenter.list.count == 0 {
          emptyView
        } else {
          gameList
        }
      }
      .frame(maxWidth: .infinity, alignment: .center)
      .padding(.horizontal, 16)
    }
    .onAppear {
      presenter.getList(request: nil)
    }
  }
}

extension FavoriteView {
  var headerView: some View {
    HeaderView(
      title: "Favorites",
      subtitle: "Your favorite game collection"
    )
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
    .frame(maxWidth: .infinity, alignment: .center)
    .padding(.vertical, 100)
  }
  
  var gameList: some View {
    ForEach(presenter.list, id: \.id) { game in
      linkBuilder(for: game) {
        GameCard(game: game)
      }
      .buttonStyle(.plain)
    }
  }
  
  func linkBuilder<Content: View>(
    for game: GameModel,
    @ViewBuilder content: () -> Content
  ) -> some View {
    NavigationLink(
      destination: HomeRouter().makeDetailView(for: game),
    ) { content() }
  }
}
