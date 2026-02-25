//
//  MockLocalDataSource.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 26/01/26.
//

import XCTest
import Combine
@testable import FreeGames

final class MockLocalDataSource: LocalDataSourceProtocol {
  
  var getGamesResult: Result<[GameEntity], Error> = .success([])
  var getGameResult: Result<GameEntity, Error> = .failure(DatabaseError.requestFailed)
  var saveGamesResult: Result<[GameEntity], Error> = .success([])
  var getFavoriteGamesResult: Result<[GameEntity], Error> = .success([])
  var updateFavoriteGameResult: Result<GameEntity, Error> = .failure(DatabaseError.requestFailed)
  var searchGamesResult: Result<[GameEntity], Error> = .success([])
  
  func getGames() -> AnyPublisher<[GameEntity], Error> {
    getGamesResult.publisher.eraseToAnyPublisher()
  }
  
  func getGame(by id: String) -> AnyPublisher<GameEntity, Error> {
    getGameResult.publisher.eraseToAnyPublisher()
  }
  
  func saveGames(_ games: [GameEntity]) -> AnyPublisher<[GameEntity], Error> {
    saveGamesResult.publisher.eraseToAnyPublisher()
  }
  
  func getFavoriteGames() -> AnyPublisher<[GameEntity], Error> {
    getFavoriteGamesResult.publisher.eraseToAnyPublisher()
  }
  
  func updateFavoriteGame(by gameId: String) -> AnyPublisher<GameEntity, Error> {
    updateFavoriteGameResult.publisher.eraseToAnyPublisher()
  }
  
  func searchGames(with text: String) -> AnyPublisher<[GameEntity], Error> {
    searchGamesResult.publisher.eraseToAnyPublisher()
  }
}
