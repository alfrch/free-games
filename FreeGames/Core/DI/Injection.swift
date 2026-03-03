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
    String,
    [GameModel],
    GetGamesRepository<GetGamesLocalDataSource, GetGamesRemoteDataSource, GamesTransformer>
  > {
    let local = GetGamesLocalDataSource(realm: realm!)
    let remote = GetGamesRemoteDataSource(endpoint: Endpoints.Gets.giveaways.url)
    let mapper = GamesTransformer()
    
    let repository = GetGamesRepository(
      localDataSource: local,
      remoteDataSource: remote,
      mapper: mapper
    )
    return Interactor(repository: repository)
  }
  
  func provideGame() -> Interactor<
    String,
    GameModel,
    GetGameRepository<GetGamesLocalDataSource, GameTransformer>
  > {
    let local = GetGamesLocalDataSource(realm: realm!)
    let mapper = GameTransformer()
    
    let repository = GetGameRepository(
      localDataSource: local,
      mapper: mapper
    )
    return Interactor(repository: repository)
  }
  
  func provideFavorite() -> Interactor<
    String,
    [GameModel],
    GetFavoriteGamesRepository<GetFavoriteGamesLocalDataSource, GamesTransformer>
  > {
    let local = GetFavoriteGamesLocalDataSource(realm: realm)
    let mapper = GamesTransformer()
    
    let repository = GetFavoriteGamesRepository(
      localDatasource: local,
      mapper: mapper
    )
    return Interactor(repository: repository)
  }
  
  func provideUpdateFavorite() -> Interactor<
    String,
    GameModel,
    UpdateFavoriteGameRepository<GetFavoriteGamesLocalDataSource, GameTransformer>
  > {
    let local = GetFavoriteGamesLocalDataSource(realm: realm)
    let mapper = GameTransformer()
    
    let repository = UpdateFavoriteGameRepository(
      localDataSource: local,
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
  
  func provideSearch() -> SearchGamesUseCase {
    let repository = provideRepository()
    return SearchGamesInteractor(repository: repository)
  }
}
