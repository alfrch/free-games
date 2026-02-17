//
//  MockLocalDataSource.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 26/01/26.
//

import XCTest
import Combine
@testable import FreeGames

final class MockLocalDataSource: LocalDataSourceProtocol {
  
  private let subject: CurrentValueSubject<Set<Int>, Never>
  
  var mockIds: Set<Int> {
    get { subject.value }
    set { subject.value = newValue }
  }
  var toggleCalledWithId: Int?
  
  init(initialIds: Set<Int> = []) {
    subject = CurrentValueSubject(initialIds)
  }
  
  func getFavoritedIds() -> AnyPublisher<Set<Int>, Never> {
    subject.eraseToAnyPublisher()
  }
  
  func getFavoritedIds() -> Set<Int> {
    return mockIds
  }
  
  func toggleFavorite(id: Int) {
    toggleCalledWithId = id
    
    var current = subject.value
    
    if current.contains(id) {
      current.remove(id)
    } else {
      current.insert(id)
    }
    
    subject.send(current)
  }
}
