//
//  FavoritePresenter.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 18/01/26.
//

import SwiftUI
import Combine

@MainActor
final class FavoritePresenter: ObservableObject {
  
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
      let allGames = try await useCase.getGames()
      self.games = allGames.filter { favoriteIds.contains($0.id) }
    } catch {
      self.errorMessage = error.localizedDescription
    }
  }
  
  func toggleFavorite(for gameId: Int) {
    useCase.updateFavoriteId(id: gameId)
    
    if favoriteIds.contains(gameId) {
      favoriteIds.remove(gameId)
      games.removeAll { $0.id == gameId }
    } else {
      favoriteIds.insert(gameId)
    }
  }
  
  func isFavorite(_ gameId: Int) -> Bool {
    favoriteIds.contains(gameId)
  }
}
