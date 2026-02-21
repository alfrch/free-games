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
}

final class HomeInteractor: HomeUseCase {
  private let repository: GameRepositoryProtocol
  
  init(repository: GameRepositoryProtocol) {
    self.repository = repository
  }
  
  func getGames() -> AnyPublisher<[GameModel], Error> {
    return repository.getGames()
  }
}
