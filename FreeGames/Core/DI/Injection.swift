//
//  Injection.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 17/01/26.
//

import Foundation
import RealmSwift

final class Injection {
  
  private static let sharedRepository: GameRepositoryProtocol = {
    let realm = try? Realm()
    
    return GameRepository(
      remote: RemoteDataSource.shared,
      local: LocalDataSource.shared(realm)
    )
  }()
  
  private func provideRepository() -> GameRepositoryProtocol {
    return Self.sharedRepository
  }
  
  func provideHome() -> HomeUseCase {
    let repository = provideRepository()
    return HomeInteractor(repository: repository)
  }
  
  func provideDetail(game: GameModel) -> DetailUseCase {
    let repository = provideRepository()
    return DetailInteractor(repository: repository, game: game)
  }
}
