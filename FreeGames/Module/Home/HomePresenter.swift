//
//  HomePresenter.swift
//  FreeGames
//
//  Created by Alif Rachmawan on 17/01/26.
//

import SwiftUI
import Combine

@MainActor
class HomePresenter: ObservableObject {
  
  @Published var games: [GameModel] = []
  @Published var favoriteIds: Set<Int> = []
  @Published var errorMessage: String?
  @Published var isLoading = false
  @Published var searchText = ""
  
  private let router = HomeRouter()
  private let useCase: HomeUseCase
  
  private var allGames: [GameModel] = []
  private var cancellables = Set<AnyCancellable>()
  
  init(useCase: HomeUseCase) {
    self.useCase = useCase
    setupSearchBinding()
  }
  
  private func setupSearchBinding() {
    $searchText
      .debounce(for: .milliseconds(350), scheduler: RunLoop.main)
      .removeDuplicates()
      .sink { [weak self] keyword in
        guard let self else { return }
        
        if keyword.isEmpty {
          self.games = self.allGames
        } else {
          self.games = self.allGames.filter {
            $0.title.localizedCaseInsensitiveContains(keyword)
          }
        }
      }
      .store(in: &cancellables)
  }
  
  private func getGames() async {
    isLoading = true
    defer { isLoading = false }
    
    refreshFavorites()
    
    do {
      let result = try await useCase.getGames()
      self.allGames = result
      self.games = result
    } catch {
      self.errorMessage = error.localizedDescription
    }
  }
  
  func loadIfNeeded() async {
    guard allGames.isEmpty else { return }
    await getGames()
  }
  
  func refreshFavorites() {
    self.favoriteIds = useCase.getFavoriteIds()
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
  
  func linkBuilder<Content: View>(
    for game: GameModel,
    @ViewBuilder content: () -> Content
  ) -> some View {
    NavigationLink(
      destination: router.makeDetailView(for: game)) { content() }
  }
}
