//
//  DetailPresenter.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 18/01/26.
//

import SwiftUI
import Combine

@MainActor
final class DetailPresenter: ObservableObject {
  @Published var game: GameModel
  @Published var isFavorite = false
  
  private let useCase: DetailUseCase
  
  init(useCase: DetailUseCase, game: GameModel) {
    self.useCase = useCase
    self.game = game
    checkFavoriteStatus()
  }
  
  func checkFavoriteStatus() {
    let favorites = useCase.getFavoriteIds()
    self.isFavorite = favorites.contains(game.id)
  }
  
  func toggleFavorite() {
    useCase.updateFavoriteId(id: game.id)
    isFavorite.toggle()
  }
}
