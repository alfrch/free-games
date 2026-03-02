//
//  HomeView.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 16/01/26.
//

import SwiftUI
import Core
import Game

struct HomeView: View {
  @ObservedObject var presenter: GetListPresenter<
    Any,
    GameModel,
    Interactor<
      Any,
      [GameModel],
      GetGamesRepository<
        GetGamesLocalDataSource,
        GetGamesRemoteDataSource,
        GamesTransformer
      >
    >
  >
  
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
//    .searchable(
//      text: presenter.searchText,
//      placement: .navigationBarDrawer(displayMode: .always),
//      prompt: "Search games..."
//    )
    .onAppear {
      if self.presenter.list.isEmpty {
        self.presenter.getList(request: nil)
      }
    }
  }
}

extension HomeView {
  var headerView: some View {
    HeaderView(
      title: "Free Games",
      subtitle: "Discover amazing free games to play"
    )
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
