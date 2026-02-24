//
//  GetGameDetailInteractor.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 24/02/26.
//

import Foundation
import Combine

protocol GetGameDetailUsecase {
  func execute() -> AnyPublisher<GameModel, Error>
}

final class GetGameDetailInteractor: GetGameDetailUsecase {
  
  private let repository: GameRepositoryProtocol
  private let game: GameModel
  
  init(repository: GameRepositoryProtocol, game: GameModel) {
    self.repository = repository
    self.game = game
  }
  
  func execute() -> AnyPublisher<GameModel, Error> {
    return repository.getGame(by: "\(game.id)")
  }
}
