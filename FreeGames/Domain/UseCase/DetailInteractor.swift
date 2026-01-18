//
//  DetailInteractor.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 18/01/26.
//

import Foundation

protocol DetailUseCase {
  func getFavoriteIds() -> Set<Int>
  func updateFavoriteId(id: Int)
}

final class DetailInteractor: DetailUseCase {
  private let repository: GameRepositoryProtocol
  
  init(repository: GameRepositoryProtocol) {
    self.repository = repository
  }
  
  func getFavoriteIds() -> Set<Int> {
    return repository.getFavoriteIds()
  }
  
  func updateFavoriteId(id: Int) {
    repository.updateFavorite(id: id)
  }
}
