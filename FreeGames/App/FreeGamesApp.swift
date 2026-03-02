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
  Any,
  [GameModel],
  GetGamesRepository<
    GetGamesLocalDataSource,
    GetGamesRemoteDataSource,
    GameTransformer>
> = injection.provideGames()

let favoriteUseCase: Interactor<
  Any,
  [GameModel],
  GetFavoriteGamesRepository<
    GetFavoriteGamesLocalDataSource,
    GameTransformer
  >
> = injection.provideFavorite()

@main
struct FreeGamesApp: SwiftUI.App {
  let homePresenter = GetListPresenter(useCase: gameUseCase)
  let favoritePresenter = GetListPresenter(useCase: favoriteUseCase)
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
