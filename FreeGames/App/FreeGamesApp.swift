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
  [GameDomainModel],
  GetGamesRepository<
    GetGamesLocalDataSource,
    GetGamesRemoteDataSource,
    GameTransformer>
> = injection.provideGames()

@main
struct FreeGamesApp: SwiftUI.App {
  let homePresenter = GetListPresenter(useCase: gameUseCase)
  let favoritePresenter = FavoritePresenter(useCase: Injection().provideFavorite())
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
