//
//  Injection.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 17/01/26.
//

import Foundation

final class Injection {
  
  private static let sharedRepository: GameRepositoryProtocol = {
    return GameRepository(
      remote: RemoteDataSource.shared,
      local: LocalDataSource.shared
    )
  }()
  
  private func provideRepository() -> GameRepositoryProtocol {
    return Self.sharedRepository
  }
  
  func provideHome() -> HomeUseCase {
    let repository = provideRepository()
    return HomeInteractor(repository: repository)
  }
  
  func provideDetail() -> DetailUseCase {
    let repository = provideRepository()
    return DetailInteractor(repository: repository)
  }
}
