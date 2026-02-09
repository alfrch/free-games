//
//  DetailInteractor.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 18/01/26.
//

import Foundation
import Combine

protocol DetailUseCase {
  func getFavoriteIds() -> AnyPublisher<Set<Int>, Never>
  func updateFavoriteId(id: Int)
}

final class DetailInteractor: DetailUseCase {
  private let repository: GameRepositoryProtocol
  
  init(repository: GameRepositoryProtocol) {
    self.repository = repository
  }
  
  func getFavoriteIds() -> AnyPublisher<Set<Int>, Never> {
    return repository.getFavoriteIds()
  }
  
  func updateFavoriteId(id: Int) {
    repository.updateFavorite(id: id)
  }
}
