//
//  Injection.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 17/01/26.
//

import Foundation

final class Injection {
  
  private func provideRepository() -> GameRepositoryProtocol {
    return GameRepository(
      remote: RemoteDataSource.shared,
      local: LocalDataSource.shared
    )
  }
  
  func provideHome() -> HomeUseCase {
    let repository = provideRepository()
    return HomeInteractor(repository: repository)
  }
}
