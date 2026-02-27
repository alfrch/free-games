//
//  HomeRouter.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 18/01/26.
//

import SwiftUI
import Game

class HomeRouter {
  
  func makeDetailView(for game: GameModel) -> some View {
    let getDetailUseCase = Injection().provideDetail(game: game)
    let updateFavoriteUseCase = Injection().provideUpdateFavorite(game: game)
    let presenter = DetailPresenter(getDetailUseCase: getDetailUseCase, updateFavoriteUseCase: updateFavoriteUseCase)
    return DetailView(presenter: presenter)
  }
}
