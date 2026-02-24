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
  private let getGamesUseCase: GetGamesUseCase
  
  private var allGames: [GameModel] = []
  private var cancellables = Set<AnyCancellable>()
  
  init(getGamesUseCase: GetGamesUseCase) {
    self.getGamesUseCase = getGamesUseCase
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
  
  private func getGames() {
    isLoading = true
    defer { isLoading = false }
    
    getGamesUseCase.execute()
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
        self.games = result
      }
      .store(in: &cancellables)
  }
  
  func loadIfNeeded() {
    guard allGames.isEmpty else { return }
    getGames()
  }
  
  func linkBuilder<Content: View>(
    for game: GameModel,
    @ViewBuilder content: () -> Content
  ) -> some View {
    NavigationLink(
      destination: router.makeDetailView(for: game)) { content() }
  }
}
