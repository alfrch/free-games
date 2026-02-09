//
//  HomeUseCase.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 17/01/26.
//

import Foundation
import Combine

protocol HomeUseCase {
  func getGames() -> AnyPublisher<[GameModel], Error>
  func getFavoriteIds() -> AnyPublisher<Set<Int>, Never>
  func updateFavoriteId(id: Int)
}

final class HomeInteractor: HomeUseCase {
  private let repository: GameRepositoryProtocol
  
  init(repository: GameRepositoryProtocol) {
    self.repository = repository
  }
  
  func getGames() -> AnyPublisher<[GameModel], Error> {
    return repository.getGames()
  }
  
  func getFavoriteIds() -> AnyPublisher<Set<Int>, Never> {
    return repository.getFavoriteIds()
  }
  
  func updateFavoriteId(id: Int) {
    repository.updateFavorite(id: id)
  }
}
