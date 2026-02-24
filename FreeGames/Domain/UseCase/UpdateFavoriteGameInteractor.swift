//
//  UpdateFavoriteGameInteractor.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 24/02/26.
//

import Foundation
import Combine

protocol UpdateFavoriteGameUseCase {
  func execute() -> AnyPublisher<GameModel, Error>
}

final class UpdateFavoriteGameInteractor: UpdateFavoriteGameUseCase {
  
  private let repository: GameRepositoryProtocol
  private let game: GameModel
  
  init(repository: GameRepositoryProtocol, game: GameModel) {
    self.repository = repository
    self.game = game
  }
  
  func execute() -> AnyPublisher<GameModel, Error> {
    return repository.updateFavoriteGame(by: "\(game.id)")
  }
}
