//
//  LocalDataSource.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 18/01/26.
//

import Foundation

protocol LocalDataSourceProtocol: AnyObject {
  func getFavoritedIds() -> Set<Int>
  func toggleFavorite(id: Int)
}

final class LocalDataSource: LocalDataSourceProtocol {
  
  static let shared = LocalDataSource()
  private let favoritesKey = "user_favorites_games"
  private let defaults = UserDefaults.standard
  
  private init() {}
  
  func getFavoritedIds() -> Set<Int> {
    let array = defaults.array(forKey: favoritesKey) as? [Int] ?? []
    return Set(array)
  }
  
  func toggleFavorite(id: Int) {
    var favorites = getFavoritedIds()
    
    if favorites.contains(id) {
      favorites.remove(id)
    } else {
      favorites.insert(id)
    }
    
    defaults.set(Array(favorites), forKey: favoritesKey)
  }
}
