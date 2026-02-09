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
  
  private let router = HomeRouter()
  private let useCase: HomeUseCase
  
  private var cancellables = Set<AnyCancellable>()
  private var allGames: [GameModel] = []
  
  init(useCase: HomeUseCase) {
    self.useCase = useCase
    self.setupFavoriteBinding()
  }
  
  private func setupFavoriteBinding() {
    useCase.getFavoriteIds()
      .receive(on: RunLoop.main)
      .sink { [weak self] ids in
        self?.favoriteIds = ids
      }
      .store(in: &cancellables)
  }
  
  private func applyFilter() {
    games = allGames.filter { favoriteIds.contains($0.id) }
  }
  
  func getGames() async {
    isLoading = true
    defer { isLoading = false }
    
    do {
      let result = try await useCase.getGames()
      self.allGames = result
      applyFilter()
    } catch {
      self.errorMessage = error.localizedDescription
    }
  }
  
  func toggleFavorite(for gameId: Int) {
    useCase.updateFavoriteId(id: gameId)
  }
  
  func isFavorite(_ gameId: Int) -> Bool {
    favoriteIds.contains(gameId)
  }
  
  func linkBuilder<Content: View>(
    for game: GameModel,
    @ViewBuilder content: () -> Content
  ) -> some View {
    NavigationLink(
      destination: router.makeDetailView(for: game)) {
        content()
      }
  }
}
