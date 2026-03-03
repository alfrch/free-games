//
//  FreeGamesApp.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 16/01/26.
//

import SwiftUI
import Core
import Game

let injection = Injection()

let gameUseCase: Interactor<
  String,
  [GameModel],
  GetGamesRepository<
    GetGamesLocalDataSource,
    GetGamesRemoteDataSource,
    GamesTransformer>
> = injection.provideGames()

let favoriteUseCase: Interactor<
  String,
  [GameModel],
  GetFavoriteGamesRepository<
    GetFavoriteGamesLocalDataSource,
    GamesTransformer
  >
> = injection.provideFavorite()

let searchUseCase: Interactor<
  String,
  [GameModel],
  SearchGamesRepository<SearchGamesLocalDataSource, GamesTransformer>
> = injection.provideSearch()

@main
struct FreeGamesApp: SwiftUI.App {
  let homePresenter = GetListPresenter(gamesUseCase: gameUseCase, searchUseCase: searchUseCase)
  let favoritePresenter = GetListPresenter(gamesUseCase: favoriteUseCase, searchUseCase: searchUseCase)
  let aboutPresenter = AboutPresenter()
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(homePresenter)
        .environmentObject(favoritePresenter)
        .environmentObject(aboutPresenter)
    }
  }
}
