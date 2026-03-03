//
//  HomeRouter.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 18/01/26.
//

import SwiftUI
import Game
import Core

class HomeRouter {
  
  func makeDetailView(for game: GameModel) -> some View {
    let gameUseCase: Interactor<
      String,
      GameModel,
      GetGameRepository<GetGamesLocalDataSource, GameTransformer>
    > = Injection().provideGame()
    
    let favoriteUseCase: Interactor<
      String,
      GameModel,
      UpdateFavoriteGameRepository<GetFavoriteGamesLocalDataSource, GameTransformer>
    > = Injection().provideUpdateFavorite()
    
    let presenter = GamePresenter(gameUseCase: gameUseCase, favoriteUseCase: favoriteUseCase)
    return DetailView(presenter: presenter, game: game)
  }
}
