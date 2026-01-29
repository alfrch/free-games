//
//  MockRemoteDataSource.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 26/01/26.
//

import XCTest
@testable import FreeGames

final class MockRemoteDataSource: RemoteDataSourceProtocol {
  
  var result: Result<[GameResponse], Error> = .success([])
  var isGetGamesCalled = false
  
  func getGames() async throws -> [GameResponse] {
    isGetGamesCalled = true
    
    switch result {
    case .success(let games):
      return games
    case .failure(let error):
      throw error
    }
  }
}
