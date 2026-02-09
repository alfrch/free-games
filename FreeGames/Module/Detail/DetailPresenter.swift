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
  private var cancellables = Set<AnyCancellable>()
  
  init(useCase: DetailUseCase, game: GameModel) {
    self.useCase = useCase
    self.game = game
    setupFavoriteBinding()
  }
  
  private func setupFavoriteBinding() {
    useCase.getFavoriteIds()
      .sink { [weak self] ids in
        guard let self else { return }
        self.isFavorite = ids.contains(self.game.id)
      }
      .store(in: &cancellables)
  }
  
  func toggleFavorite() {
    useCase.updateFavoriteId(id: game.id)
  }
}
