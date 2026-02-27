//
//  ContentView.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 16/01/26.
//

import SwiftUI
import Core
import Game

struct ContentView: View {
  @EnvironmentObject var homePresenter: GetListPresenter<
    Any,
    GameModel,
    Interactor<
      Any,
      [GameModel],
      GetGamesRepository<
        GetGamesLocalDataSource,
        GetGamesRemoteDataSource,
        GameTransformer
      >
    >
  >
  @EnvironmentObject var favoritePresenter: FavoritePresenter
  
  var body: some View {
    TabView {
      NavigationStack {
        HomeView(presenter: homePresenter)
      }
      .tabItem {
        Label("Home", systemImage: "house.fill")
      }
      
      NavigationStack {
        FavoriteView(presenter: favoritePresenter)
      }
      .tabItem {
        Label("Favorite", systemImage: "heart.fill")
      }
      
      NavigationStack {
        AboutView()
      }
      .tabItem {
        Label("About", systemImage: "person.fill")
      }
    }
  }
}

#Preview {
  ContentView()
}
