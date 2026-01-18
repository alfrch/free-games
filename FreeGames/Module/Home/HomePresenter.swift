//
//  HomePresenter.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 17/01/26.
//

import Foundation
import Combine

@MainActor
class HomePresenter: ObservableObject {
  
  @Published var games: [GameModel] = []
  @Published var favoriteIds: Set<Int> = []
  @Published var errorMessage: String?
  @Published var isLoading = false
  
  private let useCase: HomeUseCase
  
  init(useCase: HomeUseCase) {
    self.useCase = useCase
  }
  
  func getGames() async {
    isLoading = true
    defer { isLoading = false }
    
    self.favoriteIds = useCase.getFavoriteIds()
    
    do {
      self.games = try await useCase.getGames()
    } catch {
      self.errorMessage = error.localizedDescription
    }
  }
  
  func toggleFavorite(for gameId: Int) {
    useCase.updateFavoriteId(id: gameId)
    
    if favoriteIds.contains(gameId) {
      favoriteIds.remove(gameId)
    } else {
      favoriteIds.insert(gameId)
    }
  }
  
  func isFavorite(_ gameId: Int) -> Bool {
    favoriteIds.contains(gameId)
  }
}
