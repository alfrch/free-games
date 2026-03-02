//
//  Injection.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 17/01/26.
//

import Foundation
import RealmSwift
import Core
import Game

final class Injection {
  
  private let realm = try? Realm()
  
  func provideGames() -> Interactor<
    Any,
    [GameModel],
    GetGamesRepository<GetGamesLocalDataSource, GetGamesRemoteDataSource, GameTransformer>
  > {
    let local = GetGamesLocalDataSource(realm: realm!)
    let remote = GetGamesRemoteDataSource(endpoint: Endpoints.Gets.giveaways.url)
    let mapper = GameTransformer()
    
    let repository = GetGamesRepository(
      localDataSource: local,
      remoteDataSource: remote,
      mapper: mapper
    )
    return Interactor(repository: repository)
  }
  
  func provideFavorite() -> Interactor<
    Any,
    [GameModel],
    GetFavoriteGamesRepository<GetFavoriteGamesLocalDataSource, GameTransformer>
  > {
    let local = GetFavoriteGamesLocalDataSource(realm: realm)
    let mapper = GameTransformer()
    
    let repository = GetFavoriteGamesRepository(
      localDatasource: local,
      mapper: mapper
    )
    return Interactor(repository: repository)
  }
  
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
  
//  func provideFavorite() -> FavoriteUseCase {
//    let repository = provideRepository()
//    return FavoriteInteractor(repository: repository)
//  }
  
  func provideDetail(game: GameModel) -> GetGameDetailUsecase {
    let repository = provideRepository()
    return GetGameDetailInteractor(repository: repository, game: game)
  }
  
  func provideUpdateFavorite(game: GameModel) -> UpdateFavoriteGameUseCase {
    let repository = provideRepository()
    return UpdateFavoriteGameInteractor(repository: repository, game: game)
  }
  
  func provideSearch() -> SearchGamesUseCase {
    let repository = provideRepository()
    return SearchGamesInteractor(repository: repository)
  }
}
