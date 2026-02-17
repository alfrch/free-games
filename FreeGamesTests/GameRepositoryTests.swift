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
  
  private var sut: GameRepository! // System Under Test
  private var mockRemote: MockRemoteDataSource!
  private var mockLocal: MockLocalDataSource!
  private var cancellables: Set<AnyCancellable>!
  
  override func setUp() {
    super.setUp()
    mockRemote = MockRemoteDataSource()
    mockLocal = MockLocalDataSource()
    cancellables = []
    // Dependency Injection
    sut = GameRepository(remote: mockRemote, local: mockLocal)
  }
  
  override func tearDown() {
    cancellables = nil
    sut = nil
    mockRemote = nil
    mockLocal = nil
    super.tearDown()
  }
  
  // MARK: - TESTS
  
  func test_getGames_success_fullComparison() async throws {
    // Given
    let mockResponse = [
      GameResponse(
        id: 1,
        title: "Cyberpunk",
        worth: "$60",
        thumbnail: "url",
        description: "Desc",
        type: "RPG",
        platforms: "PC, PS5",
        url: "url"
      )
    ]
    mockRemote.result = .success(mockResponse)
    
    let expectedModel = GameModel(
      id: 1,
      title: "Cyberpunk",
      price: "$60",
      thumbnail: "url",
      description: "Desc",
      type: "RPG",
      platforms: ["PC", "PS5"],
      url: "url"
    )
    
    let expectation = XCTestExpectation(description: "Receive mapped games")
    
    // When
    sut.getGames()
      .sink(
        receiveCompletion: { completion in
          if case .failure(let error) = completion {
            XCTFail("Unexpected error: \(error)")
          }
        },
        receiveValue: { games in
          // Then
          XCTAssertEqual(games.first, expectedModel)
          expectation.fulfill()
        }
      )
      .store(in: &cancellables)
    
//    wait(for: [expectation], timeout: 1)
    XCTAssertTrue(mockRemote.isGetGamesCalled)
  }
  
  func test_getGames_failed_shouldReturnError() {
    // Given
    mockRemote.result = .failure(NetworkError.invalidResponse)
    let expectation = XCTestExpectation(description: "Receive error")
    
    // When
    sut.getGames()
      .sink(
        receiveCompletion: { completion in
          if case .failure(let error) = completion {
            // Then
            XCTAssertEqual(error as? NetworkError, .invalidResponse)
            expectation.fulfill()
          }
        },
        receiveValue: { _ in
          XCTFail("Should not receive value")
        }
      )
      .store(in: &cancellables)
    
    wait(for: [expectation], timeout: 1)
  }
  
  func test_updateFavorite_shouldCallLocalDataSource() {
    // Given
    let gameId = 123
    
    // When
    sut.updateFavorite(id: gameId)
    
    // Then
    XCTAssertEqual(mockLocal.toggleCalledWithId, gameId)
    XCTAssertTrue(mockLocal.mockIds.contains(gameId))
  }
}
