//
//  MockLocalDataSource.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 26/01/26.
//

import XCTest
@testable import FreeGames

final class MockLocalDataSource: LocalDataSourceProtocol {
  
  var mockIds: Set<Int> = []
  var toggleCalledWithId: Int?
  
  func getFavoritedIds() -> Set<Int> {
    return mockIds
  }
  
  func toggleFavorite(id: Int) {
    toggleCalledWithId = id
    if mockIds.contains(id) {
      mockIds.remove(id)
    } else {
      mockIds.insert(id)
    }
  }
}
