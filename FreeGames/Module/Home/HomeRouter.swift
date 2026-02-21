//
//  HomeRouter.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 18/01/26.
//

import SwiftUI

class HomeRouter {
  
  func makeDetailView(for game: GameModel) -> some View {
    let detailUseCase = Injection().provideDetail(game: game)
    let presenter = DetailPresenter(detailUseCase: detailUseCase)
    return DetailView(presenter: presenter)
  }
}
