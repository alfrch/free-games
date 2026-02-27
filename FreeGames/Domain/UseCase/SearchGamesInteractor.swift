//
//  SearchGamesInteractor.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 24/02/26.
//

import Foundation
import Combine
import Game

protocol SearchGamesUseCase {
  func execute(query: String) -> AnyPublisher<[GameModel], Error>
}

final class SearchGamesInteractor: SearchGamesUseCase {
  
  private let repository: GameRepositoryProtocol
  
  init(repository: GameRepositoryProtocol) {
    self.repository = repository
  }
  
  func execute(query: String) -> AnyPublisher<[GameModel], any Error> {
    return repository.searchGames(with: query)
  }
}
