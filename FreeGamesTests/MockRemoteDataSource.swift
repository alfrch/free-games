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
  
  var result: Result<[GameResponse], Error> = .success([])
  var isGetGamesCalled = false
  
  private let subject = PassthroughSubject<[GameResponse], Error>()
  var useSubject = false
  
  func getGames() -> AnyPublisher<[GameResponse], Error> {
    isGetGamesCalled = true
    
    if useSubject {
      return subject.eraseToAnyPublisher()
    }
    
    switch result {
    case .success(let games):
      return Just(games)
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
      
    case .failure(let error):
      return Fail(error: error)
        .eraseToAnyPublisher()
    }
  }
}
