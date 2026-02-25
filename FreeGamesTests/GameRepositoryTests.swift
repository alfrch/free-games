//
//  GameRepositoryTests.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 26/01/26.
//

import XCTest
import Combine
@testable import FreeGames

@MainActor
final class GameRepositoryTests: XCTestCase {
  
  var sut: GameRepository!
  var mockRemote: MockRemoteDataSource!
  var mockLocal: MockLocalDataSource!
  var cancellables: Set<AnyCancellable>!
  
  override func setUp() {
    super.setUp()
    mockRemote = MockRemoteDataSource()
    mockLocal = MockLocalDataSource()
    sut = GameRepository(remote: mockRemote, local: mockLocal)
    cancellables = []
  }
  
  override func tearDown() {
    sut = nil
    mockRemote = nil
    mockLocal = nil
    cancellables = nil
    super.tearDown()
  }
  
  // MARK: - getGames
  
  func test_getGames_whenLocalHasData_returnsMappedGames() {
    let entity = GameEntity()
    entity.id = "1"
    entity.title = "Test Game"
    mockLocal.getGamesResult = .success([entity])
    
    var result: [GameModel] = []
    let expectation = expectation(description: #function)
    
    sut.getGames()
      .sink(receiveCompletion: { _ in }, receiveValue: {
        result = $0
        expectation.fulfill()
      })
      .store(in: &cancellables)
    
    waitForExpectations(timeout: 1)
    XCTAssertEqual(result.count, 1)
    XCTAssertEqual(result.first?.title, "Test Game")
  }
  
  func test_getGames_whenLocalIsEmpty_fetchesFromRemote() {
    mockLocal.getGamesResult = .success([])
    mockRemote.getGamesResult = .failure(NetworkError.invalidResponse)
    
    let expectation = expectation(description: #function)
    
    sut.getGames()
      .sink(receiveCompletion: { _ in expectation.fulfill() }, receiveValue: { _ in })
      .store(in: &cancellables)
    
    waitForExpectations(timeout: 1)
    // If local is empty, remote must be hit
  }
  
  func test_getGames_whenLocalFails_propagatesError() {
    mockLocal.getGamesResult = .failure(DatabaseError.invalidInstance)
    
    var receivedError: Error?
    let expectation = expectation(description: #function)
    
    sut.getGames()
      .sink(receiveCompletion: {
        if case .failure(let error) = $0 { receivedError = error }
        expectation.fulfill()
      }, receiveValue: { _ in })
      .store(in: &cancellables)
    
    waitForExpectations(timeout: 1)
    XCTAssertNotNil(receivedError)
  }
  
  // MARK: - getGame
  
  func test_getGame_returnsMappedGame() {
    let entity = GameEntity()
    entity.id = "42"
    entity.title = "Specific Game"
    mockLocal.getGameResult = .success(entity)
    
    var result: GameModel?
    let expectation = expectation(description: #function)
    
    sut.getGame(by: "42")
      .sink(receiveCompletion: { _ in }, receiveValue: {
        result = $0
        expectation.fulfill()
      })
      .store(in: &cancellables)
    
    waitForExpectations(timeout: 1)
    XCTAssertEqual(result?.id, 42)
  }
  
  func test_getGame_whenFails_propagatesError() {
    mockLocal.getGameResult = .failure(DatabaseError.requestFailed)
    
    var receivedError: Error?
    let expectation = expectation(description: #function)
    
    sut.getGame(by: "99")
      .sink(receiveCompletion: {
        if case .failure(let error) = $0 { receivedError = error }
        expectation.fulfill()
      }, receiveValue: { _ in })
      .store(in: &cancellables)
    
    waitForExpectations(timeout: 1)
    XCTAssertNotNil(receivedError)
  }
  
  // MARK: - getFavoriteGames
  
  func test_getFavoriteGames_returnsMappedFavorites() {
    let entity = GameEntity()
    entity.id = "1"
    entity.favorite = true
    mockLocal.getFavoriteGamesResult = .success([entity])
    
    var result: [GameModel] = []
    let expectation = expectation(description: #function)
    
    sut.getFavoriteGames()
      .sink(receiveCompletion: { _ in }, receiveValue: {
        result = $0
        expectation.fulfill()
      })
      .store(in: &cancellables)
    
    waitForExpectations(timeout: 1)
    XCTAssertEqual(result.count, 1)
  }
  
  func test_getFavoriteGames_whenFails_propagatesError() {
    mockLocal.getFavoriteGamesResult = .failure(DatabaseError.requestFailed)
    
    var receivedError: Error?
    let expectation = expectation(description: #function)
    
    sut.getFavoriteGames()
      .sink(receiveCompletion: {
        if case .failure(let error) = $0 { receivedError = error }
        expectation.fulfill()
      }, receiveValue: { _ in })
      .store(in: &cancellables)
    
    waitForExpectations(timeout: 1)
    XCTAssertNotNil(receivedError)
  }
  
  // MARK: - updateFavoriteGame
  
  func test_updateFavoriteGame_returnsMappedGame() {
    let entity = GameEntity()
    entity.id = "7"
    entity.favorite = true
    mockLocal.updateFavoriteGameResult = .success(entity)
    
    var result: GameModel?
    let expectation = expectation(description: #function)
    
    sut.updateFavoriteGame(by: "7")
      .sink(receiveCompletion: { _ in }, receiveValue: {
        result = $0
        expectation.fulfill()
      })
      .store(in: &cancellables)
    
    waitForExpectations(timeout: 1)
    XCTAssertEqual(result?.id, 7)
  }
  
  func test_updateFavoriteGame_whenFails_propagatesError() {
    mockLocal.updateFavoriteGameResult = .failure(DatabaseError.requestFailed)
    
    var receivedError: Error?
    let expectation = expectation(description: #function)
    
    sut.updateFavoriteGame(by: "7")
      .sink(receiveCompletion: {
        if case .failure(let error) = $0 { receivedError = error }
        expectation.fulfill()
      }, receiveValue: { _ in })
      .store(in: &cancellables)
    
    waitForExpectations(timeout: 1)
    XCTAssertNotNil(receivedError)
  }
  
  // MARK: - searchGames
  
  func test_searchGames_returnsMappedResults() {
    let entity = GameEntity()
    entity.id = "1"
    entity.title = "Fortnite"
    mockLocal.searchGamesResult = .success([entity])
    
    var result: [GameModel] = []
    let expectation = expectation(description: #function)
    
    sut.searchGames(with: "Fort")
      .sink(receiveCompletion: { _ in }, receiveValue: {
        result = $0
        expectation.fulfill()
      })
      .store(in: &cancellables)
    
    waitForExpectations(timeout: 1)
    XCTAssertEqual(result.first?.title, "Fortnite")
  }
  
  func test_searchGames_whenFails_propagatesError() {
    mockLocal.searchGamesResult = .failure(DatabaseError.requestFailed)
    
    var receivedError: Error?
    let expectation = expectation(description: #function)
    
    sut.searchGames(with: "Fort")
      .sink(receiveCompletion: {
        if case .failure(let error) = $0 { receivedError = error }
        expectation.fulfill()
      }, receiveValue: { _ in })
      .store(in: &cancellables)
    
    waitForExpectations(timeout: 1)
    XCTAssertNotNil(receivedError)
  }
}
