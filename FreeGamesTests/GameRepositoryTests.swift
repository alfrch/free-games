//
//  GameRepositoryTests.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 26/01/26.
//

import XCTest
@testable import FreeGames

@MainActor
final class GameRepositoryTests: XCTestCase {
  
  private var sut: GameRepository! // System Under Test
  private var mockRemote: MockRemoteDataSource!
  private var mockLocal: MockLocalDataSource!
  
  override func setUp() {
    super.setUp()
    mockRemote = MockRemoteDataSource()
    mockLocal = MockLocalDataSource()
    // Dependency Injection
    sut = GameRepository(remote: mockRemote, local: mockLocal)
  }
  
  override func tearDown() {
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
    
    // When
    let games = try await sut.getGames()
    
    // Then
    let firstGame = games.first
    XCTAssertEqual(firstGame, expectedModel)
  }
  
  func test_getGames_failed_shouldThrowError() async {
    // Given
    mockRemote.result = .failure(NetworkError.invalidResponse)
    
    // When & Then
    do {
      _ = try await sut.getGames()
    } catch {
      XCTAssertEqual(error as? NetworkError, .invalidResponse, "Error yang dilempar seharusnya invalidResponse")
    }
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
