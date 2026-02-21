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
  
  func provideGames() -> GetGamesUseCase {
    let repository = provideRepository()
    return GetGamesInteractor(repository: repository)
  }
  
  func provideFavorite() -> FavoriteUseCase {
    let repository = provideRepository()
    return FavoriteInteractor(repository: repository)
  }
  
  func provideDetail(game: GameModel) -> DetailUseCase {
    let repository = provideRepository()
    return DetailInteractor(repository: repository, game: game)
  }
}
