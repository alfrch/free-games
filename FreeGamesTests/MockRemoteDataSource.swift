//
//  MockRemoteDataSource.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 26/01/26.
//

import XCTest
import Combine
@testable import FreeGames

final class MockRemoteDataSource: RemoteDataSourceProtocol {
  
  var getGamesResult: Result<[GameResponse], Error> = .success([])
  
  func getGames() -> AnyPublisher<[GameResponse], Error> {
    getGamesResult.publisher.eraseToAnyPublisher()
  }
}
