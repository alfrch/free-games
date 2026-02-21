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
  }
  
  private func applyFilter() {
    games = allGames.filter { favoriteIds.contains($0.id) }
  }
  
  func getGames() {
    isLoading = true
    defer { isLoading = false }
    
    useCase.getGames()
      .receive(on: RunLoop.main)
      .sink { [weak self] completion in
        guard let self else { return }
        switch completion {
        case .finished: break
        case .failure(let error):
          self.errorMessage = error.localizedDescription
        }
      } receiveValue: { [weak self] result in
        guard let self else { return }
        self.allGames = result
        applyFilter()
      }
      .store(in: &cancellables)
  }
  
  func toggleFavorite(for gameId: Int) {
    getGames()
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
