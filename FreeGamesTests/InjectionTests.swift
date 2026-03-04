//
//  InjectionTests.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 04/03/26.
//

import XCTest
import RealmSwift
@testable import FreeGames
import Core
import Game

final class InjectionTests: XCTestCase {
  
  private var injection: Injection!
  
  override func setUp() {
    super.setUp()
    let realm = makeInMemoryRealm()
    injection = Injection(realm: realm)
  }
  
  override func tearDown() {
    injection = nil
    super.tearDown()
  }
  
  func test_provideGames_shouldReturnInteractor() {
    let useCase = injection.provideGames()
    XCTAssertNotNil(useCase)
  }
  
  func test_provideGame_shouldReturnInteractor() {
    let useCase = injection.provideGame()
    XCTAssertNotNil(useCase)
  }
  
  func test_provideFavorite_shouldReturnInteractor() {
    let useCase = injection.provideFavorite()
    XCTAssertNotNil(useCase)
  }
  
  func test_provideUpdateFavorite_shouldReturnInteractor() {
    let useCase = injection.provideUpdateFavorite()
    XCTAssertNotNil(useCase)
  }
  
  func test_provideSearch_shouldReturnInteractor() {
    let useCase = injection.provideSearch()
    XCTAssertNotNil(useCase)
  }
  
  private func makeInMemoryRealm() -> Realm {
    var config = Realm.Configuration()
    config.inMemoryIdentifier = UUID().uuidString
    
    do {
      return try Realm(configuration: config)
    } catch {
      XCTFail("Failed to create in-memory Realm: \(error)")
      fatalError("Realm initialization failed")
    }
  }
}
