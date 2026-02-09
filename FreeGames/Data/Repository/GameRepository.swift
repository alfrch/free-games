//
//  GameRepository.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 17/01/26.
//

import Foundation
import Combine

protocol GameRepositoryProtocol {
  func getGames() -> AnyPublisher<[GameModel], Error>
  func getFavoriteIds() -> AnyPublisher<Set<Int>, Never>
  func updateFavorite(id: Int)
}

final class GameRepository: GameRepositoryProtocol {
  
  private let remote: RemoteDataSourceProtocol
  private let local: LocalDataSourceProtocol
  
  init(
    remote: RemoteDataSourceProtocol,
    local: LocalDataSourceProtocol
  ) {
    self.remote = remote
    self.local = local
  }
  
  func getGames() -> AnyPublisher<[GameModel], Error> {
    return remote.getGames()
      .map { GameMapper.mapGameResponsesToDomains(input: $0) }
      .eraseToAnyPublisher()
  }
  
  func getFavoriteIds() -> AnyPublisher<Set<Int>, Never> {
    return local.getFavoritedIds()
  }
  
  func updateFavorite(id: Int) {
    local.toggleFavorite(id: id)
  }
}
