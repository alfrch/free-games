//
//  LocalDataSource.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 18/01/26.
//

import Foundation
import Combine

protocol LocalDataSourceProtocol: AnyObject {
  func getFavoritedIds() -> AnyPublisher<Set<Int>, Never>
  func toggleFavorite(id: Int)
}

final class LocalDataSource: LocalDataSourceProtocol {
  
  static let shared = LocalDataSource()
  
  private let favoritesKey = "user_favorites_games"
  private let defaults = UserDefaults.standard
  private let favoriteSubject: CurrentValueSubject<Set<Int>, Never>
  
  private init() {
    let stored = defaults.array(forKey: favoritesKey) as? [Int] ?? []
    favoriteSubject = CurrentValueSubject(Set(stored))
  }
  
  func getFavoritedIds() -> AnyPublisher<Set<Int>, Never> {
    favoriteSubject.eraseToAnyPublisher()
  }
  
  func toggleFavorite(id: Int) {
    var favorites = favoriteSubject.value
    
    if favorites.contains(id) {
      favorites.remove(id)
    } else {
      favorites.insert(id)
    }
    
    defaults.set(Array(favorites), forKey: favoritesKey)
    favoriteSubject.value = favorites
    favoriteSubject.send(favorites)
  }
}
