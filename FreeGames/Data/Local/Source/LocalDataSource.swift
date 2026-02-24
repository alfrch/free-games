//
//  LocalDataSource.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 18/01/26.
//

import Foundation
import Combine
import RealmSwift

protocol LocalDataSourceProtocol: AnyObject {
  func getGames() -> AnyPublisher<[GameEntity], Error>
  func getGame(by id: String) -> AnyPublisher<GameEntity, Error>
  func saveGames(_ games: [GameEntity]) -> AnyPublisher<[GameEntity], Error>
  func getFavoriteGames() -> AnyPublisher<[GameEntity], Error>
  func updateFavoriteGame(by gameId: String) -> AnyPublisher<GameEntity, Error>
  func searchGames(with text: String) -> AnyPublisher<[GameEntity], Error>
}

final class LocalDataSource: LocalDataSourceProtocol {
  
  private let realm: Realm?
  
  private init(realm: Realm?) {
    self.realm = realm
  }
  
  static let shared: (Realm?) -> LocalDataSource = { realm in
    return LocalDataSource(realm: realm)
  }
  
  func getGames() -> AnyPublisher<[GameEntity], any Error> {
    Future { [weak self] completion in
      guard let self else { return }
      if let realm = self.realm {
        let gameEntities = {
          realm.objects(GameEntity.self)
            .sorted(by: \.title)
        }()
        completion(.success(gameEntities.toArray(ofType: GameEntity.self)))
      } else {
        completion(.failure(DatabaseError.invalidInstance))
      }
    }
    .eraseToAnyPublisher()
  }
  
  
  func getGame(by id: String) -> AnyPublisher<GameEntity, Error> {
    Future<GameEntity, Error> { completion in
      if let realm = self.realm {
        let games: Results<GameEntity> = {
          realm.objects(GameEntity.self)
            .filter("id = '\(id)'")
        }()
        
        guard let game = games.first else {
          completion(.failure(DatabaseError.requestFailed))
          return
        }
        
        completion(.success(game))
      } else {
        completion(.failure(DatabaseError.invalidInstance))
      }
    }
    .eraseToAnyPublisher()
  }
  
  func saveGames(_ games: [GameEntity]) -> AnyPublisher<[GameEntity], Error> {
    Future { completion in
      guard let realm = self.realm else {
        completion(.failure(DatabaseError.invalidInstance))
        return
      }
      
      do {
        try realm.write {
          realm.add(games, update: .all)
        }
        completion(.success(games))
      } catch {
        completion(.failure(DatabaseError.requestFailed))
      }
    }
    .eraseToAnyPublisher()
  }
  
  func getFavoriteGames() -> AnyPublisher<[GameEntity], any Error> {
    return Future<[GameEntity], Error> { [weak self] completion in
      guard let self else { return }
      if let realm = self.realm {
        let gameEntities = {
          realm.objects(GameEntity.self)
            .filter("favorite = \(true)")
            .sorted(byKeyPath: "title", ascending: true)
        }()
        completion(.success(gameEntities.toArray(ofType: GameEntity.self)))
      } else {
        completion(.failure(DatabaseError.invalidInstance))
      }
    }
    .eraseToAnyPublisher()
  }
  
  func updateFavoriteGame(
    by gameId: String
  ) -> AnyPublisher<GameEntity, Error> {
    
    Future { completion in
      guard let realm = self.realm else {
        completion(.failure(DatabaseError.invalidInstance))
        return
      }
      
      guard let gameEntity = realm.objects(GameEntity.self)
        .filter("id == %@", gameId)
        .first else {
        completion(.failure(DatabaseError.invalidInstance))
        return
      }
      
      do {
        try realm.write {
          gameEntity.favorite.toggle()
        }
        completion(.success(gameEntity))
      } catch {
        completion(.failure(DatabaseError.requestFailed))
      }
    }
    .eraseToAnyPublisher()
  }
  
  func searchGames(with text: String) -> AnyPublisher<[GameEntity], Error> {
    Future<[GameEntity], Error> { [weak self] completion in
      guard let self else { return }
      if let realm = self.realm {
        let gameEntities = {
          realm.objects(GameEntity.self)
            .filter("title contains[c] %@", text)
            .sorted(byKeyPath: "title", ascending: true)
        }()
        completion(.success(gameEntities.toArray(ofType: GameEntity.self)))
      } else {
        completion(.failure(DatabaseError.invalidInstance))
      }
    }
    .eraseToAnyPublisher()
  }
}

extension Results {
  
  func toArray<T>(ofType: T.Type) -> [T] {
    var array = [T]()
    for index in 0 ..< count {
      if let result = self[index] as? T {
        array.append(result)
      }
    }
    return array
  }
  
}
