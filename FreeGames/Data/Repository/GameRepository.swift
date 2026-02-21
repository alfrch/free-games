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
  func getFavoriteGames() -> AnyPublisher<[GameModel], Error>
  func updateFavoriteGame(by gameId: String) -> AnyPublisher<GameModel, Error>
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
      .map { GameMapper.mapGameResponsesToEntities(input: $0) }
      .flatMap { entities -> AnyPublisher<[GameEntity], Error> in
        self.local.saveGames(entities)
      }
      .map { GameMapper.mapGameEntitiesToDomains(input: $0) }
      .eraseToAnyPublisher()
  }
  
  func getFavoriteGames() -> AnyPublisher<[GameModel], any Error> {
    return self.local.getFavoriteGames()
      .map { GameMapper.mapGameEntitiesToDomains(input: $0) }
      .eraseToAnyPublisher()
  }
  
  func updateFavoriteGame(by gameId: String) -> AnyPublisher<GameModel, any Error> {
    return self.local.updateFavoriteGame(by: gameId)
      .map { GameMapper.mapGameEntityToDomain(input: $0) }
      .eraseToAnyPublisher()
  }
}
