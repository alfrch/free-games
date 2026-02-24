//
//  Untitled.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 21/02/26.
//

import Foundation
import Combine

protocol GetGamesUseCase {
  func execute() -> AnyPublisher<[GameModel], Error>
}

final class GetGamesInteractor: GetGamesUseCase {
  
  private let repository: GameRepositoryProtocol
  
  init(repository: GameRepositoryProtocol) {
    self.repository = repository
  }
  
  func execute() -> AnyPublisher<[GameModel], Error> {
    return repository.getGames()
  }
}
