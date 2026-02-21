//
//  FavoriteInteractor.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 21/02/26.
//

import Foundation
import Combine

protocol FavoriteUseCase {
  func getFavoriteGames() -> AnyPublisher<[GameModel], Error>
}

final class FavoriteInteractor: FavoriteUseCase {
  
  private let repository: GameRepositoryProtocol
  
  required init(repository: GameRepositoryProtocol) {
    self.repository = repository
  }
  
  func getFavoriteGames() -> AnyPublisher<[GameModel], any Error> {
    return repository.getFavoriteGames()
  }
}
