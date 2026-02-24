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
  
  func provideDetail(game: GameModel) -> GetGameDetailUsecase {
    let repository = provideRepository()
    return GetGameDetailInteractor(repository: repository, game: game)
  }
  
  func provideUpdateFavorite(game: GameModel) -> UpdateFavoriteGameUseCase {
    let repository = provideRepository()
    return UpdateFavoriteGameInteractor(repository: repository, game: game)
  }
}
