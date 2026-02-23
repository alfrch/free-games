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
    return self.local.getGames()
      .flatMap { result -> AnyPublisher<[GameModel], Error> in
        if result.isEmpty {
          return self.remote.getGames()
            .map { GameMapper.mapGameResponsesToEntities(input: $0) }
            .catch { _ in self.local.getGames() }
            .flatMap { self.local.saveGames($0) }
            .flatMap { _ in self.local.getGames() }
            .map { GameMapper.mapGameEntitiesToDomains(input: $0) }
            .eraseToAnyPublisher()
        } else {
          return self.local.getGames()
            .map { GameMapper.mapGameEntitiesToDomains(input: $0) }
            .eraseToAnyPublisher()
        }
      }
      .eraseToAnyPublisher()
  }
  
  func getFavoriteGames() -> AnyPublisher<[GameModel], Error> {
    return self.local.getFavoriteGames()
      .map { GameMapper.mapGameEntitiesToDomains(input: $0) }
      .eraseToAnyPublisher()
  }
  
  func updateFavoriteGame(by gameId: String) -> AnyPublisher<GameModel, Error> {
    return self.local.updateFavoriteGame(by: gameId)
      .map { GameMapper.mapGameEntityToDomain(input: $0) }
      .eraseToAnyPublisher()
  }
}
