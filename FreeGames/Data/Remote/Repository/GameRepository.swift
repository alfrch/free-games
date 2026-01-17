//
//  GameRepository.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 17/01/26.
//

import Foundation

protocol GameRepositoryProtocol {
  func getGames() async throws -> [GameModel]
}

final class GameRepository: GameRepositoryProtocol {
  
  private let remote: RemoteDataSource
  
  init(remote: RemoteDataSource) {
    self.remote = remote
  }
  
  static let shared: GameRepository = {
    return GameRepository(remote: RemoteDataSource.shared)
  }()
  
  func getGames() async throws -> [GameModel] {
    do {
      let gameResponses = try await remote.getGames()
      return GameMapper.mapGameResponsesToDomains(input: gameResponses)
    } catch {
      throw error
    }
  }
}
