//
//  DetailInteractor.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 18/01/26.
//

import Foundation
import Combine

protocol DetailUseCase {
  func getGame() -> GameModel
  func updateFavoriteGame() -> AnyPublisher<GameModel, Error>
}

final class DetailInteractor: DetailUseCase {
  
  private let repository: GameRepositoryProtocol
  private let game: GameModel
  
  init(repository: GameRepositoryProtocol, game: GameModel) {
    self.repository = repository
    self.game = game
  }
  
  func getGame() -> GameModel {
    return game
  }
  
  func updateFavoriteGame() -> AnyPublisher<GameModel, Error> {
    return repository.updateFavoriteGame(by: "\(game.id)")
  }
}
